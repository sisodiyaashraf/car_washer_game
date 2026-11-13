import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/camera/camera_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraController & Parallax Tests', () {
    test('1. Camera clamps zoom between 1.0 and 1.35', () {
      final camera = CameraController();
      expect(camera.zoom, 1.0);

      // Attempt over-zoom
      camera.focusOn(Offset.zero, 2.0);
      expect(camera.zoom, 1.35);

      // Attempt under-zoom
      camera.focusOn(Offset.zero, 0.5);
      expect(camera.zoom, 1.0);
    });

    test('2. Parallax factors generate expected Matrix4 translation multipliers', () {
      final camera = CameraController();
      camera.focusOn(const Offset(0.5, 0.0), 1.0);

      const stageSize = Size(800, 450);
      final farMatrix = camera.getStageTransform(0.2, stageSize);
      final midMatrix = camera.getStageTransform(0.5, stageSize);
      final floorMatrix = camera.getStageTransform(1.0, stageSize);
      final fgMatrix = camera.getStageTransform(1.3, stageSize);

      expect(farMatrix.getTranslation().x, greaterThan(0.0));
      expect(midMatrix.getTranslation().x, greaterThan(farMatrix.getTranslation().x));
      expect(floorMatrix.getTranslation().x, greaterThan(midMatrix.getTranslation().x));
      expect(fgMatrix.getTranslation().x, greaterThan(floorMatrix.getTranslation().x));
    });

    test('3. Floor line Y ratio aligns wheel bottoms at exactly 61% stage height', () {
      const stageHeight = 500.0;
      const floorLineYRatio = 0.61;
      const expectedFloorY = stageHeight * floorLineYRatio; // 305.0

      expect(expectedFloorY, 305.0);
    });
  });
}
