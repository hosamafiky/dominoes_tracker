import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../cubit/players_cubit.dart';

class PlayersHeader extends StatelessWidget {
  const PlayersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
              BlocBuilder<PlayersCubit, PlayersState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is PlayersLoaded) count = state.selectedCount;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      '$count SELECTED',
                      style: TextStyle(color: AppTheme.primary, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1.2.sp),
                    ),
                  );
                },
              ),
            ],
          ),
          16.verticalSpace,
          Text(
            "Who's Playing?",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: isDark ? Colors.white : AppTheme.textDark),
          ),
          4.verticalSpace,
          Text(
            "Pick who is joining the table today.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
