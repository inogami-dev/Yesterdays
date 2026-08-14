import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator, AlwaysStoppedAnimation;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yesterdays/core/theme/liquid_glass_theme.dart';
import 'package:yesterdays/core/theme/widgets/glass_container.dart';
import 'package:yesterdays/core/theme/widgets/liquid_background.dart';
import 'package:yesterdays/core/utils/date_formatter.dart';
import 'package:yesterdays/core/utils/word_counter.dart';
import 'package:yesterdays/features/daily_history/domain/models/history_entry.dart';
import 'package:yesterdays/features/daily_history/presentation/providers/history_providers.dart';

class EntryEditorScreen extends ConsumerStatefulWidget {
  final String dateKey;

  const EntryEditorScreen({
    super.key,
    required this.dateKey,
  });

  @override
  ConsumerState<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends ConsumerState<EntryEditorScreen> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  int _wordCount = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _loadExistingContent();
  }

  void _loadExistingContent() {
    final state = ref.read(historyNotifierProvider);
    HistoryEntry? existing;
    for (final e in state.entries) {
      if (e.date == widget.dateKey) {
        existing = e;
        break;
      }
    }
    if (existing != null) {
      _controller.text = existing.content;
      _wordCount = existing.wordCount;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {
      _wordCount = WordCounter.countWords(text);
    });
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    await ref.read(historyNotifierProvider.notifier).saveEntry(
          dateKey: widget.dateKey,
          content: _controller.text,
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendlyDate = DateFormatter.formatFriendly(widget.dateKey);
    final isYesterday = widget.dateKey == DateFormatter.yesterdayKey();
    final remainingWords = WordCounter.remainingWords(_controller.text, target: 100);
    final meets100 = _wordCount >= 100;
    final progress = WordCounter.progressRatio(_controller.text, target: 100);

    return CupertinoPageScaffold(
      child: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Navigation Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft01,
                            color: CupertinoColors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 16,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      friendlyDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: CupertinoColors.white,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      color: LiquidGlassTheme.iosBlue,
                      borderRadius: BorderRadius.circular(16),
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const CupertinoActivityIndicator(
                              color: CupertinoColors.white)
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: CupertinoColors.white,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              // Live Word Count Header Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              HugeIcon(
                                icon: meets100
                                    ? HugeIcons.strokeRoundedCheckmarkCircle01
                                    : (isYesterday
                                        ? HugeIcons.strokeRoundedNotification01
                                        : HugeIcons.strokeRoundedEdit02),
                                color: meets100
                                    ? LiquidGlassTheme.iosGreen
                                    : (isYesterday
                                        ? LiquidGlassTheme.iosAmber
                                        : LiquidGlassTheme.iosBlue),
                                size: 18.0,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                meets100
                                    ? '100-Word Target Satisfied'
                                    : (isYesterday
                                        ? 'Yesterday History: 100 Words Required'
                                        : 'Daily Progress'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  fontFamily: 'Quicksand',
                                  color: meets100
                                      ? LiquidGlassTheme.iosGreen
                                      : (isYesterday
                                          ? LiquidGlassTheme.iosAmber
                                          : CupertinoColors.white),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_wordCount / 100 words',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              fontFamily: 'Quicksand',
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor:
                              CupertinoColors.white.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            meets100
                                ? LiquidGlassTheme.iosGreen
                                : (isYesterday
                                    ? LiquidGlassTheme.iosAmber
                                    : LiquidGlassTheme.iosBlue),
                          ),
                          minHeight: 5,
                        ),
                      ),
                      if (!meets100 && isYesterday)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Write $remainingWords more words to satisfy yesterday\'s rule.',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontFamily: 'Quicksand',
                                color: CupertinoColors.white.withOpacity(0.65),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Glass Editor Text Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    child: CupertinoTextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onTextChanged,
                      maxLines: null,
                      expands: true,
                      autofocus: true,
                      keyboardAppearance: Brightness.dark,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16.5,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Quicksand',
                      ),
                      placeholder:
                          'Record your day... What happened? What did you feel, learn, or accomplish?',
                      placeholderStyle: TextStyle(
                        color: CupertinoColors.white.withOpacity(0.35),
                        fontSize: 16.5,
                        height: 1.5,
                        fontFamily: 'Quicksand',
                      ),
                      decoration: const BoxDecoration(
                        color: CupertinoColors.transparent,
                      ),
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
