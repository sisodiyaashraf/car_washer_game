import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/game_controller.dart';
import 'vehicle_image_widget.dart';

class PaintView extends StatelessWidget {
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
              'PAINT BOOTH: Pick a body color!',
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

                return SizedBox(
                  width: width,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: VehicleImageWidget(
                      key: ValueKey('${vehicle.id}_${controller.vehiclePaintColorName}'),
                      vehicleId: vehicle.id,
                      imageId: vehicle.imageId,
                      isDamaged: false,
                      paintColorName: controller.vehiclePaintColorName,
                      baseColor: controller.vehiclePaintColor,
                      rimStyle: controller.selectedRimStyle,
                      decalType: controller.selectedDecal,
                      decalOffset: controller.decalOffset,
                      decalScale: controller.decalScale,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Color Swatches Selector
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: AppColors.surface,
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: colorSwatches.map((swatch) {
                    final colorName = swatch['name'] as String;
                    final color = swatch['color'] as Color;
                    final isSelected = controller.vehiclePaintColorName == colorName;

                    return GestureDetector(
                      onTap: () => controller.selectPaintColorName(colorName, color),
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
