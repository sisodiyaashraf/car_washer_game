class LevelDef {
  final int levelNumber;
  final String vehicleId;
  final double dirtCleanTarget; // e.g., 0.85 (85% clean)
  final int activeRepairSpotsCount;
  final int star3TimeLimitSec;
  final int star2TimeLimitSec;
  final int baseCoinReward;

  const LevelDef({
    required this.levelNumber,
    required this.vehicleId,
    required this.dirtCleanTarget,
    required this.activeRepairSpotsCount,
    required this.star3TimeLimitSec,
    required this.star2TimeLimitSec,
    required this.baseCoinReward,
  });
}
