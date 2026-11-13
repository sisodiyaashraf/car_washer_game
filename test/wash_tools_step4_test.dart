import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/particles/particle_pool.dart';
import 'package:carwasher/features/game/tools/tool_motion_defs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Step 4 Wash Tools Tests', () {
    test('1. ToolMotionDef tokens match required squash 0.85 and stretch 1.15', () {
      final spongeDef = ToolMotionDef.getDef('sponge');
      expect(spongeDef.squashScaleOnPress, 0.85);
      expect(spongeDef.stretchScaleOnRelease, 1.15);
      expect(spongeDef.tiltDegreesMax, 8.0);
    });

    test('2. ParticlePool capacity is strictly capped at 160 max particles', () {
      final pool = ParticlePool();
      expect(pool.capacity, 160);

      // Attempt spawning 200 particles
      pool.spawnBurst(const Offset(100, 100), ParticleType.soap, Colors.white, count: 200);

      expect(pool.activeParticles.length, lessThanOrEqualTo(160));
    });

    test('3. Pressure washer tool definition contains 4px recoil offset', () {
      final washerDef = ToolMotionDef.getDef('pressure_washer');
      expect(washerDef.recoilOffset, 4.0);
      expect(washerDef.tiltDegreesMax, 10.0);
    });
  });
}
