import 'dart:math';
import 'package:flutter/material.dart';

enum MotionState { offscreenLeft, arriving, parked, leaving, offscreenRight }

class VehicleMotion extends ChangeNotifier {
  MotionState _state = MotionState.offscreenLeft;
  MotionState get state => _state;

  double _x = -1.3; // Normalized position (-1.3 to 1.3)
  double get x => _x;

  double _velocity = 0.0;
  double get velocity => _velocity;

  double _wheelAngle = 0.0; // Radians
  double get wheelAngle => _wheelAngle;

  double _bodyPitch = 0.0; // Radians (max 2.5 degrees = ~0.0436 rad)
  double get bodyPitch => _bodyPitch;

  double _bodyBounce = 0.0; // Vertical bounce offset
  double get bodyBounce => _bodyBounce;

  double _engineVibration = 0.0; // 6 Hz, 0.6 px idle vibration when parked
  double get engineVibration => _engineVibration;

  double _trackScroll = 0.0; // Tread scroll offset for tracked vehicles
  double get trackScroll => _trackScroll;

  double _propellerBlur = 0.0; // Propeller blur rotation for planes
  double get propellerBlur => _propellerBlur;

  bool _isInputLocked = true;
  bool get isInputLocked => _isInputLocked;

  bool _isHeadlightOn = false;
  bool get isHeadlightOn => _isHeadlightOn;

  bool _isTaillightGlow = false;
  bool get isTaillightGlow => _isTaillightGlow;

  bool _isSpeedlineVisible = false;
  bool get isSpeedlineVisible => _isSpeedlineVisible;

  bool _isDustActive = false;
  bool get isDustActive => _isDustActive;

  bool _isHonking = false;
  bool get isHonking => _isHonking;

  bool _isGarageDoorClosed = false;
  bool get isGarageDoorClosed => _isGarageDoorClosed;

  AnimationController? _motionTicker;
  AnimationController? _idleTicker;

