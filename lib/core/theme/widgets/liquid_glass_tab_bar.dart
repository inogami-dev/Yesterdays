import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';

class LiquidGlassTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onQuickAction;

  const LiquidGlassTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 76,
      child: Row(
        children: [
          // Main Liquid Glass Capsule Bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(38),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                  child: CustomPaint(
                    foregroundPainter: _SpecularGlassCapsulePainter(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0x38FFFFFF), // Crystal clear translucent glass
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CapsuleTabItem(
                            index: 0,
                            currentIndex: currentIndex,
                            label: 'Today',
                            icon: HugeIcons.strokeRoundedEdit02,
                            onTap: () => onTap(0),
                          ),
                          _CapsuleTabItem(
                            index: 1,
                            currentIndex: currentIndex,
                            label: 'Archive',
                            icon: HugeIcons.strokeRoundedBookOpen01,
                            onTap: () => onTap(1),
                          ),
                          _CapsuleTabItem(
                            index: 2,
                            currentIndex: currentIndex,
                            label: 'Settings',
                            icon: HugeIcons.strokeRoundedSettings02,
                            onTap: () => onTap(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Standalone Circular Glass Action Orb (iOS Blue CTA)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: CustomPaint(
                  foregroundPainter: _SpecularCircularGlassPainter(),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: onQuickAction,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x38FFFFFF),
                      ),
                      child: Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF007AFF),
                                Color(0xFF32ADE6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF007AFF).withOpacity(0.5),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedAddCircle,
                              color: CupertinoColors.white,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapsuleTabItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CapsuleTabItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? CupertinoColors.white.withOpacity(0.25)
                : CupertinoColors.transparent,
            borderRadius: BorderRadius.circular(26),
            border: isSelected
                ? Border.all(
                    color: CupertinoColors.white.withOpacity(0.8),
                    width: 1.2,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: CupertinoColors.white.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: -1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: icon,
                color: isSelected
                    ? CupertinoColors.white
                    : CupertinoColors.white.withOpacity(0.55),
                size: 21.0,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: 'Quicksand',
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? CupertinoColors.white
                      : CupertinoColors.white.withOpacity(0.65),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecularGlassCapsulePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(38));

    // Specular Rim Highlight Shader
    final rimPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF), // Bright specular top reflection
          Color(0x77FFFFFF),
          Color(0x18FFFFFF),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRRect(rrect, rimPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpecularCircularGlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rimPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0x77FFFFFF),
          Color(0x18FFFFFF),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawOval(rect, rimPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
