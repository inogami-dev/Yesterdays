import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:history_in_the_making/core/theme/liquid_glass_theme.dart';
import 'package:history_in_the_making/core/theme/widgets/glass_container.dart';
import 'package:history_in_the_making/core/theme/widgets/liquid_background.dart';
import 'package:history_in_the_making/features/daily_history/presentation/providers/history_providers.dart';

class AlarmSettingsScreen extends ConsumerWidget {
  const AlarmSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyNotifierProvider);
    final yesterdayEntry = state.yesterdayEntry;
    final isAlarmActive =
        state.hasUserEverSavedLog && !yesterdayEntry.meetsRequirement;

    return LiquidBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings & Rules',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: CupertinoColors.white,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 16),

              // Rule Card
              GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedShieldKey,
                          color: LiquidGlassTheme.iosBlue,
                          size: 20.0,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'The 100-Word Daily Rule',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'After saving your first log, you must record at least 100 words summarizing your day. If yesterday\'s entry has under 100 words, an hourly notification alarm will ring as a reminder.',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: CupertinoColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Status Glass Container
              GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Yesterday Alarm Status',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                            color: CupertinoColors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: !state.hasUserEverSavedLog
                                ? CupertinoColors.systemGrey.withOpacity(0.2)
                                : (isAlarmActive
                                    ? LiquidGlassTheme.iosAmber
                                        .withOpacity(0.2)
                                    : LiquidGlassTheme.iosGreen
                                        .withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            !state.hasUserEverSavedLog
                                ? 'WAITING FIRST LOG'
                                : (isAlarmActive
                                    ? 'ACTIVE (Hourly)'
                                    : 'SILENCED (Met)'),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: !state.hasUserEverSavedLog
                                  ? CupertinoColors.systemGrey
                                  : (isAlarmActive
                                      ? LiquidGlassTheme.iosAmber
                                      : LiquidGlassTheme.iosGreen),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      !state.hasUserEverSavedLog
                          ? 'Rule will become active after you write and save your first log.'
                          : (isAlarmActive
                              ? 'Alarm rings every hour until yesterday\'s entry has 100 words.'
                              : 'Yesterday\'s entry contains ${yesterdayEntry.wordCount} words (>= 100). Hourly alarm is inactive.'),
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Alarm Diagnostic Controls
              GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedNotification01,
                          color: LiquidGlassTheme.iosAmber,
                          size: 20.0,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Notification Diagnostic',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Test alarm notification and sound on your device. Tapping the test notification will direct you straight to yesterday\'s history editor.',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: LiquidGlassTheme.iosBlue,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          ref
                              .read(historyNotifierProvider.notifier)
                              .triggerTestAlarm();
                          showCupertinoDialog(
                            context: context,
                            builder: (ctx) => CupertinoAlertDialog(
                              title: const Text('Test Notification Sent'),
                              content: const Text(
                                'A test notification has been issued. Tap it from your system tray to open yesterday\'s editor directly!',
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Trigger Test Notification',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Privacy & Offline
              GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                          color: LiquidGlassTheme.iosGreen,
                          size: 18.0,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '100% Offline & Private',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'All history logs are stored exclusively in SQLite on your device. Zero tracking, zero cloud data transfer.',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
