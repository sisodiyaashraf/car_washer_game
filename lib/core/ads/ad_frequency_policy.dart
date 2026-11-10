class AdFrequencyPolicy {
  final int minLevelRequirement;
  final int levelInterval;
  final int minTimeGapSeconds;

  int _levelsSinceLastAd = 0;
  DateTime? _lastInterstitialTime;

  AdFrequencyPolicy({
    this.minLevelRequirement = 2,
    this.levelInterval = 2,
    this.minTimeGapSeconds = 90,
  });

  bool shouldShowInterstitial({
    required int completedLevelNumber,
    required bool hasRemovedAds,
    DateTime? currentTime,
  }) {
    if (hasRemovedAds) return false;
    if (completedLevelNumber <= minLevelRequirement) return false;

    _levelsSinceLastAd++;
    if (_levelsSinceLastAd < levelInterval) return false;

    final now = currentTime ?? DateTime.now();
    if (_lastInterstitialTime != null) {
      final elapsed = now.difference(_lastInterstitialTime!).inSeconds;
      if (elapsed < minTimeGapSeconds) return false;
    }

    return true;
  }

  void recordInterstitialShown({DateTime? currentTime}) {
    _levelsSinceLastAd = 0;
    _lastInterstitialTime = currentTime ?? DateTime.now();
  }
}
