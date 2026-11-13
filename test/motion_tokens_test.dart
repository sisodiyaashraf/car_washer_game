import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/layout/game_layout.dart';
import 'package:carwasher/core/motion/motion_tokens.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MotionTokens & Layout Tests', () {
    test('1. Layout config default is landscape', () {
      expect(kLandscape, isTrue);
    });

    test('2. Motion tokens have non-zero durations and valid spring parameters', () {
      expect(MotionTokens.uiPressDownDuration.inMilliseconds, 90);
      expect(MotionTokens.uiPressScale, 0.92);
      expect(MotionTokens.panelInDuration.inMilliseconds, 320);
      expect(MotionTokens.panelInCurve, Curves.easeOutBack);
      expect(MotionTokens.cameraZoomMin, 1.0);
      expect(MotionTokens.cameraZoomMax, 1.35);
      expect(MotionTokens.cameraZoomStiffness, 180.0);
      expect(MotionTokens.cameraZoomDamping, 20.0);
    });
  });
}
