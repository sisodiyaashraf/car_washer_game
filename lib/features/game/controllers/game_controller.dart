import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/customization_def.dart';
import '../../../data/models/level_def.dart';
import '../../../data/models/vehicle_def.dart';
import '../../../data/models/wash_tool_def.dart';
import '../../../data/repositories/level_repository.dart';
import '../../../data/repositories/tool_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';

enum GamePhase {
  washSoap,
  washRinse,
  repair,
  paint,
  customization,
  preview,
  done,
}

enum RewardType {
  doubleCoins,
  unlockPressureWasher,
  skipRepairStep,
  freeVehicleTry,
}

class GameController extends ChangeNotifier {
  late LevelDef levelDef;
  late VehicleDef vehicleDef;

  GamePhase _phase = GamePhase.washSoap;
  GamePhase get phase => _phase;

  // Level Timer
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;
  Timer? _timer;

  // --- WASH PHASE STATE ---
  late List<List<bool>> _soapGrid; // true = foamed
  late List<List<bool>> _rinseGrid; // true = rinsed
  double _soapProgress = 0.0;
  double _rinseProgress = 0.0;

  double get soapProgress => _soapProgress;
  double get rinseProgress => _rinseProgress;

  WashToolDef _selectedWashTool = ToolRepository.washTools.first;
  WashToolDef get selectedWashTool => _selectedWashTool;

  // --- REPAIR PHASE STATE ---
  final Map<String, int> _repairHitsRemaining = {};
  Map<String, int> get repairHitsRemaining => Map.unmodifiable(_repairHitsRemaining);
  String? _selectedRepairSpotId;
  String? get selectedRepairSpotId => _selectedRepairSpotId;

  // --- PAINT & CUSTOMIZATION STATE ---
  late Color _currentColor;
  Color get currentColor => _currentColor;

  late Color _vehiclePaintColor;
  Color get vehiclePaintColor => _vehiclePaintColor;

  DecalType _selectedDecal = DecalType.none;
  DecalType get selectedDecal => _selectedDecal;

  Offset _decalOffset = const Offset(0.5, 0.45);
  Offset get decalOffset => _decalOffset;

  double _decalScale = 1.0;
  double get decalScale => _decalScale;

  RimStyle _selectedRimStyle = RimStyle.classic;
  RimStyle get selectedRimStyle => _selectedRimStyle;

  // Result Stats
  int _earnedStars = 0;
  int get earnedStars => _earnedStars;

  int _earnedCoins = 0;
  int get earnedCoins => _earnedCoins;

  bool _hasClaimed2XCoins = false;
  bool get hasClaimed2XCoins => _hasClaimed2XCoins;

  GameController({int initialLevel = 1}) {
    loadLevel(initialLevel);
  }

