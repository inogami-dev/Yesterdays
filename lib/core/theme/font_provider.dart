import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kFontPrefKey = 'user_selected_font_mode';

enum AppFontMode {
  defaultFont,
  rounded,
}

class FontState {
  final AppFontMode mode;

  const FontState({
    required this.mode,
  });

  String? get activeFontFamily {
    if (mode == AppFontMode.rounded) {
      return GoogleFonts.quicksand().fontFamily;
    }
    return '.SF Pro Text';
  }

  FontState copyWith({
    AppFontMode? mode,
  }) {
    return FontState(
      mode: mode ?? this.mode,
    );
  }
}

class FontNotifier extends StateNotifier<FontState> {
  FontNotifier()
      : super(const FontState(
          mode: AppFontMode.defaultFont,
        )) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(kFontPrefKey) ?? 0;
    
    state = FontState(
      mode: AppFontMode.values[modeIndex],
    );
  }

  Future<void> setFontMode(AppFontMode mode) async {
    state = state.copyWith(mode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kFontPrefKey, mode.index);
  }
}

final fontNotifierProvider =
    StateNotifierProvider<FontNotifier, FontState>((ref) {
  return FontNotifier();
});
