import 'package:flutter/cupertino.dart';
import 'package:history_in_the_making/core/theme/liquid_glass_theme.dart';
import 'package:history_in_the_making/core/theme/widgets/glass_container.dart';
import 'package:history_in_the_making/core/utils/date_formatter.dart';
import 'package:history_in_the_making/features/daily_history/domain/models/history_entry.dart';

class EntryCard extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onTap;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final friendlyDate = DateFormatter.formatFriendly(entry.date);
    final is100Met = entry.meetsRequirement;

    return GlassContainer(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                friendlyDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                  color: CupertinoColors.white,
                ),
              ),
              const Spacer(),
              // Minimal word count pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: is100Met
                      ? LiquidGlassTheme.iosGreen.withOpacity(0.15)
                      : LiquidGlassTheme.iosAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${entry.wordCount} words',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: is100Met
                        ? LiquidGlassTheme.iosGreen
                        : LiquidGlassTheme.iosAmber,
                  ),
                ),
              ),
            ],
          ),
          if (entry.content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: CupertinoColors.white.withOpacity(0.75),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
