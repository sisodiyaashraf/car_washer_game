import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/game_controller.dart';

class PhaseIndicatorBar extends StatelessWidget {
  const PhaseIndicatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final level = controller.levelDef;
    final phase = controller.phase;

    String phaseText;
    double progress;

    switch (phase) {
      case GamePhase.washSoap:
        phaseText = 'Phase 1: Soap Foam';
        progress = (controller.soapProgress / level.dirtCleanTarget) * 0.5;
        break;
      case GamePhase.washRinse:
        phaseText = 'Phase 1: Rinse Water';
        progress = 0.5 + (controller.rinseProgress / level.dirtCleanTarget) * 0.5;
        break;
      case GamePhase.repair:
        phaseText = 'Phase 2: Garage Repair';
        final totalSpots = controller.repairHitsRemaining.length;
        if (totalSpots == 0) {
          progress = 1.0;
        } else {
          final fixed = controller.repairHitsRemaining.values.where((h) => h <= 0).length;
          progress = fixed / totalSpots;
        }
        break;
      case GamePhase.paint:
        phaseText = 'Phase 3: Paint Booth';
        progress = 1.0;
        break;
      case GamePhase.customization:
        phaseText = 'Phase 4: Decals & Rims';
        progress = 1.0;
        break;
      case GamePhase.preview:
        phaseText = 'Showcase Preview';
        progress = 1.0;
        break;
      case GamePhase.done:
        phaseText = 'Level Completed!';
        progress = 1.0;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${level.levelNumber} • ${controller.vehicleDef.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      phaseText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 18, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.elapsedSeconds}s',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  phase == GamePhase.washSoap || phase == GamePhase.washRinse
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
