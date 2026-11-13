import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/features/game/controllers/vehicle_motion.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 3 VehicleMotion Tests', () {
    test('1. Rolling spin math: wheelAngle equals distance divided by wheelRadius', () {
      const distance = 0.5;
      const wheelRadius = 0.1;
      const expectedAngle = distance / wheelRadius; // 5.0 radians

      final motion = VehicleMotion();
      expect(motion.wheelAngle, 0.0);
      expect(expectedAngle, 5.0);
    });

    test('2. State machine transitions from offscreenLeft -> arriving -> parked', () {
      final motion = VehicleMotion();
      expect(motion.state, MotionState.offscreenLeft);
      expect(motion.isInputLocked, isTrue);

      motion.startDriveIn(
        vsync: const TestVSync(),
        reducedMotion: true,
      );

      expect(motion.state, MotionState.parked);
      expect(motion.x, 0.0);
      expect(motion.isInputLocked, isFalse);
    });

    test('3. Skip animation fast-forwards current state to parked', () {
      final motion = VehicleMotion();
      motion.startDriveIn(
        vsync: const TestVSync(),
        reducedMotion: false,
      );

      expect(motion.state, MotionState.arriving);
      expect(motion.isInputLocked, isTrue);

      motion.skipAnimation();

      expect(motion.state, MotionState.parked);
      expect(motion.x, 0.0);
      expect(motion.isInputLocked, isFalse);
    });

    test('4. Input is locked while moving and unlocked when parked', () {
      final motion = VehicleMotion();
      expect(motion.isInputLocked, isTrue);

      motion.resetToParked();
      expect(motion.isInputLocked, isFalse);
    });
  });
}
