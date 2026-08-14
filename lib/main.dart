import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_in_the_making/core/theme/liquid_glass_theme.dart';
import 'package:history_in_the_making/features/daily_history/presentation/screens/home_tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: HistoryInTheMakingApp(),
    ),
  );
}

class HistoryInTheMakingApp extends StatelessWidget {
  const HistoryInTheMakingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'History in the Making',
      debugShowCheckedModeBanner: false,
      theme: LiquidGlassTheme.cupertinoThemeData,
      home: const MainNavigationScreen(),
    );
  }
}
