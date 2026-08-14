import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yesterdays/core/theme/liquid_glass_theme.dart';
import 'package:yesterdays/core/theme/widgets/glass_container.dart';
import 'package:yesterdays/features/daily_history/domain/models/history_entry.dart';

class YesterdayAlarmBanner extends StatelessWidget {
  final HistoryEntry yesterdayEntry;
  final bool hasUserEverSavedLog;
  final VoidCallback onWritePressed;

  const YesterdayAlarmBanner({
    super.key,
    required this.yesterdayEntry,
    required this.hasUserEverSavedLog,
    required this.onWritePressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasUserEverSavedLog) {
      return const SizedBox.shrink();
    }

    final bool satisfied = yesterdayEntry.meetsRequirement;
    final int remaining = yesterdayEntry.remainingWords;
    final int currentWords = yesterdayEntry.wordCount;

    if (satisfied) {
      return GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        backgroundColor: LiquidGlassTheme.iosGreen.withOpacity(0.12),
        borderColor: LiquidGlassTheme.iosGreen.withOpacity(0.3),
        child: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
              color: LiquidGlassTheme.iosGreen,
              size: 20.0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Yesterday Completed ($currentWords words logged)',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Minimal Apple iOS Alert Strip (< 100 words)
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      backgroundColor: LiquidGlassTheme.iosAmber.withOpacity(0.15),
      borderColor: LiquidGlassTheme.iosAmber.withOpacity(0.4),
      onTap: onWritePressed,
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlert02,
            color: LiquidGlassTheme.iosAmber,
            size: 20.0,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Yesterday\'s History Incomplete',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$currentWords/100 words • Need $remaining more words',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Write',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: LiquidGlassTheme.iosAmber,
            ),
          ),
          const SizedBox(width: 2),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: LiquidGlassTheme.iosAmber,
            size: 14.0,
          ),
        ],
      ),
    );
  }
}
