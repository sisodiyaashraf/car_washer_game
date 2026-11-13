import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../controllers/game_controller.dart';
import 'vehicle_image_widget.dart';

class PaintView extends StatefulWidget {
  const PaintView({super.key});

  static const List<Map<String, dynamic>> colorSwatches = [
    {'name': 'red', 'color': Color(0xFFE53935)},
    {'name': 'orange', 'color': Color(0xFFFB8C00)},
    {'name': 'yellow', 'color': Color(0xFFFDD835)},
    {'name': 'green', 'color': Color(0xFF43A047)},
    {'name': 'blue', 'color': Color(0xFF1E88E5)},
    {'name': 'purple', 'color': Color(0xFF8E24AA)},
  ];

  @override
  State<PaintView> createState() => _PaintViewState();
}

class _PaintViewState extends State<PaintView> with SingleTickerProviderStateMixin {
  late AnimationController _sheenController;
  final ParticlePool _mistPool = ParticlePool();
  Offset? _touchPos;
  double _sheenAlpha = 0.0;

  @override
  void initState() {
    super.initState();
    _sheenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _sheenController.addListener(() {
      _mistPool.update(0.016);
      setState(() {
        _sheenAlpha = 1.0 - _sheenController.value;
      });
    });
  }

  @override
  void dispose() {
    _sheenController.dispose();
    super.dispose();
  }

  void _handleColorSelected(String colorName, Color color) {
    final controller = context.read<GameController>();
    HapticsService().selectionClick();
    AudioService().playSpraySound();

    controller.selectPaintColorName(colorName, color);
    _sheenController.forward(from: 0.0);
  }

  void _handleSprayPan(Offset pos) {
    _touchPos = pos;
    AudioService().playSpraySound();
    HapticsService().throttledScrubHaptic();
    _mistPool.spawnBurst(pos, ParticleType.spark, context.read<GameController>().vehiclePaintColor, count: 5);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.format_paint, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'PAINT BOOTH: PICK A COLOR & SPRAY!',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.9;
                final height = width / 2.0;

                return GestureDetector(
                  onPanDown: (d) => _handleSprayPan(d.localPosition),
                  onPanUpdate: (d) => _handleSprayPan(d.localPosition),
                  onPanEnd: (_) => setState(() => _touchPos = null),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        VehicleImageWidget(
                          key: ValueKey('${vehicle.id}_${controller.vehiclePaintColorName}'),
                          vehicleId: vehicle.id,
                          imageId: vehicle.imageId,
                          isDamaged: false,
                          paintColorName: controller.vehiclePaintColorName,
                          baseColor: controller.vehiclePaintColor,
                          rimStyle: controller.selectedRimStyle,
                          decalType: controller.selectedDecal,
                        ),
                        // Wet Paint Glossy Sheen Overlay (Fades in 600 ms)
                        if (_sheenAlpha > 0.05)
                          Positioned.fill(
                            child: Opacity(
                              opacity: _sheenAlpha * 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.white, Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Spray Particle Canvas
                        RepaintBoundary(
                          child: CustomPaint(
                            size: Size(width, height),
                            painter: ParticlePainter(particles: _mistPool.activeParticles),
                          ),
                        ),
                        // Spray Gun Touch Follower (3px kickback)
                        if (_touchPos != null)
                          Positioned(
                            left: _touchPos!.dx - 20,
                            top: _touchPos!.dy - 20 - 3.0,
                            child: Transform.rotate(
                              angle: -0.15,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white24,
                                ),
                                child: const Icon(Icons.format_paint, color: Colors.white, size: 24),
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
        // Color Swatches Selector Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: AppColors.surface,
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: PaintView.colorSwatches.map((swatch) {
                    final colorName = swatch['name'] as String;
                    final color = swatch['color'] as Color;
                    final isSelected = controller.vehiclePaintColorName == colorName;

                    return GestureDetector(
                      onTap: () => _handleColorSelected(colorName, color),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: isSelected ? AppColors.accent : Colors.black26,
                            width: isSelected ? 4 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => controller.completePaint(),
                icon: const Icon(Icons.palette),
                label: const Text('Proceed to Decals & Rims'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
