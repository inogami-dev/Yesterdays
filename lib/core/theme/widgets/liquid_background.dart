import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:yesterdays/core/theme/liquid_glass_theme.dart';

class LiquidBackground extends StatefulWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // Smooth slow floating offsets
        final dx1 = math.sin(t * math.pi * 2) * 35;
        final dy1 = math.cos(t * math.pi * 2) * 45;

        final dx2 = math.cos(t * math.pi * 1.5) * 50;
        final dy2 = math.sin(t * math.pi * 1.5) * 35;

        final dx3 = math.sin(t * math.pi * 2.5) * 40;
        final dy3 = math.cos(t * math.pi * 2.5) * 40;

        return Stack(
          children: [
            // Dark Base Canvas
            Container(
              color: LiquidGlassTheme.pitchDark,
            ),

            // Vibrant Emerald Green Ambient Orb (Top Right / Center)
            Positioned(
              top: -60 + dy1,
              right: -40 + dx1,
              width: 340,
              height: 340,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF34C759).withOpacity(0.35),
                      const Color(0xFF30B0C7).withOpacity(0.18),
                      CupertinoColors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Electric Cyan & Blue Ambient Orb (Mid Left)
            Positioned(
              top: 220 + dy2,
              left: -80 + dx2,
              width: 380,
              height: 380,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF007AFF).withOpacity(0.28),
                      const Color(0xFF32ADE6).withOpacity(0.15),
                      CupertinoColors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Magenta & Pink Glossy Ambient Orb (Bottom Right behind Tab Bar)
            Positioned(
              bottom: -40 + dy3,
              right: -60 + dx3,
              width: 400,
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF2D55).withOpacity(0.25),
                      const Color(0xFFAF52DE).withOpacity(0.15),
                      CupertinoColors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Foreground Content
            widget.child,
          ],
        );
      },
    );
  }
}
