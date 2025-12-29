import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final ValueChanged<bool> onToggle;

  const PlayerCard({super.key, required this.player, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = player.isSelected;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppTheme.backgroundDark.withBlue(40) : Colors.white)
            : (isDark ? AppTheme.backgroundDark.withOpacity(0.5) : Colors.grey[50]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppTheme.primary : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)), width: 2),
        boxShadow: isSelected ? [BoxShadow(color: AppTheme.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? AppTheme.primary : Colors.transparent, width: 2),
                  image: player.avatarUrl != null ? DecorationImage(image: NetworkImage(player.avatarUrl!), fit: BoxFit.cover) : null,
                  gradient: player.avatarUrl == null ? const LinearGradient(colors: [Colors.indigo, Colors.purple]) : null,
                ),
                child: player.avatarUrl == null
                    ? Center(
                        child: Text(
                          player.name.substring(0, 2).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    : null,
              ),
              if (player.isActive)
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? const Color(0xFF1C331C) : Colors.white, width: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
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
                  player.isActive ? 'Active' : 'Inactive',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: player.isActive ? AppTheme.primary : Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Toggle
          GestureDetector(
            onTap: () => onToggle(!isSelected),
            child: Container(
              width: 52,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : (isDark ? const Color(0xFF283928) : Colors.grey[300]),
                borderRadius: BorderRadius.circular(100),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
