import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/camera/camera_controller.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../data/models/vehicle_def.dart';
import '../controllers/vehicle_motion.dart';
import 'motion_vehicle_widget.dart';

class StageWidget extends StatefulWidget {
  final String bgPhase;
  final VehicleDef vehicle;
  final VehicleMotion motion;
  final CameraController camera;
  final String? paintColorName;
  final bool isDamaged;
  final Widget? overlay;

  const StageWidget({
    super.key,
    required this.bgPhase,
    required this.vehicle,
    required this.motion,
    required this.camera,
    this.paintColorName,
    this.isDamaged = false,
    this.overlay,
  });

  @override
  State<StageWidget> createState() => _StageWidgetState();
}

class _StageWidgetState extends State<StageWidget> with SingleTickerProviderStateMixin {
  late AnimationController _idleController;
  final ParticlePool _ambientPool = ParticlePool();

  static const double floorLineYRatio = 0.61;
  static const double farParallax = 0.2;
  static const double midParallax = 0.5;
  static const double floorParallax = 1.0;
  static const double fgParallax = 1.3;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _idleController.addListener(() {
      _ambientPool.update(0.016);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageSize = Size(constraints.maxWidth, constraints.maxHeight);
        final bgPath = AssetPaths.background(widget.bgPhase);

        final vehicleWidth = stageSize.width * 0.92;
        final vehicleHeight = vehicleWidth / 2.0;

        // Wheel bottoms alignment to floor line exactly
        final floorY = stageSize.height * floorLineYRatio - (vehicleHeight * 0.75);
        final vehicleX = (stageSize.width / 2 - vehicleWidth / 2) + (widget.motion.x * stageSize.width * 0.5);
        final vehicleY = floorY + widget.motion.bodyBounce;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Far Layer (Sky & Skyline, 0.2x Parallax)
            Transform(
              transform: widget.camera.getStageTransform(farParallax, stageSize),
              child: Image.asset(bgPath, fit: BoxFit.cover, key: ValueKey('far_${widget.bgPhase}')),
            ),

            // 2. Mid Layer (Walls & Equipment, 0.5x Parallax)
            Transform(
              transform: widget.camera.getStageTransform(midParallax, stageSize),
              child: Image.asset(bgPath, fit: BoxFit.cover, key: ValueKey('mid_${widget.bgPhase}')),
            ),

            // 3. Floor Layer (Garage Floor & Line, 1.0x Parallax)
            Transform(
              transform: widget.camera.getStageTransform(floorParallax, stageSize),
              child: Image.asset(bgPath, fit: BoxFit.cover, key: ValueKey('floor_${widget.bgPhase}')),
            ),

            // 4. Vehicle Layer & Soft Contact Shadow (1.0x Parallax)
            Transform(
              transform: widget.camera.getStageTransform(floorParallax, stageSize),
              child: Stack(
                children: [
                  // Soft Oval Contact Shadow following vehicle
                  Positioned(
                    left: vehicleX + vehicleWidth * 0.1,
                    top: vehicleY + vehicleHeight * 0.72,
                    width: vehicleWidth * 0.8,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 16,
                            spreadRadius: 4,
                          )
                        ],
                      ),
                    ),
                  ),

                  // Motion Vehicle Layer
                  MotionVehicleWidget(
                    vehicle: widget.vehicle,
                    motion: widget.motion,
                    paintColorName: widget.paintColorName,
                    isDamaged: widget.isDamaged,
                    overlay: widget.overlay,
                  ),
                ],
              ),
            ),

            // 5. Effects Layer (Light Flicker & Floating Ambient Particles, 1.0x Parallax)
            Transform(
              transform: widget.camera.getStageTransform(floorParallax, stageSize),
              child: Stack(
                children: [
                  // Ceiling Light Soft Flicker Overlay
                  Opacity(
                    opacity: 0.05 + (sin(_idleController.value * pi * 4) * 0.03),
                    child: Container(color: Colors.white),
                  ),
                  CustomPaint(
                    size: stageSize,
                    painter: ParticlePainter(particles: _ambientPool.activeParticles),
                  ),
                ],
              ),
            ),

            // 6. Foreground Layer (1.3x Parallax)
            Transform(
              transform: widget.camera.getStageTransform(fgParallax, stageSize),
              child: const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
