import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../core/services/haptics_service.dart';
import '../../../data/repositories/tool_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../controllers/game_controller.dart';

class WashView extends StatefulWidget {
  const WashView({super.key});

  @override
  State<WashView> createState() => _WashViewState();
}

class _WashViewState extends State<WashView> with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;
  final ParticlePool _particlePool = ParticlePool();

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
                final height = constraints.maxHeight * 0.7;

                return GestureDetector(
                  onPanDown: (details) => _handleTouch(details.localPosition, Size(width, height)),
                  onPanUpdate: (details) => _handleTouch(details.localPosition, Size(width, height)),
                  child: Stack(
                    children: [
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(width, height),
                          painter: VehicleRepository.buildVehiclePainter(
                            vehicleId: vehicle.id,
                            bodyColor: controller.vehiclePaintColor,
                            rimStyle: controller.selectedRimStyle,
                            decalType: controller.selectedDecal,
                            decalOffset: controller.decalOffset,
                            decalScale: controller.decalScale,
                            isCleanShine: controller.phase == GamePhase.repair || controller.phase == GamePhase.paint,
                          ),
                        ),
                      ),
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(width, height),
                          painter: WashOverlayPainter(
                            isSoapPhase: isSoapPhase,
                            soapProgress: controller.soapProgress,
                            rinseProgress: controller.rinseProgress,
                            gridRows: GameConstants.washGridRows,
                            gridCols: GameConstants.washGridCols,
                          ),
                        ),
                      ),
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(width, height),
                          painter: ParticlePainter(particles: _particlePool.activeParticles),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Tools Selection Bar with Horizontal Scroll
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
                    avatar: Icon(tool.icon, size: 18, color: isSelected ? Colors.white : AppColors.primary),
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

class WashOverlayPainter extends CustomPainter {
  final bool isSoapPhase;
  final double soapProgress;
  final double rinseProgress;
  final int gridRows;
  final int gridCols;

  WashOverlayPainter({
    required this.isSoapPhase,
    required this.soapProgress,
    required this.rinseProgress,
    required this.gridRows,
    required this.gridCols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isSoapPhase) {
      final dirtPaint = Paint()
        ..color = AppColors.dirtOverlay.withValues(alpha: (1.0 - soapProgress * 0.5).clamp(0.2, 0.85))
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(size.width * 0.05, size.height * 0.15, size.width * 0.9, size.height * 0.65);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), dirtPaint);

      final foamPaint = Paint()..color = Colors.white.withValues(alpha: soapProgress.clamp(0.2, 0.9));
      final stepX = size.width / gridCols;
      final stepY = size.height / gridRows;

      for (int r = 0; r < gridRows; r++) {
        for (int c = 0; c < gridCols; c++) {
          final center = Offset((c + 0.5) * stepX, (r + 0.5) * stepY);
          canvas.drawCircle(center, stepX * 0.45, foamPaint);
        }
      }
    } else {
      final foamAlpha = (1.0 - rinseProgress).clamp(0.0, 0.9);
      if (foamAlpha > 0.05) {
        final foamPaint = Paint()..color = Colors.white.withValues(alpha: foamAlpha);
        final rect = Rect.fromLTWH(size.width * 0.05, size.height * 0.15, size.width * 0.9, size.height * 0.65);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), foamPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WashOverlayPainter oldDelegate) {
    return oldDelegate.isSoapPhase != isSoapPhase ||
        oldDelegate.soapProgress != soapProgress ||
        oldDelegate.rinseProgress != rinseProgress;
  }
}
