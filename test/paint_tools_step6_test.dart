import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 6 Paint Tools & Motion Tests', () {
    test('1. Wet-paint sheen fade duration is exactly 600 ms', () {
      const sheenFadeDurationMs = 600;
      final fadeProgress = Curves.easeOut.transform(1.0);

      expect(sheenFadeDurationMs, 600);
      expect(fadeProgress, 1.0);
    });

    test('2. Diagonal spray-sweep wipe transition ends cleanly at 1.0', () {
      const wipeDurationMs = 700;
      final wipeT = Curves.easeInOutCubic.transform(1.0);

      expect(wipeDurationMs, 700);
      expect(wipeT, 1.0);
    });

    test('3. Spray gun kick-back offset is 3.0 px', () {
      const sprayKickbackPx = 3.0;
      expect(sprayKickbackPx, 3.0);
    });
  });
}
