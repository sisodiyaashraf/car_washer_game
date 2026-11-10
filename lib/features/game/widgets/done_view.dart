import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/ads/ad_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../../../core/services/storage_service.dart';
import '../controllers/game_controller.dart';

class DoneView extends StatefulWidget {
  const DoneView({super.key});

  @override
  State<DoneView> createState() => _DoneViewState();
}

class _DoneViewState extends State<DoneView> with SingleTickerProviderStateMixin {
  late AnimationController _starController;
  final ParticlePool _confettiPool = ParticlePool();
  bool _isProcessingReward = false;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _starController.addListener(() {
      if (mounted) setState(() {});
    });

    _starController.forward();
    HapticsService().successPattern();
    AudioService().playLevelCompleteSound();

    // Trigger confetti burst
    _confettiPool.spawnBurst(const Offset(150, 100), ParticleType.spark, AppColors.secondary, count: 20);
    _confettiPool.spawnBurst(const Offset(150, 100), ParticleType.shine, AppColors.primary, count: 15);
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final stars = controller.earnedStars;
    final coins = controller.earnedCoins;
    final hasClaimed2x = controller.hasClaimed2XCoins;

    StorageService().addCoins(coins);
    StorageService().completeLevel(controller.levelDef.levelNumber, stars: stars);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Confetti Canvas
              CustomPaint(
                size: const Size(300, 300),
                painter: ParticlePainter(particles: _confettiPool.activeParticles),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 340),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🎉 LEVEL COMPLETE! 🎉',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sequential Animated Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final starThreshold = (index + 1) / 3.0;
                        final isVisible = _starController.value >= starThreshold && index < stars;

                        return ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _starController,
                            curve: Interval(index * 0.3, (index + 1) * 0.3, curve: Curves.elasticOut),
                          ),
                          child: Icon(
                            isVisible ? Icons.star : Icons.star_border,
                            color: isVisible ? AppColors.secondary : Colors.grey.shade300,
                            size: 46,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Finished in ${controller.elapsedSeconds} seconds',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    // Coin Counter Animated Count-up
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on, color: AppColors.accent, size: 28),
                          const SizedBox(width: 8),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: coins),
                            duration: const Duration(milliseconds: 1000),
                            builder: (context, val, child) {
                              return Text(
                                '+$val Coins',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 2X Coins Rewarded Ad button with double-tap protection
                    ElevatedButton.icon(
                      onPressed: (hasClaimed2x || _isProcessingReward)
                          ? null
                          : () {
                              setState(() => _isProcessingReward = true);
                              AdService().showRewardedAd(
                                context: context,
                                onRewardGranted: () {
                                  controller.claim2XCoinsReward();
                                  if (mounted) setState(() => _isProcessingReward = false);
                                },
                              );
                              Future.delayed(const Duration(seconds: 3), () {
                                if (mounted) setState(() => _isProcessingReward = false);
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasClaimed2x ? Colors.grey : AppColors.accent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.ondemand_video),
                      label: Text(
                        hasClaimed2x ? '2X Coins Claimed!' : '2X COINS (WATCH AD)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Next Level button
                    ElevatedButton.icon(
                      onPressed: () => controller.startNextLevel(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text(
                        'NEXT CAR / LEVEL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back to Menu', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
