import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../domain/entities/round.dart';
import '../../domain/entities/session.dart';
import '../cubit/session_cubit.dart';

class GameHistory extends StatelessWidget {
  final Session session;

  const GameHistory({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, ({UseCaseStatus status, List<Round> rounds})>(
      selector: (state) => (status: state.roundsStatus, rounds: state.rounds),
      builder: (context, state) {
        if (state.status == UseCaseStatus.loading && state.rounds.isEmpty) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state.rounds.isEmpty) {
          return Center(
            child: Text('No rounds yet', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: state.rounds.length,
          itemBuilder: (context, index) {
            final round = state.rounds[index];
            final isTeam1 = round.winningTeamName == session.team1Name;

            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isTeam1 ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      isTeam1 ? 'T1' : 'T2',
                      style: TextStyle(color: isTeam1 ? Colors.green : Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          round.winningTeamName,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        Text(
                          DateFormat.Hm().format(round.timestamp),
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+${round.points}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
