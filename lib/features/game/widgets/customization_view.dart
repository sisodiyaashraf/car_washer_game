import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../data/models/customization_def.dart';
import '../../../data/repositories/customization_repository.dart';
import '../controllers/game_controller.dart';
import 'vehicle_image_widget.dart';

class CustomizationView extends StatefulWidget {
  const CustomizationView({super.key});

  @override
  State<CustomizationView> createState() => _CustomizationViewState();
}

class _CustomizationViewState extends State<CustomizationView> {
  int _activeTab = 0; // 0 = Decals, 1 = Rims

  String _getDecalName(DecalType type) {
    switch (type) {
      case DecalType.stripes: return 'stripes';
      case DecalType.flames: return 'flames';
      case DecalType.racingNumber: return 'number07';
      case DecalType.stars: return 'starburst';
      case DecalType.camo: return 'camo';
      case DecalType.checker: return 'checkered';
      case DecalType.none: return '';
    }
  }

  String _getRimName(RimStyle style) {
    switch (style) {
      case RimStyle.sportSpoke: return 'sport5';
      case RimStyle.offroadBeadlock: return 'offroad';
      case RimStyle.starAlloy: return 'star';
      case RimStyle.classic: return 'classic';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;
    final decalName = _getDecalName(controller.selectedDecal);
    final rimName = _getRimName(controller.selectedRimStyle);

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
                final height = width / 2.0;

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
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        // Vehicle Clean Base Image
                        VehicleImageWidget(
                          vehicleId: vehicle.id,
                          imageId: vehicle.imageId,
                          isDamaged: false,
                          paintColorName: controller.vehiclePaintColorName,
                          baseColor: controller.vehiclePaintColor,
                        ),
                        // Decal Overlay Image (Draggable & Scalable)
                        if (decalName.isNotEmpty)
                          Positioned(
                            left: controller.decalOffset.dx * width - (60 * controller.decalScale),
                            top: controller.decalOffset.dy * height - (30 * controller.decalScale),
                            child: Image.asset(
                              AssetPaths.decal(decalName),
                              width: 120 * controller.decalScale,
                              height: 60 * controller.decalScale,
                              fit: BoxFit.contain,
                            ),
                          ),
                        // Rim Overlays (Sized to 1.38x wheel radius)
                        ...List.generate(vehicle.wheelCenters.length, (idx) {
                          final center = vehicle.wheelCenters[idx];
                          final radius = vehicle.wheelRadii[idx];
                          final rimDiameter = (radius * 2.0 * 1.38) * width;

                          final posX = center.dx * width - rimDiameter / 2;
                          final posY = center.dy * height - rimDiameter / 2;

                          return Positioned(
                            left: posX,
                            top: posY,
                            child: Image.asset(
                              AssetPaths.rim(rimName),
                              width: rimDiameter,
                              height: rimDiameter,
                              fit: BoxFit.contain,
                            ),
                          );
                        }),
                      ],
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
