import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/sessions/domain/repositories/session_repository.dart';
import '../../domain/entities/player_stats.dart';
import '../../domain/repositories/player_repository.dart';

class GetPlayerStats {
  final SessionRepository sessionRepository;
  final PlayerRepository playerRepository;

  GetPlayerStats({required this.sessionRepository, required this.playerRepository});

  Future<Either<Failure, PlayerStats>> call(String playerId) async {
    final sessionsResult = await sessionRepository.getSessionHistory();

    return sessionsResult.fold((failure) => Left(failure), (allSessions) async {
      final playerSessions = allSessions.where((s) => s.isCompleted && (s.team1PlayerIds.contains(playerId) || s.team2PlayerIds.contains(playerId))).toList();

      if (playerSessions.isEmpty) {
        return const Right(PlayerStats(totalGames: 0, wins: 0, losses: 0, winRate: 0.0, currentStreak: 0, bestPartner: 'N/A', nemesis: 'N/A'));
      }

      int totalGames = playerSessions.length;
      int wins = 0;
      int losses = 0;
      int currentStreak = 0;

      // Sort by date to calculate streak
      playerSessions.sort((a, b) => a.date.compareTo(b.date));

      // Calculate basic stats and streak
      for (var session in playerSessions) {
        bool isTeam1 = session.team1PlayerIds.contains(playerId);
        bool won = false;

        if (isTeam1) {
          if (session.team1Score > session.team2Score) won = true;
        } else {
          if (session.team2Score > session.team1Score) won = true;
        }

        if (won) {
          wins++;
          if (currentStreak >= 0) {
            currentStreak++;
          } else {
            currentStreak = 1;
          }
        } else {
          losses++;
          if (currentStreak <= 0) {
            currentStreak--;
          } else {
            currentStreak = -1;
          }
        }
      }

      double winRate = totalGames > 0 ? wins / totalGames : 0.0;

      // Calculate Insights (Best Partner & Nemesis)
      final playersResult = await playerRepository.getPlayers();

      return playersResult.fold((failure) => Left(failure), (players) {
        final playerMap = {for (var p in players) p.id: p.name};

        Map<String, int> partnerWins = {};
        Map<String, int> opponentLosses = {};

        for (var session in playerSessions) {
          bool isTeam1 = session.team1PlayerIds.contains(playerId);
          List<String> myTeam = isTeam1 ? session.team1PlayerIds : session.team2PlayerIds;
          List<String> opponentTeam = isTeam1 ? session.team2PlayerIds : session.team1PlayerIds;

          bool won = false;
          if (isTeam1 && session.team1Score > session.team2Score) won = true;
          if (!isTeam1 && session.team2Score > session.team1Score) won = true;

          if (won) {
            for (var vid in myTeam) {
              if (vid != playerId) {
                partnerWins[vid] = (partnerWins[vid] ?? 0) + 1;
              }
            }
          } else {
            for (var oid in opponentTeam) {
              opponentLosses[oid] = (opponentLosses[oid] ?? 0) + 1;
            }
          }
        }

        String bestPartner = 'N/A';
        if (partnerWins.isNotEmpty) {
          var bestPid = partnerWins.entries.reduce((a, b) => a.value > b.value ? a : b).key;
          bestPartner = playerMap[bestPid] ?? 'Unknown';
        }

        String nemesis = 'N/A';
        if (opponentLosses.isNotEmpty) {
          var worstPid = opponentLosses.entries.reduce((a, b) => a.value > b.value ? a : b).key;
          nemesis = playerMap[worstPid] ?? 'Unknown';
        }

        return Right(
          PlayerStats(
            totalGames: totalGames,
            wins: wins,
            losses: losses,
            winRate: winRate,
            currentStreak: currentStreak,
            bestPartner: bestPartner,
            nemesis: nemesis,
          ),
        );
      });
    });
  }
}
