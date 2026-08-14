import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:history_in_the_making/core/theme/liquid_glass_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final Color? backgroundColor;
  final Gradient? borderGradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.borderRadius = 22.0,
    this.backgroundColor,
    this.borderGradient,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderGradient =
        borderGradient ?? LiquidGlassTheme.specularBorderGradient;
    final effectiveBgColor =
        backgroundColor ?? LiquidGlassTheme.glassSurfaceDark;

    Widget containerContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );

    Widget frostedGlass = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: CustomPaint(
          foregroundPainter: _SpecularGlassBorderPainter(
            borderRadius: borderRadius,
            borderGradient: effectiveBorderGradient,
            strokeWidth: 0.8,
          ),
          child: containerContent,
        ),
      ),
    );

    if (margin != null) {
      frostedGlass = Padding(padding: margin!, child: frostedGlass);
    }

    if (onTap != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onTap,
        child: frostedGlass,
      );
    }

    return frostedGlass;
  }
}

class _SpecularGlassBorderPainter extends CustomPainter {
  final double borderRadius;
  final Gradient borderGradient;
  final double strokeWidth;

  _SpecularGlassBorderPainter({
    required this.borderRadius,
    required this.borderGradient,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()
      ..shader = borderGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _SpecularGlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderGradient != borderGradient ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
