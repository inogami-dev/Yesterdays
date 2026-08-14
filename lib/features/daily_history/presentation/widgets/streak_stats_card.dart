import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:history_in_the_making/core/theme/liquid_glass_theme.dart';
import 'package:history_in_the_making/core/theme/widgets/glass_container.dart';

class StreakStatsCard extends StatelessWidget {
  final int streakCount;
  final int totalEntries;
  final int yesterdayWords;

  const StreakStatsCard({
    super.key,
    required this.streakCount,
    required this.totalEntries,
    required this.yesterdayWords,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: HugeIcons.strokeRoundedFire,
            iconColor: LiquidGlassTheme.iosAmber,
            label: 'Day Streak',
            value: '$streakCount ${streakCount == 1 ? 'Day' : 'Days'}',
          ),
          Container(
            width: 1,
            height: 34,
            color: CupertinoColors.white.withOpacity(0.1),
          ),
          _StatItem(
            icon: HugeIcons.strokeRoundedBookOpen01,
            iconColor: LiquidGlassTheme.iosBlue,
            label: 'Total Logs',
            value: '$totalEntries',
          ),
          Container(
            width: 1,
            height: 34,
            color: CupertinoColors.white.withOpacity(0.1),
          ),
          _StatItem(
            icon: HugeIcons.strokeRoundedNote01,
            iconColor: LiquidGlassTheme.iosGreen,
            label: 'Yesterday',
            value: '$yesterdayWords w',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: icon,
              color: iconColor,
              size: 16.0,
            ),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: CupertinoColors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
