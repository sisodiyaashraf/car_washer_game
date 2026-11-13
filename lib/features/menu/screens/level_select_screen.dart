import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/page_transitions.dart';
import '../../../core/ui/app_typography.dart';
import '../../../core/ui/app_ui_theme.dart';
import '../../../core/ui/widgets/game_button.dart';
import '../../game/screens/game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final currentLevel = storage.currentLevel;

    return Scaffold(
      backgroundColor: AppUITheme.navyOutline,
      appBar: AppBar(
        title: const Text('SELECT LEVEL', style: AppTypography.displayMedium),
        backgroundColor: AppUITheme.blueGradientEnd,
        elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 20,
                itemBuilder: (context, index) {
                  final levelNumber = index + 1;
                  final isUnlocked = levelNumber <= currentLevel;
                  final isCurrent = levelNumber == currentLevel;

                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 20, top: 12, bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppUITheme.cardBg : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppUITheme.radiusXL),
                      border: Border.all(
                        color: isCurrent ? AppUITheme.gold : AppUITheme.whiteBorder,
                        width: isCurrent ? 3 : 1.5,
                      ),
                      boxShadow: AppUITheme.panelShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'LEVEL $levelNumber',
                          style: AppTypography.displayMedium.copyWith(
                            color: isUnlocked ? Colors.white : Colors.white54,
                          ),
                        ),
                        // Vehicle Thumbnail
                        Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Image.asset(
                              AssetPaths.vehicleClean('pickup'),
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(Icons.directions_car, size: 48, color: Colors.white70),
                            ),
                          ),
                        ),
                        // Stars Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (starIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(
                                Icons.star,
                                color: isUnlocked ? AppUITheme.gold : Colors.white24,
                                size: 24,
                              ),
                            );
                          }),
                        ),
                        // Play / Locked Action Button
                        GameButton(
                          onPressed: isUnlocked
                              ? () {
                                  Navigator.of(context).pushReplacement(
                                    SmoothPageRoute(page: GameScreen(levelNumber: levelNumber)),
                                  );
                                }
                              : null,
                          label: isUnlocked ? 'PLAY' : 'LOCKED',
                          isDisabled: !isUnlocked,
                          isCTA: isCurrent,
                          size: 44,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