  void loadLevel(int levelNumber) {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _phase = GamePhase.washSoap;
    _hasClaimed2XCoins = false;

    levelDef = LevelRepository.getLevel(levelNumber);
    vehicleDef = VehicleRepository.getVehicleById(levelDef.vehicleId);

    // Init Grids
    _soapGrid = List.generate(
      GameConstants.washGridRows,
      (_) => List.filled(GameConstants.washGridCols, false),
    );
    _rinseGrid = List.generate(
      GameConstants.washGridRows,
      (_) => List.filled(GameConstants.washGridCols, false),
    );
    _soapProgress = 0.0;
    _rinseProgress = 0.0;

    // Load Default Tool
    _selectedWashTool = ToolRepository.washTools.firstWhere((t) => t.isForSoap);

    // Init Repair Spots
    _repairHitsRemaining.clear();
    final spotsToInclude = vehicleDef.repairSpots.take(levelDef.activeRepairSpotsCount);
    for (final spot in spotsToInclude) {
      _repairHitsRemaining[spot.id] = spot.hitsNeeded;
    }
    _selectedRepairSpotId = _repairHitsRemaining.keys.isNotEmpty ? _repairHitsRemaining.keys.first : null;

    // Load saved or base customization
    final saved = StorageService().getCustomization(vehicleDef.id);
    _currentColor = saved?.paintColor ?? vehicleDef.baseColor;
    _vehiclePaintColor = _currentColor;
    _selectedDecal = saved?.decalType ?? DecalType.none;
    _decalOffset = saved?.decalOffset ?? const Offset(0.5, 0.45);
    _decalScale = saved?.decalScale ?? 1.0;
    _selectedRimStyle = saved?.rimStyle ?? RimStyle.classic;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_phase != GamePhase.done) {
        _elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- REWARDED ADS HOOK ---
  void onRewardedRequested(RewardType type, VoidCallback onGranted) {
    // AdMob hook placeholder - will trigger ad load in step 7
    onGranted();
    notifyListeners();
  }

  // --- WASH MECHANIC ---
  void selectWashTool(WashToolDef tool) {
    _selectedWashTool = tool;
    notifyListeners();
  }

  void scrubAt(Offset relativeOffset) {
    if (_phase != GamePhase.washSoap && _phase != GamePhase.washRinse) return;

    final rows = GameConstants.washGridRows;
    final cols = GameConstants.washGridCols;

    final centerCol = (relativeOffset.dx * cols).round();
    final centerRow = (relativeOffset.dy * rows).round();
    final radiusRatio = _selectedWashTool.radiusRatio;
    final gridRadius = (radiusRatio * cols).round().clamp(1, 4);

    bool changed = false;

    for (int r = centerRow - gridRadius; r <= centerRow + gridRadius; r++) {
      for (int c = centerCol - gridRadius; c <= centerCol + gridRadius; c++) {
        if (r >= 0 && r < rows && c >= 0 && c < cols) {
          final distSq = (r - centerRow) * (r - centerRow) + (c - centerCol) * (c - centerCol);
          if (distSq <= gridRadius * gridRadius) {
            if (_phase == GamePhase.washSoap) {
              if (!_soapGrid[r][c]) {
                _soapGrid[r][c] = true;
                changed = true;
              }
            } else if (_phase == GamePhase.washRinse) {
              if (_soapGrid[r][c] && !_rinseGrid[r][c]) {
                _rinseGrid[r][c] = true;
                changed = true;
              }
            }
          }
        }
      }
    }

    if (changed) {
      _updateWashProgress();
    }
  }

  void _updateWashProgress() {
    final total = GameConstants.washGridRows * GameConstants.washGridCols;
    
    if (_phase == GamePhase.washSoap) {
      int count = 0;
      for (var r in _soapGrid) {
        for (var c in r) {
          if (c) count++;
        }
      }
      _soapProgress = count / total;

      if (_soapProgress >= levelDef.dirtCleanTarget) {
        _phase = GamePhase.washRinse;
        _selectedWashTool = ToolRepository.washTools.firstWhere((t) => !t.isForSoap);
      }
    } else if (_phase == GamePhase.washRinse) {
      int count = 0;
      for (var r in _rinseGrid) {
        for (var c in r) {
          if (c) count++;
        }
      }
      _rinseProgress = count / total;

      if (_rinseProgress >= levelDef.dirtCleanTarget) {
        _phase = GamePhase.repair;
      }
    }

    notifyListeners();
  }

  void forceCompleteWashStage() {
    if (_phase == GamePhase.washSoap) {
      _soapProgress = 1.0;
      for (int r = 0; r < GameConstants.washGridRows; r++) {
        for (int c = 0; c < GameConstants.washGridCols; c++) {
          _soapGrid[r][c] = true;
        }
      }
      _phase = GamePhase.washRinse;
      _selectedWashTool = ToolRepository.washTools.firstWhere((t) => !t.isForSoap);
    } else if (_phase == GamePhase.washRinse) {
      _rinseProgress = 1.0;
      _phase = GamePhase.repair;
    }
    notifyListeners();
  }

  // --- REPAIR MECHANIC ---
  void selectRepairSpot(String spotId) {
    _selectedRepairSpotId = spotId;
    notifyListeners();
  }

  void hitRepairSpot(String spotId) {
    if (_phase != GamePhase.repair) return;
    if (!_repairHitsRemaining.containsKey(spotId)) return;

    final remaining = _repairHitsRemaining[spotId]!;
    if (remaining > 0) {
      _repairHitsRemaining[spotId] = remaining - 1;

      // Automatically select next uncompleted spot if any
      final remainingUnfixed = _repairHitsRemaining.keys.where((k) => _repairHitsRemaining[k]! > 0);
      if (remainingUnfixed.isNotEmpty) {
        _selectedRepairSpotId = remainingUnfixed.first;
      }

      if (isRepairComplete) {
        _phase = GamePhase.paint;
      }
      notifyListeners();
    }
  }

  bool get isRepairComplete {
    return _repairHitsRemaining.values.every((hits) => hits <= 0);
  }

  // --- PAINT & CUSTOMIZATION MECHANIC ---
  void selectPaintColor(Color color) {
    _currentColor = color;
    _vehiclePaintColor = color;
    notifyListeners();
  }

  void completePaint() {
    if (_phase == GamePhase.paint) {
      _phase = GamePhase.customization;
      notifyListeners();
    }
  }

  void selectDecal(DecalType type) {
    _selectedDecal = type;
    notifyListeners();
  }

  void updateDecalTransform(Offset offset, double scale) {
    _decalOffset = offset;
    _decalScale = scale.clamp(0.5, 2.0);
    notifyListeners();
  }

  void selectRimStyle(RimStyle style) {
    _selectedRimStyle = style;
    notifyListeners();
  }

  void completeCustomization() {
    if (_phase == GamePhase.customization) {
      // Save customization
      final custom = VehicleCustomization(
        vehicleId: vehicleDef.id,
        paintColor: _vehiclePaintColor,
        decalType: _selectedDecal,
        decalOffset: _decalOffset,
        decalScale: _decalScale,
        rimStyle: _selectedRimStyle,
      );
      StorageService().saveCustomization(custom);

      _phase = GamePhase.preview;
      notifyListeners();
    }
  }

  void finishPreviewAndCompleteLevel() {
    if (_phase == GamePhase.preview) {
      _calculateResultsAndFinish();
    }
  }

  // --- DONE PHASE ---
  void _calculateResultsAndFinish() {
    _timer?.cancel();
    _phase = GamePhase.done;

    if (_elapsedSeconds <= levelDef.star3TimeLimitSec) {
      _earnedStars = 3;
    } else if (_elapsedSeconds <= levelDef.star2TimeLimitSec) {
      _earnedStars = 2;
    } else {
      _earnedStars = 1;
    }

    _earnedCoins = levelDef.baseCoinReward + (_earnedStars * GameConstants.baseCoinsPerStar);
    notifyListeners();
  }

  void claim2XCoinsReward() {
    if (!_hasClaimed2XCoins && _phase == GamePhase.done) {
      onRewardedRequested(RewardType.doubleCoins, () {
        _earnedCoins *= 2;
        _hasClaimed2XCoins = true;
      });
    }
  }

  void startNextLevel() {
    loadLevel(levelDef.levelNumber + 1);
  }
}
