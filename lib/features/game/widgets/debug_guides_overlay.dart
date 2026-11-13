import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugGuidesOverlay extends StatelessWidget {
  final int activeParticles;
  final double floorLineYRatio;

  const DebugGuidesOverlay({
    super.key,
    required this.activeParticles,
    this.floorLineYRatio = 0.61,
  });

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final floorY = constraints.maxHeight * floorLineYRatio;

          return Stack(
            children: [
              // Floor Line Guide (Red Dashed Line)
              Positioned(
                top: floorY,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Colors.redAccent.withValues(alpha: 0.8),
                ),
              ),

              // Performance Statistics Box
              Positioned(
                top: 60,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.greenAccent, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'DEBUG GUIDES (60 FPS)',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Particles: $activeParticles / 160',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        'Floor Line Y: ${(floorLineYRatio * 100).round()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
