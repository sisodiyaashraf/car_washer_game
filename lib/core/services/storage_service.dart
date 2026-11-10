import 'dart:convert';
import '../../data/models/customization_def.dart';

/// Versioned storage service for local game persistence & settings.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const int currentSchemaVersion = 1;

  int _coins = 200;
  int _currentLevel = 1;
  String _selectedVehicleId = 'hatchback';
  final Set<String> _unlockedVehicles = {'hatchback'};
  final Map<int, int> _bestStarsPerLevel = {};
  final Map<String, int> _toolUpgradeLevels = {};
  final Map<String, VehicleCustomization> _vehicleCustomizations = {};

  // Settings & Tutorial Flags
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  bool _isVibrationEnabled = true;
  bool _hasRemovedAds = false;
  bool _hasCompletedTutorial = false;
  bool _showPerformanceOverlay = false;

  // Daily Streak
  int _dailyStreakCount = 0;
  DateTime? _lastClaimDate;

  // Getters
  int get coins => _coins;
  int get currentLevel => _currentLevel;
  String get selectedVehicleId => _selectedVehicleId;
  Set<String> get unlockedVehicles => Set.unmodifiable(_unlockedVehicles);
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get hasRemovedAds => _hasRemovedAds;
  bool get hasCompletedTutorial => _hasCompletedTutorial;
  bool get showPerformanceOverlay => _showPerformanceOverlay;
  int get dailyStreakCount => _dailyStreakCount;
  DateTime? get lastClaimDate => _lastClaimDate;

  Future<void> init() async {
    migrateSchemaIfNeeded(currentSchemaVersion);
  }

  void migrateSchemaIfNeeded(int targetVersion) {
    try {
      // Version 1 schema initialization & safe migration
    } catch (_) {
      _resetToDefaults();
    }
  }

  void _resetToDefaults() {
    _coins = 200;
    _currentLevel = 1;
    _selectedVehicleId = 'hatchback';
    _unlockedVehicles.clear();
    _unlockedVehicles.add('hatchback');
    _bestStarsPerLevel.clear();
    _toolUpgradeLevels.clear();
    _isSoundEnabled = true;
    _isMusicEnabled = true;
    _isVibrationEnabled = true;
    _hasRemovedAds = false;
    _hasCompletedTutorial = false;
    _showPerformanceOverlay = false;
    _dailyStreakCount = 0;
    _lastClaimDate = null;
  }

  void completeTutorial() {
    _hasCompletedTutorial = true;
  }

  // Coin & Progress
  void addCoins(int amount) {
    _coins += amount;
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      return true;
    }
    return false;
  }

  void unlockVehicle(String vehicleId) {
    _unlockedVehicles.add(vehicleId);
  }

  bool isVehicleUnlocked(String vehicleId) {
    return _unlockedVehicles.contains(vehicleId);
  }

  void setSelectedVehicle(String vehicleId) {
    if (isVehicleUnlocked(vehicleId)) {
      _selectedVehicleId = vehicleId;
    }
  }

  void completeLevel(int level, {int stars = 3}) {
    if (level >= _currentLevel) {
      _currentLevel = level + 1;
    }
    final existingStars = _bestStarsPerLevel[level] ?? 0;
    if (stars > existingStars) {
      _bestStarsPerLevel[level] = stars;
    }
  }

  int getBestStarsForLevel(int level) => _bestStarsPerLevel[level] ?? 0;

  // Tool Upgrades
  int getUpgradeLevel(String upgradeId) => _toolUpgradeLevels[upgradeId] ?? 0;

  bool buyUpgrade(String upgradeId, int cost, int maxLevel) {
    final currentLvl = getUpgradeLevel(upgradeId);
    if (currentLvl < maxLevel && spendCoins(cost)) {
      _toolUpgradeLevels[upgradeId] = currentLvl + 1;
      return true;
    }
    return false;
  }

  // Daily Rewards
  bool canClaimDailyReward() {
    if (_lastClaimDate == null) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(_lastClaimDate!.year, _lastClaimDate!.month, _lastClaimDate!.day);
    return today.isAfter(lastDate);
  }

  int claimDailyReward() {
    if (!canClaimDailyReward()) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastClaimDate != null) {
      final lastDate = DateTime(_lastClaimDate!.year, _lastClaimDate!.month, _lastClaimDate!.day);
      final differenceInDays = today.difference(lastDate).inDays;

      if (differenceInDays == 1) {
        _dailyStreakCount = (_dailyStreakCount % 7) + 1;
      } else {
        _dailyStreakCount = 1;
      }
    } else {
      _dailyStreakCount = 1;
    }

    _lastClaimDate = now;
    final rewards = [50, 100, 150, 200, 300, 500, 1000];
    final coinAmount = rewards[(_dailyStreakCount - 1) % 7];
    addCoins(coinAmount);
    return coinAmount;
  }

  // Settings Toggles
  void toggleSound(bool value) => _isSoundEnabled = value;
  void toggleMusic(bool value) => _isMusicEnabled = value;
  void toggleVibration(bool value) => _isVibrationEnabled = value;
  void togglePerformanceOverlay(bool value) => _showPerformanceOverlay = value;
  void setRemoveAds(bool value) => _hasRemovedAds = value;

  // Customization
  void saveCustomization(VehicleCustomization customization) {
    _vehicleCustomizations[customization.vehicleId] = customization;
  }

  VehicleCustomization? getCustomization(String vehicleId) {
    return _vehicleCustomizations[vehicleId];
  }

  String exportToJsonString() {
    return jsonEncode({
      'schemaVersion': currentSchemaVersion,
      'coins': _coins,
      'currentLevel': _currentLevel,
      'hasRemovedAds': _hasRemovedAds,
    });
  }
}
