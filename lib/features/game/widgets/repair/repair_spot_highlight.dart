import 'dart:math';
import 'package:flutter/material.dart';

class RepairSpotHighlight extends StatefulWidget {
  final Offset position;
  final VoidCallback onTap;

  const RepairSpotHighlight({
    super.key,
    required this.position,
    required this.onTap,
  });

  @override
  State<RepairSpotHighlight> createState() => _RepairSpotHighlightState();
}

class _RepairSpotHighlightState extends State<RepairSpotHighlight> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        final ringScale = 1.0 + (_animController.value * 0.2);
        final arrowBounce = sin(_animController.value * pi) * 8.0;

        return Positioned(
          left: widget.position.dx - 24,
          top: widget.position.dy - 24,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Pulsing Ring Target
                Transform.scale(
                  scale: ringScale,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFD93D), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD93D).withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                  ),
                ),
                // Bouncing Arrow Indicator
                Positioned(
                  top: -36 + arrowBounce,
                  child: const Icon(
                    Icons.arrow_downward_rounded,
                    color: Color(0xFFFFD93D),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