  void startDriveIn({
    required TickerProvider vsync,
    double wheelRadius = 0.0733,
    double weight = 1.0,
    bool isHeavy = false,
    bool reducedMotion = false,
    VoidCallback? onComplete,
  }) {
    _motionTicker?.dispose();
    _idleTicker?.dispose();
    _state = MotionState.arriving;
    _isInputLocked = true;
    _isHeadlightOn = !reducedMotion;
    _isSpeedlineVisible = !reducedMotion;
    _isDustActive = !reducedMotion;
    _isGarageDoorClosed = true;

    if (reducedMotion) {
      _x = 0.0;
      _velocity = 0.0;
      _state = MotionState.parked;
      _isInputLocked = false;
      _isHeadlightOn = false;
      _isSpeedlineVisible = false;
      _isDustActive = false;
      _isGarageDoorClosed = false;
      _startParkedIdle(vsync);
      notifyListeners();
      onComplete?.call();
      return;
    }

    final durationMs = (isHeavy ? 1900 : 1400 * weight).round();
    _motionTicker = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: durationMs),
    );

    _motionTicker!.addListener(() {
      final progress = _motionTicker!.value;

      // Ease-out arrival
      final newX = -1.3 + (1.3 * Curves.easeOutCubic.transform(progress));
      final deltaX = newX - _x;
      _x = newX;
      _velocity = deltaX * 60;

      // Rolling spin math: angle = distance / radius
      _wheelAngle += deltaX / wheelRadius;
      _trackScroll += deltaX * 10;
      _propellerBlur += deltaX * 20;

      // Suspension bounce & braking nose dip (max 2.5 deg = ~0.0436 rad)
      _bodyPitch = ((1.0 - progress) * -0.035).clamp(-0.0436, 0.0436);
      _bodyBounce = sin(progress * pi * 8) * 3.0 * (1.0 - progress);

      if (progress >= 0.8) {
        _isTaillightGlow = true;
        _isSpeedlineVisible = false;
      }

      if (progress >= 1.0) {
        _state = MotionState.parked;
        _x = 0.0;
        _velocity = 0.0;
        _bodyPitch = 0.0;
        _bodyBounce = 0.0;
        _isInputLocked = false;
        _isHeadlightOn = false;
        _isTaillightGlow = false;
        _isDustActive = false;
        _isGarageDoorClosed = false;
        _startParkedIdle(vsync);
        onComplete?.call();
      }

      notifyListeners();
    });

    _motionTicker!.forward();
  }

  void _startParkedIdle(TickerProvider vsync) {
    _idleTicker?.dispose();
    _idleTicker = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _idleTicker!.addListener(() {
      if (_state == MotionState.parked) {
        // 6 Hz idle engine vibration (0.6 px amplitude)
        _engineVibration = sin(_idleTicker!.value * pi * 12) * 0.6;
        _propellerBlur += 0.1;
        notifyListeners();
      }
    });
  }

  void startDriveOut({
    required TickerProvider vsync,
    double wheelRadius = 0.0733,
    double weight = 1.0,
    bool reducedMotion = false,
    VoidCallback? onComplete,
  }) {
    _motionTicker?.dispose();
    _idleTicker?.dispose();
    _state = MotionState.leaving;
    _isInputLocked = true;
    _isSpeedlineVisible = !reducedMotion;
    _isDustActive = !reducedMotion;

    if (reducedMotion) {
      _x = 1.3;
      _velocity = 0.0;
      _state = MotionState.offscreenRight;
      _isInputLocked = false;
      notifyListeners();
      onComplete?.call();
      return;
    }

    final durationMs = (1100 * weight).round();
    _motionTicker = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: durationMs),
    );

    _motionTicker!.addListener(() {
      final progress = _motionTicker!.value;

      // Ease-in acceleration
      final newX = 1.3 * Curves.easeInCubic.transform(progress);
      final deltaX = newX - _x;
      _x = newX;
      _velocity = deltaX * 60;

      _wheelAngle += deltaX / wheelRadius;
      _trackScroll += deltaX * 10;
      _propellerBlur += deltaX * 25;

      // Acceleration squat (rear squats 5px for anticipation)
      _bodyPitch = (progress * 0.0436).clamp(-0.0436, 0.0436);
      _bodyBounce = sin(progress * pi * 6) * 2.0;

      if (progress >= 1.0) {
        _state = MotionState.offscreenRight;
        _velocity = 0.0;
        _bodyPitch = 0.0;
        _bodyBounce = 0.0;
        _isSpeedlineVisible = false;
        _isDustActive = false;
        onComplete?.call();
      }

      notifyListeners();
    });

    _motionTicker!.forward();
  }

  void skipAnimation() {
    if (_motionTicker != null && _motionTicker!.isAnimating) {
      _motionTicker!.stop();
      if (_state == MotionState.arriving) {
        _x = 0.0;
        _velocity = 0.0;
        _state = MotionState.parked;
        _isInputLocked = false;
        _isHeadlightOn = false;
        _isSpeedlineVisible = false;
        _isDustActive = false;
        _isGarageDoorClosed = false;
      } else if (_state == MotionState.leaving) {
        _x = 1.3;
        _velocity = 0.0;
        _state = MotionState.offscreenRight;
      }
      notifyListeners();
    }
  }

  void resetToParked() {
    _state = MotionState.parked;
    _x = 0.0;
    _velocity = 0.0;
    _wheelAngle = 0.0;
    _bodyPitch = 0.0;
    _bodyBounce = 0.0;
    _engineVibration = 0.0;
    _trackScroll = 0.0;
    _propellerBlur = 0.0;
    _isInputLocked = false;
    _isHeadlightOn = false;
    _isTaillightGlow = false;
    _isSpeedlineVisible = false;
    _isDustActive = false;
    _isHonking = false;
    _isGarageDoorClosed = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _motionTicker?.dispose();
    _idleTicker?.dispose();
    super.dispose();
  }
}
