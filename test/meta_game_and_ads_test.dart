import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/ads/ad_config.dart';
import 'package:carwasher/core/ads/ad_frequency_policy.dart';
import 'package:carwasher/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 6: Meta Game & Persistence Tests', () {
    test('Daily reward streak logic works correctly', () {
      final storage = StorageService();
      expect(storage.canClaimDailyReward(), isTrue);

      final reward = storage.claimDailyReward();
      expect(reward, 50);
      expect(storage.dailyStreakCount, 1);

      // Cannot claim twice on the same day
      expect(storage.canClaimDailyReward(), isFalse);
      expect(storage.claimDailyReward(), 0);
    });

    test('Shop purchase logic respects coins and max level constraints', () {
      final storage = StorageService();
      final initialCoins = storage.coins;

      // Fail purchase if cost higher than available coins
      final boughtOverPriced = storage.buyUpgrade('brush_radius', 99999, 3);
      expect(boughtOverPriced, isFalse);

      // Succeed purchase when coins are sufficient
      final bought = storage.buyUpgrade('brush_radius', 50, 3);
      expect(bought, isTrue);
      expect(storage.coins, initialCoins - 50);
      expect(storage.getUpgradeLevel('brush_radius'), 1);
    });

    test('Settings persistence toggles correctly', () {
      final storage = StorageService();
      expect(storage.isSoundEnabled, isTrue);

      storage.toggleSound(false);
      expect(storage.isSoundEnabled, isFalse);

      storage.toggleMusic(false);
      expect(storage.isMusicEnabled, isFalse);

      storage.toggleVibration(false);
      expect(storage.isVibrationEnabled, isFalse);
    });

    test('Save schema version and migration fallback operates safely', () {
      final storage = StorageService();
      storage.migrateSchemaIfNeeded(1);
      expect(StorageService.currentSchemaVersion, 1);
    });
  });

  group('Step 7: Ads & AdFrequencyPolicy Tests', () {
    test('Debug mode returns Google official TEST Ad IDs', () {
      if (kDebugMode) {
        expect(AdConfig.bannerAdUnitId, AdConfig.testBannerAdUnitId);
        expect(AdConfig.interstitialAdUnitId, AdConfig.testInterstitialAdUnitId);
        expect(AdConfig.rewardedAdUnitId, AdConfig.testRewardedAdUnitId);
      }
    });

    test('AdFrequencyPolicy enforces level requirements and time gap rules', () {
      final policy = AdFrequencyPolicy(minLevelRequirement: 2, levelInterval: 2, minTimeGapSeconds: 90);

      // Level 1: Should NOT show (<= minLevelRequirement)
      expect(policy.shouldShowInterstitial(completedLevelNumber: 1, hasRemovedAds: false), isFalse);

      // Level 2: Should NOT show (<= minLevelRequirement)
      expect(policy.shouldShowInterstitial(completedLevelNumber: 2, hasRemovedAds: false), isFalse);

      // Level 3: First level above minLevelRequirement (1st level counted)
      expect(policy.shouldShowInterstitial(completedLevelNumber: 3, hasRemovedAds: false), isFalse);

      // Level 4: 2nd level interval reached -> Should show
      final time1 = DateTime(2026, 1, 1, 12, 0, 0);
      final showOnL4 = policy.shouldShowInterstitial(
        completedLevelNumber: 4,
        hasRemovedAds: false,
        currentTime: time1,
      );
      expect(showOnL4, isTrue);

      policy.recordInterstitialShown(currentTime: time1);

      // 30 seconds later (too fast < 90s gap): Should NOT show
      final timeTooSoon = time1.add(const Duration(seconds: 30));
      expect(
        policy.shouldShowInterstitial(
          completedLevelNumber: 6,
          hasRemovedAds: false,
          currentTime: timeTooSoon,
        ),
        isFalse,
      );

      // 100 seconds later & interval met: Should show
      final timeLater = time1.add(const Duration(seconds: 100));
      policy.shouldShowInterstitial(completedLevelNumber: 5, hasRemovedAds: false, currentTime: timeLater); // +1 count
      expect(
        policy.shouldShowInterstitial(
          completedLevelNumber: 6,
          hasRemovedAds: false,
          currentTime: timeLater,
        ),
        isTrue,
      );
    });

    test('AdFrequencyPolicy returns false if player owns Remove Ads', () {
      final policy = AdFrequencyPolicy();
      expect(policy.shouldShowInterstitial(completedLevelNumber: 5, hasRemovedAds: true), isFalse);
    });
  });
}
