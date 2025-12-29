import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/session_cubit.dart';
import '../widgets/add_round_action.dart';
import '../widgets/game_history.dart';
import '../widgets/live_match_title.dart';
import '../widgets/scoreboard.dart';

class LiveGamePage extends StatelessWidget {
  const LiveGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: isDark ? Colors.white : AppTheme.textDark),
        ),
        title: Text(
          'Live Session',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: isDark ? Colors.white : AppTheme.textDark),
          ),
        ],
      ),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state.sessionStatus == UseCaseStatus.initial || state.sessionStatus == UseCaseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.sessionStatus == UseCaseStatus.success && state.session != null) {
            final session = state.session!;
            return Column(
              children: [
                Scoreboard(session: session),
                24.verticalSpace,
                LiveMatchTitle(session: session),
                16.verticalSpace,
                Expanded(child: GameHistory(session: session)),
                AddRoundAction(session: session),
              ],
            );
          } else if (state.sessionStatus == UseCaseStatus.failure && state.sessionError != null) {
            return Center(
              child: Text(state.sessionError!, style: const TextStyle(color: Colors.red)),
            );
          }
          return const Center(child: Text('Initializing session...'));
        },
      ),
    );
  }
}
