import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class SessionBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onPlayersTap;

  const SessionBottomNav({super.key, required this.currentIndex, required this.onIndexChanged, required this.onPlayersTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F160F) : Colors.white;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: bg,
          border: Border(top: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.grid_view_rounded, label: 'Sessions', isActive: currentIndex == 0, onTap: () => onIndexChanged(0)),
            _NavItem(icon: Icons.groups_outlined, label: 'Players', isActive: currentIndex == 1, onTap: onPlayersTap),
            _NavItem(icon: Icons.leaderboard_outlined, label: 'Stats', isActive: currentIndex == 2, onTap: () => onIndexChanged(2)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppTheme.primary : Colors.grey[500], size: 24.sp),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primary : Colors.grey[500],
                fontSize: 10.sp,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
