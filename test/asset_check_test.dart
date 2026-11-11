import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/constants/asset_paths.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AssetCheck Tests', () {
    test('Vehicle image assets exist on disk', () {
      final vehicleIds = ['hatchback', 'sports', 'pickup', 'cruiser', 'monster', 'biplane'];
      final colors = ['red', 'orange', 'yellow', 'green', 'blue', 'purple'];

      for (final id in vehicleIds) {
        expect(File(AssetPaths.vehicleClean(id)).existsSync(), isTrue, reason: 'Clean image missing for $id');
        expect(File(AssetPaths.vehicleDamaged(id)).existsSync(), isTrue, reason: 'Damaged image missing for $id');
        for (final color in colors) {
          expect(File(AssetPaths.vehiclePaint(id, color)).existsSync(), isTrue, reason: 'Paint image missing for $id $color');
        }
      }
    });

    test('Wheel sprite assets exist on disk', () {
      final families = ['classic', 'sport5', 'offroad', 'star', 'monster', 'plane'];
      for (final f in families) {
        expect(File(AssetPaths.wheelSprite(f)).existsSync(), isTrue, reason: 'Wheel sprite missing for $f');
      }
    });

    test('FX and Prop image assets exist on disk', () {
      expect(File(AssetPaths.fxDust()).existsSync(), isTrue);
      expect(File(AssetPaths.fxSpeedline()).existsSync(), isTrue);
      expect(File(AssetPaths.fxHeadlightBeam()).existsSync(), isTrue);
      expect(File(AssetPaths.fxHonk()).existsSync(), isTrue);
      expect(File(AssetPaths.propGarageDoor()).existsSync(), isTrue);
    });

    test('Background image assets exist on disk', () {
      final bgPhases = ['wash_bay', 'repair_garage', 'paint_booth'];
      for (final bg in bgPhases) {
        expect(File(AssetPaths.background(bg)).existsSync(), isTrue);
      }
    });

    test('Tool icon image assets exist on disk', () {
      final tools = ['sponge', 'spray_hose', 'pressure_washer', 'wheel_brush', 'hammer', 'air_pump', 'bulb', 'spare_tire', 'spark_plug', 'battery'];
      for (final tool in tools) {
        expect(File(AssetPaths.toolIcon(tool)).existsSync(), isTrue);
      }
    });

    test('Decal image assets exist on disk', () {
      final decals = ['stripes', 'flames', 'number07', 'starburst', 'camo', 'checkered'];
      for (final d in decals) {
        expect(File(AssetPaths.decal(d)).existsSync(), isTrue);
      }
    });

    test('Rim image assets exist on disk', () {
      final rims = ['classic', 'sport5', 'offroad', 'star'];
      for (final r in rims) {
        expect(File(AssetPaths.rim(r)).existsSync(), isTrue);
      }
    });

    test('UI image assets exist on disk', () {
      final uiElements = ['coin', 'star_filled', 'star_empty', 'gear', 'sound', 'play_ticket', 'button_normal', 'button_pressed', 'button_disabled', 'panel', 'progress_frame'];
      for (final u in uiElements) {
        expect(File(AssetPaths.ui(u)).existsSync(), isTrue);
      }
    });
  });
}
