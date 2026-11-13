import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/camera/camera_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../../../data/repositories/tool_repository.dart';
import '../controllers/game_controller.dart';
import '../tools/tool_motion_defs.dart';
import 'vehicle_image_widget.dart';

class WashView extends StatefulWidget {
  const WashView({super.key});

  @override
  State<WashView> createState() => _WashViewState();
}

class _WashViewState extends State<WashView> with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;
  final ParticlePool _particlePool = ParticlePool();
  Offset? _targetTouchPos;
  Offset _currentToolPos = Offset.zero;
  double _toolTiltAngle = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _tickerController.addListener(_updateFrame);
  }

  void _updateFrame() {
    _particlePool.update(0.016);

    // Tool Spring Lag & Motion Tilt
    if (_targetTouchPos != null) {
      final dx = _targetTouchPos!.dx - _currentToolPos.dx;
      final dy = _targetTouchPos!.dy - _currentToolPos.dy;

      // Damped spring lag
      _currentToolPos += Offset(dx * 0.35, dy * 0.35);

      // Motion tilt (6 to 12 degrees tilt based on velocity)
      final velocityX = dx * 0.1;
      _toolTiltAngle = (velocityX * 0.1).clamp(-0.2, 0.2); // ~11 degrees max
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  void _handleTouch(Offset localPosition, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final relativeOffset = Offset(
      (localPosition.dx / size.width).clamp(0.0, 1.0),
      (localPosition.dy / size.height).clamp(0.0, 1.0),
    );

    final controller = context.read<GameController>();
    controller.scrubAt(relativeOffset);

    if (_targetTouchPos == null) {
      _currentToolPos = localPosition;
    }
    _targetTouchPos = localPosition;
    _isDragging = true;

    HapticsService().throttledScrubHaptic();

    final toolId = controller.selectedWashTool.id;
    if (toolId == 'pressure_washer') {
      try {
        context.read<CameraController>().shake(3.0);
      } catch (_) {}
      _particlePool.spawnBurst(localPosition, ParticleType.streak, Colors.cyanAccent, count: 6);
      _particlePool.spawnBurst(localPosition, ParticleType.mudFlake, AppColors.dirtMud, count: 4);
    } else if (controller.phase == GamePhase.washSoap) {
      AudioService().playScrubSound();
      _particlePool.spawnBurst(localPosition, ParticleType.soap, Colors.white, count: 5);
      _particlePool.spawnBurst(localPosition, ParticleType.drip, Colors.white70, count: 2);
    } else {
      AudioService().playSpraySound();
      _particlePool.spawnBurst(localPosition, ParticleType.water, AppColors.waterBlue, count: 6);
    }
  }

  void _handleTouchEnd() {
    setState(() {
      _isDragging = false;
      _targetTouchPos = null;
      _toolTiltAngle = 0.0;
    });
    AudioService().stopSfx();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;
    final isSoapPhase = controller.phase == GamePhase.washSoap;
    final progress = isSoapPhase ? controller.soapProgress : controller.rinseProgress;
    final pct = (progress * 100).round();
    final targetPct = (controller.levelDef.dirtCleanTarget * 100).round();

    final toolMotionDef = ToolMotionDef.getDef(controller.selectedWashTool.id);

    return Column(
      children: [
        // Modern Progress Status Badge
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSoapPhase ? AppColors.secondary : AppColors.primary, width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSoapPhase ? Icons.soap : Icons.water_drop,
                  size: 20,
                  color: isSoapPhase ? AppColors.secondary : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isSoapPhase ? 'STAGE 1: SOAP ($pct% / $targetPct%)' : 'STAGE 2: RINSE ($pct% / $targetPct%)',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.92;
                final height = width / 2.0;

                // Idle 2 Hz 1px breathing sway when not dragging
                final idleSway = !_isDragging ? sin(_tickerController.value * pi * 4) * toolMotionDef.idleSwayAmp : 0.0;

                return GestureDetector(
                  onPanDown: (details) => _handleTouch(details.localPosition, Size(width, height)),
                  onPanUpdate: (details) => _handleTouch(details.localPosition, Size(width, height)),
                  onPanEnd: (_) => _handleTouchEnd(),
                  onPanCancel: () => _handleTouchEnd(),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        // Clean Vehicle Base
                        VehicleImageWidget(
                          vehicleId: vehicle.id,
                          imageId: vehicle.imageId,
                          isDamaged: false,
                          paintColorName: controller.vehiclePaintColorName,
                          baseColor: vehicle.baseColor,
                        ),
                        // Damaged / Dirt Mask Reveal Layer
                        RepaintBoundary(
                          child: CustomPaint(
                            size: Size(width, height),
                            painter: WashMaskPainter(
                              isSoapPhase: isSoapPhase,
                              soapProgress: controller.soapProgress,
                              rinseProgress: controller.rinseProgress,
                            ),
                          ),
                        ),
                        // Pooled Particle Stream Canvas (Capped at 160 max)
                        RepaintBoundary(
                          child: CustomPaint(
                            size: Size(width, height),
                            painter: ParticlePainter(particles: _particlePool.activeParticles),
                          ),
                        ),
                        // Active Tool Prop with Lag, Tilt, & Idle Sway
                        if (_isDragging && _currentToolPos != Offset.zero)
                          Positioned(
                            left: _currentToolPos.dx - 28,
                            top: _currentToolPos.dy - 28 + idleSway - toolMotionDef.recoilOffset,
                            child: Transform.rotate(
                              angle: _toolTiltAngle,
                              child: Transform.scale(
                                scale: _isDragging ? toolMotionDef.squashScaleOnPress : 1.0,
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.25),
                                    border: Border.all(color: isSoapPhase ? AppColors.secondary : AppColors.primary, width: 2),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AssetPaths.toolIcon(controller.selectedWashTool.id),
                                      width: 38,
                                      height: 38,
                                      errorBuilder: (c, e, s) => Icon(controller.selectedWashTool.icon, color: Colors.white, size: 28),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Tools Selection Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, -4)),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ToolRepository.washTools.map((tool) {
                final isSelected = controller.selectedWashTool.id == tool.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    avatar: Image.asset(
                      AssetPaths.toolIcon(tool.id),
                      width: 24,
                      height: 24,
                      errorBuilder: (c, e, s) => Icon(tool.icon, size: 20, color: isSelected ? Colors.white : AppColors.primary),
                    ),
                    label: Text(
                      tool.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.cardBg,
                    onSelected: (_) {
                      HapticsService().selectionClick();
                      controller.selectWashTool(tool);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class WashMaskPainter extends CustomPainter {
  final bool isSoapPhase;
  final double soapProgress;
  final double rinseProgress;

  WashMaskPainter({
    required this.isSoapPhase,
    required this.soapProgress,
    required this.rinseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isSoapPhase) {
      final dirtPaint = Paint()
        ..color = AppColors.dirtOverlay.withValues(alpha: (1.0 - soapProgress * 0.6).clamp(0.15, 0.85))
        ..style = PaintingStyle.fill;
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), dirtPaint);
    } else {
      final foamAlpha = (1.0 - rinseProgress).clamp(0.0, 0.85);
      if (foamAlpha > 0.05) {
        final foamPaint = Paint()..color = Colors.white.withValues(alpha: foamAlpha);
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), foamPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WashMaskPainter oldDelegate) {
    return oldDelegate.isSoapPhase != isSoapPhase ||
        oldDelegate.soapProgress != soapProgress ||
        oldDelegate.rinseProgress != rinseProgress;
  }
}
