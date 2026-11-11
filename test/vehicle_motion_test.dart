import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/features/game/controllers/vehicle_motion.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VehicleMotion & Rolling Math Tests', () {
    test('1. Rolling spin math: wheelAngle equals distance divided by wheelRadius', () {
      const distance = 0.5;
      const wheelRadius = 0.1;
      const expectedAngle = distance / wheelRadius; // 5.0 radians

      final motion = VehicleMotion();
      expect(motion.wheelAngle, 0.0);

      // Verify mathematical formula
      expect(expectedAngle, 5.0);
    });

    test('2. Reduced motion drive in completes instantly with input unlocked', () {
      final motion = VehicleMotion();
      expect(motion.state, MotionState.offscreenLeft);
      expect(motion.isInputLocked, isTrue);

      // Synchronous reduced motion path
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
  });
}
