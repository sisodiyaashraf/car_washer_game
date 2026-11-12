import 'package:flutter/material.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../core/purchases/purchase_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/page_transitions.dart';
import '../../game/screens/game_screen.dart';
import '../../garage/screens/garage_screen.dart';
import '../widgets/daily_reward_dialog.dart';
import '../widgets/settings_dialog.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;
  final ParticlePool _bubblePool = ParticlePool();

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _bubbleController.addListener(() {
      _bubblePool.update(0.016);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  void _refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Coins & Settings Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        AssetPaths.ui('gear'),
                        width: 32,
                        height: 32,
                        errorBuilder: (c, e, s) => const Icon(Icons.settings, color: Colors.white, size: 28),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const SettingsDialog(),
                        );
                        _refreshState();
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            AssetPaths.ui('coin'),
                            width: 24,
                            height: 24,
                            errorBuilder: (c, e, s) => const Icon(Icons.monetization_on, color: AppColors.secondary, size: 22),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${storage.coins}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Title & Interactive Bubble Emblem
              GestureDetector(
                onTapDown: (details) {
                  _bubblePool.spawnBurst(details.localPosition, ParticleType.soap, Colors.white, count: 6);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(220, 150),
                      painter: ParticlePainter(particles: _bubblePool.activeParticles),
                    ),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 5),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_car_filled,
                        size: 96,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                GameConstants.appName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Current Level: ${storage.currentLevel}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              // Sleek Modern Menu Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          SmoothPageRoute(
                            page: GameScreen(levelNumber: storage.currentLevel),
                          ),
                        );
                        _refreshState();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.black87,
                        elevation: 6,
                        minimumSize: const Size(double.infinity, 58),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: Image.asset(
                        AssetPaths.ui('play_ticket'),
                        width: 28,
                        height: 28,
                        errorBuilder: (c, e, s) => const Icon(Icons.play_arrow_rounded, size: 30),
                      ),
                      label: const Text(
                        'START PLAYING',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                SmoothPageRoute(page: const GarageScreen()),
                              );
                              _refreshState();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cardBg,
                              foregroundColor: AppColors.textPrimary,
                              elevation: 2,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.garage, color: AppColors.primary),
                            label: const Text('GARAGE', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => const DailyRewardDialog(),
                              );
                              _refreshState();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cardBg,
                              foregroundColor: AppColors.textPrimary,
                              elevation: 2,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: Image.asset(
                              AssetPaths.ui('star_filled'),
                              width: 20,
                              height: 20,
                              errorBuilder: (c, e, s) => const Icon(Icons.card_giftcard, color: AppColors.secondary),
                            ),
                            label: const Text('DAILY REWARD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ),
                      ],
                    ),
                    if (!storage.hasRemovedAds) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () => PurchaseService().buyRemoveAds(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.cardBg),
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.block, size: 18),
                        label: const Text('REMOVE ADS (IAP)'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const AdaptiveBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
