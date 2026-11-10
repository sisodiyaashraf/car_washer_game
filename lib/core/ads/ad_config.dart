import 'package:flutter/foundation.dart';

class AdConfig {
  // TODO: REPLACE BEFORE RELEASE with real production Ad Unit IDs from AdMob console
  static const String prodBannerAdUnitId = 'ca-app-pub-0000000000000000/0000000000';
  static const String prodInterstitialAdUnitId = 'ca-app-pub-0000000000000000/1111111111';
  static const String prodRewardedAdUnitId = 'ca-app-pub-0000000000000000/2222222222';

  // Google Official Test Ad Unit IDs
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return testBannerAdUnitId;
    }
    return prodBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return testInterstitialAdUnitId;
    }
    return prodInterstitialAdUnitId;
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return testRewardedAdUnitId;
    }
    return prodRewardedAdUnitId;
  }
}
