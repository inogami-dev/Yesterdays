import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yesterdays/core/theme/liquid_glass_theme.dart';
import 'package:yesterdays/core/theme/widgets/glass_container.dart';
import 'package:yesterdays/core/theme/widgets/liquid_background.dart';
import 'package:yesterdays/core/theme/widgets/liquid_glass_tab_bar.dart';
import 'package:yesterdays/core/utils/date_formatter.dart';
import 'package:yesterdays/features/daily_history/presentation/providers/history_providers.dart';
import 'package:yesterdays/features/daily_history/presentation/screens/alarm_settings_screen.dart';
import 'package:yesterdays/features/daily_history/presentation/screens/entry_editor_screen.dart';
import 'package:yesterdays/features/daily_history/presentation/screens/history_list_screen.dart';
import 'package:yesterdays/features/daily_history/presentation/widgets/entry_card.dart';
import 'package:yesterdays/features/daily_history/presentation/widgets/yesterday_alarm_banner.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;
  StreamSubscription<String>? _notificationSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alarmService = ref.read(alarmServiceProvider);
      alarmService.requestPermissions();
      _notificationSub = alarmService.onNotificationTap.listen((dateKey) {
        if (mounted) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => EntryEditorScreen(dateKey: dateKey),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    super.dispose();
  }

  final List<Widget> _screens = [
    const HomeDashboardTab(),
    const HistoryListScreen(),
    const AlarmSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final todayKey = DateFormatter.todayKey();

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // Active Tab Screen Body
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Custom Floating Apple Liquid Glass Capsule Navigation Bar + Action Orb
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LiquidGlassTabBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              onQuickAction: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => EntryEditorScreen(dateKey: todayKey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDashboardTab extends ConsumerWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyNotifierProvider);
    final yesterdayEntry = state.yesterdayEntry;
    final todayEntry = state.todayEntry;
    final yesterdayKey = DateFormatter.yesterdayKey();
    final todayKey = DateFormatter.todayKey();

    return LiquidBackground(
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Apple Large Title Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yesterdays',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: CupertinoColors.white,
                            fontFamily: 'Quicksand',
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.streakCount > 0
                              ? '🔥 ${state.streakCount} Day Streak'
                              : 'Record your personal history daily.',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Quicksand',
                            color: CupertinoColors.white.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // DESIGNATED OBVIOUS CTA BUTTON FOR TODAY'S LOG
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: LiquidGlassTheme.iosBlue,
                    borderRadius: BorderRadius.circular(18),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => EntryEditorScreen(dateKey: todayKey),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedAddCircle,
                          color: CupertinoColors.white,
                          size: 22.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          todayEntry.content.isEmpty
                              ? 'Record Today\'s History'
                              : 'Continue Today\'s Log (${todayEntry.wordCount} words)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.5,
                            fontFamily: 'Quicksand',
                            color: CupertinoColors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Yesterday Alarm Banner (Only shown if user has saved history & yesterday incomplete)
            if (state.hasUserEverSavedLog)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: YesterdayAlarmBanner(
                    yesterdayEntry: yesterdayEntry,
                    hasUserEverSavedLog: state.hasUserEverSavedLog,
                    onWritePressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => EntryEditorScreen(
                            dateKey: yesterdayKey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Section Header: Recent Logs
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'History Timeline',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    fontFamily: 'Quicksand',
                    color: CupertinoColors.white,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),

            // History List Items
            state.isLoading
                ? const SliverFillRemaining(
                    child: Center(
                      child: CupertinoActivityIndicator(
                          color: CupertinoColors.white),
                    ),
                  )
                : state.entries.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: GlassContainer(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedEdit02,
                                  color: CupertinoColors.white.withOpacity(0.4),
                                  size: 40.0,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No History Recorded Yet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Quicksand',
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap "Record Today\'s History" above to start writing your personal life story.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Quicksand',
                                    color: CupertinoColors.white
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final entry = state.entries[index];
                              return EntryCard(
                                entry: entry,
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) => EntryEditorScreen(
                                        dateKey: entry.date,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: state.entries.length,
                          ),
                        ),
                      ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}
