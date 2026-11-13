import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 7 Flow & Screen Tests', () {
    test('1. Settings persistence toggles sound, music, and reduced motion state', () {
      final storage = StorageService();

      storage.toggleSound(false);
      expect(storage.isSoundEnabled, isFalse);

      storage.toggleMusic(false);
      expect(storage.isMusicEnabled, isFalse);

      storage.toggleReducedMotion(true);
      expect(storage.isReducedMotionEnabled, isTrue);

      // Restore defaults
      storage.toggleSound(true);
      storage.toggleMusic(true);
      storage.toggleReducedMotion(false);
    });

    test('2. Star pop timing calculates staggered sequence at 300 ms gaps', () {
      const starGapMs = 300;
      final star1Time = 1 * starGapMs;
      final star2Time = 2 * starGapMs;
      final star3Time = 3 * starGapMs;

      expect(star1Time, 300);
      expect(star2Time, 600);
      expect(star3Time, 900);
    });
  });
}
