import 'package:flutter/material.dart';
import '../../../core/ads/ad_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';

class DailyRewardDialog extends StatefulWidget {
  const DailyRewardDialog({super.key});

  @override
  State<DailyRewardDialog> createState() => _DailyRewardDialogState();
}

class _DailyRewardDialogState extends State<DailyRewardDialog> {
  final StorageService _storage = StorageService();
  int? _claimedAmount;
  bool _canClaim = false;

  @override
  void initState() {
    super.initState();
    _canClaim = _storage.canClaimDailyReward();
  }

  void _claimReward({bool doubleIt = false}) {
    if (!_canClaim) return;
    final baseAmount = _storage.claimDailyReward();
    final total = doubleIt ? baseAmount * 2 : baseAmount;

    if (doubleIt) {
      _storage.addCoins(baseAmount); // Add extra 1x
    }

    setState(() {
      _claimedAmount = total;
      _canClaim = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final streak = _storage.dailyStreakCount;
    final rewards = [50, 100, 150, 200, 300, 500, 1000];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎁 DAILY REWARD 🎁',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Streak: $streak Days',
              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            // 7-day grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final dayNum = index + 1;
                final isCurrent = (streak % 7 == index);
                final reward = rewards[index];

                return Container(
                  width: 70,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.secondary.withValues(alpha: 0.3) : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent ? AppColors.accent : Colors.black12,
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text('Day $dayNum', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      const Icon(Icons.monetization_on, color: AppColors.accent, size: 20),
                      Text('+$reward', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            if (_claimedAmount != null) ...[
              Text(
                '🎉 Claimed +$_claimedAmount Coins!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success),
              ),
              const SizedBox(height: 16),
            ],
            if (_canClaim) ...[
              ElevatedButton.icon(
                onPressed: () => _claimReward(doubleIt: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 46),
                ),
                icon: const Icon(Icons.check),
                label: const Text('Claim Reward'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  AdService().showRewardedAd(
                    context: context,
                    onRewardGranted: () => _claimReward(doubleIt: true),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                ),
                icon: const Icon(Icons.play_circle),
                label: const Text('2X REWARD (WATCH AD)'),
              ),
            ] else ...[
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
