import 'dart:math';
import 'package:flutter/material.dart';
import '../motion/motion_tokens.dart';

class CameraController extends ChangeNotifier {
  double _panX = 0.0;
  double get panX => _panX;

  double _zoom = MotionTokens.cameraZoomMin;
  double get zoom => _zoom;

  double _shakeAmplitude = 0.0;
  double get shakeAmplitude => _shakeAmplitude;

  double _shakeX = 0.0;
  double _shakeY = 0.0;

  double _targetZoom = MotionTokens.cameraZoomMin;
  double _targetPanX = 0.0;

  AnimationController? _zoomTicker;

  void focusOn(Offset normalizedPoint, double zoomTarget, {TickerProvider? vsync}) {
    _targetPanX = normalizedPoint.dx.clamp(-1.0, 1.0);
    _targetZoom = zoomTarget.clamp(MotionTokens.cameraZoomMin, MotionTokens.cameraZoomMax);

    if (vsync != null) {
      _zoomTicker?.dispose();
      _zoomTicker = AnimationController(
        vsync: vsync,
        duration: MotionTokens.cameraZoomDuration,
      );

      final startZoom = _zoom;
      final startPan = _panX;

      _zoomTicker!.addListener(() {
        final t = Curves.easeOutCubic.transform(_zoomTicker!.value);
        _zoom = startZoom + (_targetZoom - startZoom) * t;
        _panX = startPan + (_targetPanX - startPan) * t;
        notifyListeners();
      });

      _zoomTicker!.forward();
    } else {
      _zoom = _targetZoom;
      _panX = _targetPanX;
      notifyListeners();
    }
  }

  void reset({TickerProvider? vsync}) {
    focusOn(Offset.zero, MotionTokens.cameraZoomMin, vsync: vsync);
  }

  void shake(double strength) {
    _shakeAmplitude = strength.clamp(0.0, 20.0);
    _updateShakeOffset();
    notifyListeners();
  }

  void _updateShakeOffset() {
    if (_shakeAmplitude > 0.1) {
      final random = Random();
      _shakeX = (random.nextDouble() - 0.5) * 2 * _shakeAmplitude;
      _shakeY = (random.nextDouble() - 0.5) * 2 * _shakeAmplitude;
      _shakeAmplitude *= 0.85;
    } else {
      _shakeAmplitude = 0.0;
      _shakeX = 0.0;
      _shakeY = 0.0;
    }
  }

  void update(double dt) {
    if (_shakeAmplitude > 0.0) {
      _updateShakeOffset();
      notifyListeners();
    }
  }

  Matrix4 getStageTransform(double parallaxFactor, Size stageSize) {
    final center = Offset(stageSize.width / 2, stageSize.height / 2);
    final layerPanX = _panX * parallaxFactor * (stageSize.width * 0.3) + _shakeX;
    final layerPanY = _shakeY;

    return Matrix4.identity()
      ..setTranslationRaw(center.dx + layerPanX, center.dy + layerPanY, 0.0)
      ..scaleByDouble(_zoom, _zoom, 1.0, 1.0)
      ..translateByDouble(-center.dx, -center.dy, 0.0, 1.0);
  }

  @override
  void dispose() {
    _zoomTicker?.dispose();
    super.dispose();
  }
}
