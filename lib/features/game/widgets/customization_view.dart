import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/customization_def.dart';
import '../../../data/repositories/customization_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../controllers/game_controller.dart';

class CustomizationView extends StatefulWidget {
  const CustomizationView({super.key});

  @override
  State<CustomizationView> createState() => _CustomizationViewState();
}

class _CustomizationViewState extends State<CustomizationView> {
  int _activeTab = 0; // 0 = Decals, 1 = Rims

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Decals / Stickers'), icon: Icon(Icons.star)),
              ButtonSegment(value: 1, label: Text('Wheel Rims'), icon: Icon(Icons.adjust)),
            ],
            selected: {_activeTab},
            onSelectionChanged: (set) => setState(() => _activeTab = set.first),
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
                    if (controller.selectedDecal != DecalType.none) {
                      final newOffset = Offset(
                        (controller.decalOffset.dx + details.delta.dx / width).clamp(0.2, 0.8),
                        (controller.decalOffset.dy + details.delta.dy / height).clamp(0.2, 0.8),
                      );
                      controller.updateDecalTransform(newOffset, controller.decalScale);
                    }
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
        // Selection Tray
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: AppColors.surface,
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: _activeTab == 0
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: CustomizationRepository.decals.length,
                        itemBuilder: (context, index) {
                          final decal = CustomizationRepository.decals[index];
                          final isSelected = controller.selectedDecal == decal.type;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              avatar: Icon(decal.icon, size: 18),
                              label: Text(decal.name),
                              selected: isSelected,
                              onSelected: (_) => controller.selectDecal(decal.type),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: CustomizationRepository.rims.length,
                        itemBuilder: (context, index) {
                          final rim = CustomizationRepository.rims[index];
                          final isSelected = controller.selectedRimStyle == rim.style;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              avatar: Icon(rim.icon, size: 18),
                              label: Text(rim.name),
                              selected: isSelected,
                              onSelected: (_) => controller.selectRimStyle(rim.style),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => controller.completeCustomization(),
                icon: const Icon(Icons.check_circle),
                label: const Text('Save & Preview Vehicle'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
