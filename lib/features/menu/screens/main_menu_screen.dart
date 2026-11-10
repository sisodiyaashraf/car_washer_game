import 'package:flutter/material.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/constants/app_colors.dart';
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
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Coins & Settings Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const SettingsDialog(),
                        );
                        _refreshState();
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.monetization_on, color: AppColors.secondary, size: 22),
                              const SizedBox(width: 6),
                              Text(
                                '${storage.coins}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Title & Icon Banner
              GestureDetector(
                onTapDown: (details) {
                  _bubblePool.spawnBurst(details.localPosition, ParticleType.soap, Colors.white, count: 6);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(200, 140),
                      painter: ParticlePainter(particles: _bubblePool.activeParticles),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_car_filled,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                GameConstants.appName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(color: Colors.black38, offset: Offset(2, 2), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Current Level: ${storage.currentLevel}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Menu Actions
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
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 30),
                      label: const Text(
                        'START PLAYING',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textPrimary,
                              minimumSize: const Size(double.infinity, 48),
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
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textPrimary,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            icon: const Icon(Icons.card_giftcard, color: AppColors.accent),
                            label: const Text('DAILY REWARD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                    if (!storage.hasRemovedAds) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () => PurchaseService().buyRemoveAds(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        icon: const Icon(Icons.block, size: 18),
                        label: const Text('REMOVE ADS (IAP)'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Adaptive Banner Ad at Bottom
              const AdaptiveBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
