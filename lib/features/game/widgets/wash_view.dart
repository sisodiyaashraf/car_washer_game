import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../core/services/haptics_service.dart';
import '../../../data/repositories/tool_repository.dart';
import '../controllers/game_controller.dart';
import 'vehicle_image_widget.dart';

class WashView extends StatefulWidget {
  const WashView({super.key});

  @override
  State<WashView> createState() => _WashViewState();
}

class _WashViewState extends State<WashView> with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;
  final ParticlePool _particlePool = ParticlePool();
  final List<Offset> _scrubPoints = [];

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _tickerController.addListener(_updateParticles);
  }

  void _updateParticles() {
    _particlePool.update(0.016);
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

    _scrubPoints.add(localPosition);
    HapticsService().throttledScrubHaptic();

    final pType = controller.phase == GamePhase.washSoap ? ParticleType.soap : ParticleType.water;
    final pColor = controller.phase == GamePhase.washSoap ? Colors.white : const Color(0xFF4FC3F7);
    _particlePool.spawnBurst(localPosition, pType, pColor, count: 4);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;
    final isSoapPhase = controller.phase == GamePhase.washSoap;
    final progress = isSoapPhase ? controller.soapProgress : controller.rinseProgress;
    final pct = (progress * 100).round();
    final targetPct = (controller.levelDef.dirtCleanTarget * 100).round();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Chip(
            avatar: Icon(
              isSoapPhase ? Icons.soap : Icons.water_drop,
              size: 18,
              color: isSoapPhase ? AppColors.secondary : AppColors.primary,
            ),
            label: Text(
              isSoapPhase ? 'STAGE 1: SOAP ($pct% / $targetPct%)' : 'STAGE 2: RINSE ($pct% / $targetPct%)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.surface,
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.9;
                final height = width / 2.0; // AspectRatio 2:1

                return GestureDetector(
                  onPanDown: (details) => _handleTouch(details.localPosition, Size(width, height)),
                  onPanUpdate: (details) => _handleTouch(details.localPosition, Size(width, height)),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        // Clean Vehicle Background Image
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
                              damagedImagePath: AssetPaths.vehicleDamaged(vehicle.imageId),
                              scrubPoints: List.unmodifiable(_scrubPoints),
                              isSoapPhase: isSoapPhase,
                              soapProgress: controller.soapProgress,
                              rinseProgress: controller.rinseProgress,
                            ),
                          ),
                        ),
                        // Particles Canvas
                        RepaintBoundary(
                          child: CustomPaint(
                            size: Size(width, height),
                            painter: ParticlePainter(particles: _particlePool.activeParticles),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: AppColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ToolRepository.washTools.map((tool) {
                final isSelected = controller.selectedWashTool.id == tool.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    avatar: Image.asset(AssetPaths.toolIcon(tool.id), width: 22, height: 22, errorBuilder: (c, e, s) => Icon(tool.icon, size: 18)),
                    label: Text(tool.name),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    onSelected: (_) => controller.selectWashTool(tool),
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
  final String damagedImagePath;
  final List<Offset> scrubPoints;
  final bool isSoapPhase;
  final double soapProgress;
  final double rinseProgress;

  WashMaskPainter({
    required this.damagedImagePath,
    required this.scrubPoints,
    required this.isSoapPhase,
    required this.soapProgress,
    required this.rinseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isSoapPhase) {
      final dirtPaint = Paint()
        ..color = AppColors.dirtOverlay.withValues(alpha: (1.0 - soapProgress * 0.5).clamp(0.2, 0.85))
        ..style = PaintingStyle.fill;
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), dirtPaint);

      final foamPaint = Paint()..color = Colors.white.withValues(alpha: soapProgress.clamp(0.2, 0.9));
      for (final p in scrubPoints) {
        canvas.drawCircle(p, 20.0, foamPaint);
      }
    } else {
      final foamAlpha = (1.0 - rinseProgress).clamp(0.0, 0.9);
      if (foamAlpha > 0.05) {
        final foamPaint = Paint()..color = Colors.white.withValues(alpha: foamAlpha);
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), foamPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WashMaskPainter oldDelegate) {
    return oldDelegate.scrubPoints.length != scrubPoints.length ||
        oldDelegate.isSoapPhase != isSoapPhase ||
        oldDelegate.soapProgress != soapProgress ||
        oldDelegate.rinseProgress != rinseProgress;
  }
}
