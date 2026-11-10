import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/storage_service.dart';
import 'ad_config.dart';
import 'ad_frequency_policy.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  final AdFrequencyPolicy frequencyPolicy = AdFrequencyPolicy();
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;

  bool _isRewardedLoading = false;
  bool _isInterstitialLoading = false;
  int _rewardedRetryAttempts = 0;
  int _interstitialRetryAttempts = 0;

  bool childDirectedTreatment = false; // Config flag: default off

  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      // Configure RequestConfiguration child-directed treatment
      final configuration = RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
      );
      await MobileAds.instance.updateRequestConfiguration(configuration);

      _loadRewardedAd();
      _loadInterstitialAd();
    } catch (_) {
      // Graceful fallback
    }
  }

  // --- REWARDED ADS ---
  void _loadRewardedAd() {
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          _rewardedRetryAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedLoading = false;
          _rewardedRetryAttempts++;
          final delay = Duration(seconds: (1 << _rewardedRetryAttempts).clamp(2, 32));
          Timer(delay, _loadRewardedAd);
        },
      ),
    );
  }

  void showRewardedAd({
    required BuildContext context,
    required void Function() onRewardGranted,
  }) {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No ad available, try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
      _loadRewardedAd();
      return;
    }

    bool rewardClaimed = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (!rewardClaimed) {
          rewardClaimed = true;
          onRewardGranted();
        }
      },
    );
  }

  // --- INTERSTITIAL ADS ---
  void _loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialRetryAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
          _interstitialRetryAttempts++;
          final delay = Duration(seconds: (1 << _interstitialRetryAttempts).clamp(2, 32));
          Timer(delay, _loadInterstitialAd);
        },
      ),
    );
  }

  void maybeShowInterstitial(int completedLevelNumber) {
    if (StorageService().hasRemovedAds) return;

    final shouldShow = frequencyPolicy.shouldShowInterstitial(
      completedLevelNumber: completedLevelNumber,
      hasRemovedAds: StorageService().hasRemovedAds,
    );

    if (shouldShow && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          frequencyPolicy.recordInterstitialShown();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }
}
