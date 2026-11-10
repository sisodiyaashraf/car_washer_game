import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/services/storage_service.dart';
import 'package:carwasher/data/models/customization_def.dart';
import 'package:carwasher/data/repositories/tool_repository.dart';
import 'package:carwasher/features/game/controllers/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Wash Upgrades & Stages Tests', () {
    test('Initial phase starts in washSoap with soap tool selected', () {
      final controller = GameController(initialLevel: 1);
      expect(controller.phase, GamePhase.washSoap);
      expect(controller.selectedWashTool.isForSoap, isTrue);
      expect(controller.soapProgress, 0.0);
    });

    test('Scrubbing increases soap progress and advances to washRinse stage', () {
      final controller = GameController(initialLevel: 1);
      controller.scrubAt(const Offset(0.5, 0.5));
      expect(controller.soapProgress, greaterThan(0.0));

      controller.forceCompleteWashStage();
      expect(controller.phase, GamePhase.washRinse);
      expect(controller.selectedWashTool.isForSoap, isFalse);
    });

    test('Tool selection updates active wash tool', () {
      final controller = GameController(initialLevel: 1);
      final pressureWasher = ToolRepository.getWashToolById('pressure_washer');
      controller.selectWashTool(pressureWasher);
      expect(controller.selectedWashTool.id, 'pressure_washer');
    });
  });

  group('Repair Upgrades & Spot Tests', () {
    test('Repair hits decrement and advance phase when complete', () {
      final controller = GameController(initialLevel: 1);
      controller.forceCompleteWashStage(); // Soap -> Rinse
      controller.forceCompleteWashStage(); // Rinse -> Repair
      expect(controller.phase, GamePhase.repair);

      final spots = controller.repairHitsRemaining.keys.toList();
      for (final spotId in spots) {
        final hitsNeeded = controller.repairHitsRemaining[spotId]!;
        for (int i = 0; i < hitsNeeded; i++) {
          controller.hitRepairSpot(spotId);
        }
      }

      expect(controller.isRepairComplete, isTrue);
      expect(controller.phase, GamePhase.paint);
    });
  });

  group('Customization & Storage Persistence Tests', () {
    test('Vehicle customization is saved and retrieved from StorageService', () {
      final storage = StorageService();
      const custom = VehicleCustomization(
        vehicleId: 'sports_car',
        paintColor: Colors.red,
        decalType: DecalType.flames,
        rimStyle: RimStyle.sportSpoke,
      );

      storage.saveCustomization(custom);
      final retrieved = storage.getCustomization('sports_car');

      expect(retrieved, isNotNull);
      expect(retrieved?.paintColor, Colors.red);
      expect(retrieved?.decalType, DecalType.flames);
      expect(retrieved?.rimStyle, RimStyle.sportSpoke);
    });
  });
}
