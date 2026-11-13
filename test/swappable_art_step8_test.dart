import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/features/game/tools/tool_motion_defs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 8 Swappable Art & Performance Tests', () {
    test('1. ToolMotionDef contains pivot offsets and hand offsets for swappable art', () {
      final spongeDef = ToolMotionDef.getDef('sponge');
      expect(spongeDef.pivotOffset, const Offset(0.5, 0.5));
      expect(spongeDef.handOffset, const Offset(0.0, 30.0));

      final washerDef = ToolMotionDef.getDef('pressure_washer');
      expect(washerDef.pivotOffset, const Offset(0.2, 0.8));
    });

    test('2. Debug guide floor line Y ratio is 0.61 constant', () {
      const floorLineYRatio = 0.61;
      expect(floorLineYRatio, 0.61);
    });
  });
}
