import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

enum BgmTrack { none, menu, gameplay }

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  BgmTrack _currentBgmTrack = BgmTrack.none;

  BgmTrack get currentBgmTrack => _currentBgmTrack;
  bool get isSoundOn => StorageService().isSoundEnabled;
  bool get isMusicOn => StorageService().isMusicEnabled;
  bool get _isTesting => !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  static const Map<String, String> sfxAssets = {
    'scrub': 'assets/audio/scrub.wav',
    'spray': 'assets/audio/spray.wav',
    'bubble_pop': 'assets/audio/bubble_pop.wav',
    'hammer_hit': 'assets/audio/hammer_hit.wav',
    'air_pump': 'assets/audio/air_pump.wav',
    'bulb_click': 'assets/audio/bulb_click.wav',
    'part_snap': 'assets/audio/part_snap.wav',
    'wrong_buzz': 'assets/audio/wrong_buzz.wav',
    'coin': 'assets/audio/coin.wav',
    'level_complete': 'assets/audio/level_complete.wav',
    'button_tap': 'assets/audio/button_tap.wav',
  };

  Future<void> initAudioContext() async {
    if (_isTesting) return;
    try {
      AudioPlayer.global.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            usageType: AndroidUsageType.game,
            contentType: AndroidContentType.sonification,
          ),
        ),
      );
    } catch (_) {}
  }

  void playSfx(String name) async {
    if (!isSoundOn || _isTesting || !sfxAssets.containsKey(name)) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(sfxAssets[name]!.replaceFirst('assets/', '')));
    } catch (_) {}
  }

  void stopSfx() async {
    if (_isTesting) return;
    try {
      await _sfxPlayer.stop();
    } catch (_) {}
  }

  void playScrubSound() => playSfx('scrub');
  void playSpraySound() => playSfx('spray');
  void playBubblePop() => playSfx('bubble_pop');
  void playHammerHit() => playSfx('hammer_hit');
  void playAirPump() => playSfx('air_pump');
  void playBulbClick() => playSfx('bulb_click');
  void playPartSnap() => playSfx('part_snap');
  void playWrongPartBuzz() => playSfx('wrong_buzz');
  void playCoinSound() => playSfx('coin');
  void playLevelCompleteSound() => playSfx('level_complete');
  void playButtonClick() => playSfx('button_tap');

  void switchBgm(BgmTrack track) async {
    if (_currentBgmTrack == track) return;
    _currentBgmTrack = track;
    if (!isMusicOn || _isTesting || track == BgmTrack.none) return;
    try {
      await _bgmPlayer.stop();
      final assetPath = track == BgmTrack.menu ? 'audio/menu_loop.wav' : 'audio/game_loop.wav';
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  void stopBgm() async {
    _currentBgmTrack = BgmTrack.none;
    if (_isTesting) return;
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }
}
