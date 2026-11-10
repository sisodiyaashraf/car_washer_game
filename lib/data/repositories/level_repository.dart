import '../models/level_def.dart';

class LevelRepository {
  static const List<String> _vehicleOrder = [
    'hatchback',
    'sports_car',
    'pickup_truck',
    'police_car',
    'monster_truck',
    'plane',
  ];

  static LevelDef getLevel(int levelNumber) {
    if (levelNumber <= 0) levelNumber = 1;

    // Pick vehicle based on level number
    final vehicleIndex = (levelNumber - 1) % _vehicleOrder.length;
    final vehicleId = _vehicleOrder[vehicleIndex];

    // Difficulty increases with level number
    final double dirtTarget = (0.85 + (levelNumber - 1) * 0.02).clamp(0.85, 0.98);
    final int activeSpotsCount = (2 + ((levelNumber - 1) ~/ 2)).clamp(2, 4);
    final int star3Limit = (90 - (levelNumber - 1) * 5).clamp(45, 90);
    final int star2Limit = (star3Limit + 25);
    final int baseCoins = 100 + (levelNumber - 1) * 25;

    return LevelDef(
      levelNumber: levelNumber,
      vehicleId: vehicleId,
      dirtCleanTarget: dirtTarget,
      activeRepairSpotsCount: activeSpotsCount,
      star3TimeLimitSec: star3Limit,
      star2TimeLimitSec: star2Limit,
      baseCoinReward: baseCoins,
    );
  }
}
