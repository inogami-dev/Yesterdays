import 'package:flutter/cupertino.dart';

class LiquidGlassTheme {
  // Apple Liquid Glass Dark & Light Palette
  static const Color pitchDark = Color(0xFF07090E);
  static const Color glassSurfaceDark = Color(0x1FFFFFFF); // 12% specular translucent
  static const Color glassSurfaceLight = Color(0xD9F2F4F8); // Frosted light glass
  
  // Apple System iOS Accents
  static const Color iosBlue = Color(0xFF007AFF);
  static const Color iosGreen = Color(0xFF34C759);
  static const Color iosAmber = Color(0xFFFF9500);
  static const Color iosPink = Color(0xFFFF2D55);
  static const Color iosPurple = Color(0xFFAF52DE);

  // High Specular Edge Gradient (Optical Refraction Gloss)
  static const LinearGradient specularBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xEEFFFFFF), // High specular reflection top-left
      Color(0x55FFFFFF),
      Color(0x18FFFFFF),
    ],
  );

  static const LinearGradient activePillGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x40FFFFFF),
      Color(0x1AFFFFFF),
    ],
  );

  // Cupertino Theme Setup with Local Asset Quicksand Font as Default
  static CupertinoThemeData get cupertinoThemeData {
    const String fontQuicksand = 'Quicksand';
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: iosBlue,
      primaryContrastingColor: CupertinoColors.white,
      scaffoldBackgroundColor: pitchDark,
      barBackgroundColor: Color(0xE607090E),
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.white,
        textStyle: TextStyle(
          color: CupertinoColors.white,
          fontFamily: fontQuicksand,
          letterSpacing: -0.2,
        ),
        navTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          fontFamily: fontQuicksand,
          letterSpacing: -0.2,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 34.0,
          fontFamily: fontQuicksand,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
