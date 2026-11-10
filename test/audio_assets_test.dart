import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All SFX sound names used in AudioService have existing asset files', () {
    for (final entry in AudioService.sfxAssets.entries) {
      final file = File(entry.value);
      expect(file.existsSync(), isTrue, reason: 'Missing audio asset file: ${entry.value}');
    }
  });

  test('Music loop tracks exist in assets/audio', () {
    final menuTrack = File('assets/audio/menu_loop.wav');
    final gameTrack = File('assets/audio/game_loop.wav');
    expect(menuTrack.existsSync(), isTrue);
    expect(gameTrack.existsSync(), isTrue);
  });
}
