import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/player_stats.dart';

class PlayerInsightsSection extends StatelessWidget {
  final PlayerStats stats;

  const PlayerInsightsSection(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Insights',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: Theme.of(context).textTheme.titleLarge?.color),
          ),
        ),
        12.verticalSpace,
        _buildInsightCard(
          context,
          label: 'BEST PARTNER',
          name: stats.bestPartner,
          winRate: '80%',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBdWBmC93KUapB_b6_14SeTFLSfDF-vJ0U-vXvB-2foteBBixHoOKqwBUhAF-SD_tjSeUhNqBpaHU56h9mcmu_tXMIXS0ToFQSwcByxZKthC4V0-TVIl_l6rz23HWoTGo5IDzxMlbJpj86cy912uMYiCiHQc1z2Kv1xk-piSNWF1IhNkT-QQ9DnkFMuFE5JFknF7h9C9sVHL3P2DB24lYKCJumb3Ce48XZjDkjoTFrSod4CGnFdZi4BG8S_TqTT8b4anKIKcL7EYGkJ',
          themeColor: AppTheme.primary,
          icon: Icons.handshake,
        ),
        12.verticalSpace,
        _buildInsightCard(
          context,
          label: 'NEMESIS',
          name: stats.nemesis,
          winRate: '20%',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA4v6aIlI_dH04Zpq_cnnuMhT4Yp0hSVtShhe5xN6nc_QJ_O8edUiTSJdkMaZOqxDFoVTJyVFcsA8RdO4ZMtn8kOrCctrvqddvgBKaoKW8kwY0v1XRxFq18pkiZtgqxWv8YTFvGnDocx2ZjuHaS5GBQvhGfah-bEW8j1Ds4iJZdpU7XzBmpugCXz70RaUpEQfG_HPQqn1l1a58VwYlNI_TzXF1Vlo34UVVMefPQCCknfL96gdYhR6bl1XevxrjhzSPDRps4y1J1B6Ql',
          themeColor: AppTheme.accentOrange,
          icon: Icons.bolt, // Placeholder for "swords"
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required String label,
    required String name,
    required String winRate,
    required String avatarUrl,
    required Color themeColor,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.cardDark : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16.dg),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: themeColor, width: 2.w),
                        ),
                        child: ClipOval(
                          child: AppCachedImage(imageUrl: avatarUrl, width: 48.w, height: 48.w, fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2.dg),
                        decoration: BoxDecoration(
                          color: themeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.backgroundDark, width: 1.w),
                        ),
                        child: Icon(icon, size: 10.sp, color: Colors.white),
                      ),
                    ],
                  ),
                  16.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: themeColor, letterSpacing: 1.2),
                      ),
                      4.verticalSpace,
                      Text(
                        name,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    winRate,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'WIN RATE',
                    style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600, color: Colors.grey[400], letterSpacing: 1.2),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Gradient Decoration
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 100.w,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(16.r), bottomRight: Radius.circular(16.r)),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [themeColor.withValues(alpha: 0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
