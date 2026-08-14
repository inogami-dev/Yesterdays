import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yesterdays/core/theme/widgets/glass_container.dart';
import 'package:yesterdays/core/theme/widgets/liquid_background.dart';
import 'package:yesterdays/features/daily_history/domain/models/history_entry.dart';
import 'package:yesterdays/features/daily_history/presentation/providers/history_providers.dart';
import 'package:yesterdays/features/daily_history/presentation/screens/entry_editor_screen.dart';
import 'package:yesterdays/features/daily_history/presentation/widgets/entry_card.dart';

class HistoryListScreen extends ConsumerStatefulWidget {
  const HistoryListScreen({super.key});

  @override
  ConsumerState<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends ConsumerState<HistoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyNotifierProvider);

    List<HistoryEntry> filteredEntries = state.entries;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filteredEntries = state.entries.where((e) {
        return e.content.toLowerCase().contains(q) ||
            e.date.toLowerCase().contains(q);
      }).toList();
    }

    return LiquidBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'History Archive',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: CupertinoColors.white,
                  letterSpacing: -0.8,
                ),
              ),
            ),

            // Search Bar Glass
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GlassContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                borderRadius: 16,
                child: CupertinoSearchTextField(
                  controller: _searchController,
                  placeholder: 'Search life history entries...',
                  placeholderStyle: TextStyle(
                    color: CupertinoColors.white.withOpacity(0.4),
                  ),
                  style: const TextStyle(color: CupertinoColors.white),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
            ),

            // Entries List
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                          color: CupertinoColors.white),
                    )
                  : filteredEntries.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedBookOpen01,
                                  color: CupertinoColors.white.withOpacity(0.3),
                                  size: 48.0,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'No history entries recorded yet.'
                                      : 'No history matching "$_searchQuery".',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CupertinoColors.white
                                        .withOpacity(0.6),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = filteredEntries[index];
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
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
