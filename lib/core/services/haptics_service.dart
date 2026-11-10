import 'package:flutter/services.dart';
import 'storage_service.dart';

class HapticsService {
  static final HapticsService _instance = HapticsService._internal();
  factory HapticsService() => _instance;
  HapticsService._internal();

  DateTime? _lastScrubHapticTime;

  void lightImpact() {
    if (StorageService().isVibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void mediumImpact() {
    if (StorageService().isVibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void selectionClick() {
    if (StorageService().isVibrationEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  void successPattern() {
    if (StorageService().isVibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void throttledScrubHaptic({int intervalMs = 150}) {
    if (!StorageService().isVibrationEnabled) return;
    final now = DateTime.now();
    if (_lastScrubHapticTime == null || now.difference(_lastScrubHapticTime!).inMilliseconds >= intervalMs) {
      _lastScrubHapticTime = now;
      HapticFeedback.selectionClick();
    }
  }
}
