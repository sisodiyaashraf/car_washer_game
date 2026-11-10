import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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

  IconData _getIconForType(RepairSpotType type) {
    switch (type) {
      case RepairSpotType.dent:
        return Icons.hardware;
      case RepairSpotType.flatTire:
        return Icons.tire_repair;
      case RepairSpotType.brokenLight:
        return Icons.lightbulb_outline;
      case RepairSpotType.scratch:
        return Icons.brush;
      case RepairSpotType.engine:
        return Icons.build_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: repairSpots.map((spot) {
          final isSelected = spot.id == activeSpotId;

          return GestureDetector(
            onTap: () => onSpotSelected(spot.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
                  Icon(
                    _getIconForType(spot.spotType),
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    size: 20,
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
    );
  }
}
