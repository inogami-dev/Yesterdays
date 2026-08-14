import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yesterdays/core/theme/liquid_glass_theme.dart';
import 'package:yesterdays/features/daily_history/presentation/screens/home_tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: YesterdaysApp(),
    ),
  );
}

class YesterdaysApp extends StatelessWidget {
  const YesterdaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Yesterdays',
      debugShowCheckedModeBanner: false,
      theme: LiquidGlassTheme.cupertinoThemeData,
      home: const MainNavigationScreen(),
    );
  }
}
