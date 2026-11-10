import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../controllers/game_controller.dart';

class VehiclePreviewView extends StatelessWidget {
  const VehiclePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            '✨ SHOWCASE PREVIEW ✨',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.9;
                final height = constraints.maxHeight * 0.7;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                  ),
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton.icon(
            onPressed: () => controller.finishPreviewAndCompleteLevel(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              minimumSize: const Size(double.infinity, 54),
            ),
            icon: const Icon(Icons.emoji_events, size: 28),
            label: const Text(
              'FINISH LEVEL & CLAIM REWARDS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
