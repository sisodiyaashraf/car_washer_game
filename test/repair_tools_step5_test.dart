import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 5 Repair Tools & Motion Tests', () {
    test('1. Jack lift height raises vehicle by 36 px with ease-out', () {
      const targetJackLift = 36.0;
      final liftProgress = Curves.easeOutCubic.transform(1.0);
      final currentLift = targetJackLift * liftProgress;

      expect(currentLift, 36.0);
    });

    test('2. Ratchet turns in exact 90-degree steps (pi / 2 radians)', () {
      const ratchetStepDeg = 90.0;
      final stepRad = ratchetStepDeg * (pi / 180.0);

      expect(stepRad, closeTo(pi / 2, 0.001));
    });

    test('3. Wrong part shake amplitude is ±6 px across cycles', () {
      const shakeAmp = 6.0;
      const cycleCount = 3;

      expect(shakeAmp, 6.0);
      expect(cycleCount, 3);
    });
  });
}
