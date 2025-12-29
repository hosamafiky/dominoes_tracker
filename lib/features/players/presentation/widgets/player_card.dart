import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final ValueChanged<bool> onToggle;

  const PlayerCard({super.key, required this.player, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = player.isSelected;

    return Opacity(
      opacity: isSelected ? 1 : 0.7,
      child: InkWell(
        onTap: () {
          context.push('/player-stats/:${player.id}');
        },
        child: Container(
          padding: EdgeInsets.all(12.dg),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppTheme.backgroundDark.withBlue(40) : Colors.white)
                : (isDark ? AppTheme.backgroundDark.withValues(alpha: 0.5) : Colors.grey[50]),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? AppTheme.primary : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
              width: 2.w,
            ),
            boxShadow: isSelected ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.1), blurRadius: 10.r, offset: Offset(0, 4.h))] : null,
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? AppTheme.primary : Colors.transparent, width: 2.w),
                      gradient: player.avatarUrl == null ? const LinearGradient(colors: [Colors.indigo, Colors.purple]) : null,
                    ),
                    child: player.avatarUrl != null
                        ? AppCachedImage(imageUrl: player.avatarUrl!, borderRadius: BorderRadius.circular(100.r))
                        : Center(
                            child: Text(
                              player.name.substring(0, 2).toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                  if (player.isSelected)
                    Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? const Color(0xFF1C331C) : Colors.white, width: 2.w),
                      ),
                    ),
                ],
              ),
              16.horizontalSpace,
              // Name & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
                    ),
                    Text(
                      player.isSelected ? 'Active' : 'Inactive',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: player.isSelected ? AppTheme.primary : Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // Toggle
              GestureDetector(
                onTap: () => onToggle(!isSelected),
                child: Container(
                  width: 52.w,
                  height: 32.h,
                  padding: EdgeInsets.all(4.dg),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : (isDark ? const Color(0xFF283928) : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
