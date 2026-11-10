import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../controllers/game_controller.dart';

class PaintView extends StatelessWidget {
  const PaintView({super.key});

  static const List<Color> palette = [
    Color(0xFF1E88E5), // Blue
    Color(0xFFE53935), // Red
    Color(0xFF43A047), // Green
    Color(0xFFFFB703), // Yellow/Gold
    Color(0xFF8E24AA), // Purple
    Color(0xFFFB8C00), // Orange
    Color(0xFF00ACC1), // Cyan
    Color(0xFFD81B60), // Pink
    Color(0xFF212121), // Charcoal Black
    Color(0xFFECEFF1), // Silver/White
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Chip(
            avatar: Icon(Icons.format_paint, size: 18, color: AppColors.primaryDark),
            label: Text(
              'PAINT BOOTH: Choose body color!',
              style: TextStyle(fontWeight: FontWeight.bold),
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
                  onPanUpdate: (details) {
                    // Spray paint touch gesture inside paint zone
                  },
                  child: CustomPaint(
                    size: Size(width, height),
                    painter: VehicleRepository.buildVehiclePainter(
                      vehicleId: vehicle.id,
                      bodyColor: controller.vehiclePaintColor,
                      rimStyle: controller.selectedRimStyle,
                      decalType: controller.selectedDecal,
                      decalOffset: controller.decalOffset,
                      decalScale: controller.decalScale,
                      isCleanShine: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Color Palette Selector
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: AppColors.surface,
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: palette.length,
                  itemBuilder: (context, index) {
                    final color = palette[index];
                    final isSelected = controller.vehiclePaintColor == color;

                    return GestureDetector(
                      onTap: () => controller.selectPaintColor(color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
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
                  },
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
