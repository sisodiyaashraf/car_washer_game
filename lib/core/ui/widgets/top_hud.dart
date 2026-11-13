import 'package:flutter/material.dart';
import '../../../core/constants/asset_paths.dart';
import '../app_ui_theme.dart';
import '../app_typography.dart';
import 'game_button.dart';

class TopHud extends StatelessWidget {
  final int coins;
  final double progress;
  final VoidCallback onPausePressed;

  const TopHud({
    super.key,
    required this.coins,
    required this.progress,
    required this.onPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final isComplete = clampedProgress >= 0.99;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppUITheme.navyOutline.withValues(alpha: 0.85),
        boxShadow: AppUITheme.buttonShadow,
      ),
      child: Row(
        children: [
          // Coin Counter Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppUITheme.cardBg,
              borderRadius: BorderRadius.circular(AppUITheme.radiusPill),
              border: Border.all(color: AppUITheme.gold, width: 1.5),
            ),
            child: Row(
              children: [
                Image.asset(
                  AssetPaths.ui('coin'),
                  width: 22,
                  height: 22,
                  errorBuilder: (c, e, s) => const Icon(Icons.monetization_on, color: AppUITheme.gold, size: 20),
                ),
                const SizedBox(width: 6),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: coins),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, val, child) {
                    return Text('$val', style: AppTypography.bodyLarge.copyWith(color: AppUITheme.gold));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Progress Bar with Car Badge Riding Along
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth - 36;
                final carX = barWidth * clampedProgress;

                return Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: [
                    // Background Bar Frame
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppUITheme.cardBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppUITheme.whiteBorder, width: 1.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 300),
                          widthFactor: clampedProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppUITheme.blueButtonGradient,
                              boxShadow: isComplete
                                  ? [const BoxShadow(color: AppUITheme.gold, blurRadius: 8)]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Riding Car Badge
                    Positioned(
                      left: carX,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppUITheme.gold,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: const Icon(Icons.directions_car, size: 16, color: Colors.black87),
                      ),
                    ),
                    // Checkered Flag Target at End
                    Positioned(
                      right: 0,
                      top: -6,
                      child: Icon(
                        Icons.flag,
                        color: isComplete ? AppUITheme.gold : Colors.white70,
                        size: 24,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // Pause Button
          GameButton(
            onPressed: onPausePressed,
            variant: GameButtonVariant.round,
            size: 40,
            icon: Icons.pause,
          ),
        ],
      ),
    );
  }
}
