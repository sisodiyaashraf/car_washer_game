import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../data/models/vehicle_def.dart';

class RepairToolBar extends StatelessWidget {
  final List<RepairSpotDef> repairSpots;
  final String? activeSpotId;
  final ValueChanged<String> onSpotSelected;

  const RepairToolBar({
    super.key,
    required this.repairSpots,
    required this.activeSpotId,
    required this.onSpotSelected,
  });

  String _getToolNameForType(RepairSpotType type) {
    switch (type) {
      case RepairSpotType.dent:
        return 'hammer';
      case RepairSpotType.flatTire:
        return 'air_pump';
      case RepairSpotType.brokenLight:
        return 'bulb';
      case RepairSpotType.scratch:
        return 'hammer';
      case RepairSpotType.engine:
        return 'spark_plug';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: repairSpots.map((spot) {
            final isSelected = spot.id == activeSpotId;
            final toolName = _getToolNameForType(spot.spotType);

            return GestureDetector(
              onTap: () => onSpotSelected(spot.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.black12,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AssetPaths.toolIcon(toolName),
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.build, color: isSelected ? Colors.white : AppColors.textPrimary, size: 20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      spot.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
