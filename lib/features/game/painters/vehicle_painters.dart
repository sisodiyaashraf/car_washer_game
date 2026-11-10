import 'dart:math';
import 'package:flutter/material.dart';
import 'base_vehicle_painter.dart';

export 'base_vehicle_painter.dart';

/// 1. Hatchback Painter
class HatchbackPainter extends BaseVehiclePainter {
  const HatchbackPainter({
    required super.bodyColor,
    super.damagedSpots,
    super.rimStyle,
    super.decalType,
    super.decalOffset,
    super.decalScale,
    super.isCleanShine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = bodyColor;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final windowPaint = Paint()..color = const Color(0xFF81D4FA);

    final path = Path();
    path.moveTo(w * 0.1, h * 0.7);
    path.lineTo(w * 0.1, h * 0.5);
    path.quadraticBezierTo(w * 0.15, h * 0.45, w * 0.25, h * 0.45);
    path.quadraticBezierTo(w * 0.35, h * 0.2, w * 0.5, h * 0.2);
    path.lineTo(w * 0.7, h * 0.2);
    path.quadraticBezierTo(w * 0.8, h * 0.25, w * 0.85, h * 0.45);
    path.lineTo(w * 0.9, h * 0.5);
    path.quadraticBezierTo(w * 0.95, h * 0.55, w * 0.95, h * 0.7);
    path.lineTo(w * 0.1, h * 0.7);
    path.close();

    canvas.drawPath(path, bodyPaint);
    drawDecal(canvas, size, decalType, decalOffset, decalScale);
    canvas.drawPath(path, outlinePaint);

    final windowPath = Path();
    windowPath.moveTo(w * 0.3, h * 0.43);
    windowPath.lineTo(w * 0.38, h * 0.25);
    windowPath.lineTo(w * 0.52, h * 0.25);
    windowPath.lineTo(w * 0.52, h * 0.43);
    windowPath.close();

    windowPath.moveTo(w * 0.55, h * 0.43);
    windowPath.lineTo(w * 0.55, h * 0.25);
    windowPath.lineTo(w * 0.68, h * 0.25);
    windowPath.lineTo(w * 0.78, h * 0.43);
    windowPath.close();

    canvas.drawPath(windowPath, windowPaint);
    canvas.drawPath(windowPath, outlinePaint);

    if (isCleanShine) drawWetShine(canvas, size);

    final headlightPaint = Paint()
      ..color = (damagedSpots?['light_front'] == false) ? Colors.grey : const Color(0xFFFFD54F);
    canvas.drawCircle(Offset(w * 0.92, h * 0.56), h * 0.05, headlightPaint);

    final wheelRadius = min(w, h) * 0.14;
    drawWheel(canvas, Offset(w * 0.3, h * 0.72), wheelRadius, style: rimStyle);
    drawWheel(canvas, Offset(w * 0.75, h * 0.72), wheelRadius, style: rimStyle);
  }
}

/// 2. Sports Car Painter
class SportsCarPainter extends BaseVehiclePainter {
  const SportsCarPainter({
    required super.bodyColor,
    super.damagedSpots,
    super.rimStyle,
    super.decalType,
    super.decalOffset,
    super.decalScale,
    super.isCleanShine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = bodyColor;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final windowPaint = Paint()..color = const Color(0xFF4FC3F7);

    final path = Path();
    path.moveTo(w * 0.05, h * 0.65);
    path.lineTo(w * 0.08, h * 0.42);
    path.lineTo(w * 0.15, h * 0.42);
    path.lineTo(w * 0.22, h * 0.52);
    path.quadraticBezierTo(w * 0.35, h * 0.22, w * 0.55, h * 0.22);
    path.lineTo(w * 0.7, h * 0.38);
    path.lineTo(w * 0.92, h * 0.48);
    path.quadraticBezierTo(w * 0.98, h * 0.52, w * 0.95, h * 0.65);
    path.close();

    canvas.drawPath(path, bodyPaint);
    drawDecal(canvas, size, decalType, decalOffset, decalScale);
    canvas.drawPath(path, outlinePaint);

    final windowPath = Path();
    windowPath.moveTo(w * 0.38, h * 0.48);
    windowPath.lineTo(w * 0.45, h * 0.26);
    windowPath.lineTo(w * 0.58, h * 0.26);
    windowPath.lineTo(w * 0.66, h * 0.42);
    windowPath.close();
    canvas.drawPath(windowPath, windowPaint);
    canvas.drawPath(windowPath, outlinePaint);

    if (isCleanShine) drawWetShine(canvas, size);

    final headlightPaint = Paint()
      ..color = (damagedSpots?['light_front'] == false) ? Colors.grey : const Color(0xFFFFF59D);
    canvas.drawOval(Rect.fromLTWH(w * 0.88, h * 0.48, w * 0.06, h * 0.07), headlightPaint);

    final wheelRadius = min(w, h) * 0.15;
    drawWheel(canvas, Offset(w * 0.25, h * 0.66), wheelRadius, style: rimStyle);
    drawWheel(canvas, Offset(w * 0.78, h * 0.66), wheelRadius, style: rimStyle);
  }
}

/// 3. Pickup Truck Painter
class PickupTruckPainter extends BaseVehiclePainter {
  const PickupTruckPainter({
    required super.bodyColor,
    super.damagedSpots,
    super.rimStyle,
    super.decalType,
    super.decalOffset,
    super.decalScale,
    super.isCleanShine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = bodyColor;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final windowPaint = Paint()..color = const Color(0xFF81D4FA);

    final path = Path();
    path.moveTo(w * 0.08, h * 0.7);
    path.lineTo(w * 0.08, h * 0.45);
    path.lineTo(w * 0.42, h * 0.45);
    path.lineTo(w * 0.44, h * 0.22);
    path.lineTo(w * 0.65, h * 0.22);
    path.lineTo(w * 0.78, h * 0.45);
    path.lineTo(w * 0.92, h * 0.48);
    path.lineTo(w * 0.95, h * 0.7);
    path.close();

    canvas.drawPath(path, bodyPaint);
    drawDecal(canvas, size, decalType, decalOffset, decalScale);
    canvas.drawPath(path, outlinePaint);

    final windowPath = Path();
    windowPath.moveTo(w * 0.48, h * 0.42);
    windowPath.lineTo(w * 0.48, h * 0.26);
    windowPath.lineTo(w * 0.63, h * 0.26);
    windowPath.lineTo(w * 0.73, h * 0.42);
    windowPath.close();
    canvas.drawPath(windowPath, windowPaint);
    canvas.drawPath(windowPath, outlinePaint);

    if (isCleanShine) drawWetShine(canvas, size);

    final wheelRadius = min(w, h) * 0.16;
    drawWheel(canvas, Offset(w * 0.24, h * 0.7), wheelRadius, style: rimStyle);
    drawWheel(canvas, Offset(w * 0.76, h * 0.7), wheelRadius, style: rimStyle);
  }
}

/// 4. Police Car Painter
class PoliceCarPainter extends BaseVehiclePainter {
  const PoliceCarPainter({
    required super.bodyColor,
    super.damagedSpots,
    super.rimStyle,
    super.decalType,
    super.decalOffset,
    super.decalScale,
    super.isCleanShine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = bodyColor;
    final whitePaint = Paint()..color = Colors.white;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final windowPaint = Paint()..color = const Color(0xFFB3E5FC);

    final path = Path();
    path.moveTo(w * 0.08, h * 0.68);
    path.lineTo(w * 0.08, h * 0.48);
    path.quadraticBezierTo(w * 0.15, h * 0.44, w * 0.28, h * 0.44);
    path.quadraticBezierTo(w * 0.38, h * 0.22, w * 0.52, h * 0.22);
    path.lineTo(w * 0.7, h * 0.22);
    path.quadraticBezierTo(w * 0.8, h * 0.28, w * 0.85, h * 0.44);
    path.lineTo(w * 0.92, h * 0.48);
    path.quadraticBezierTo(w * 0.96, h * 0.52, w * 0.95, h * 0.68);
    path.close();

    canvas.drawPath(path, bodyPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.38, h * 0.42, w * 0.32, h * 0.24), whitePaint);
    drawDecal(canvas, size, decalType, decalOffset, decalScale);
    canvas.drawPath(path, outlinePaint);

    final windowPath = Path();
    windowPath.moveTo(w * 0.32, h * 0.41);
    windowPath.lineTo(w * 0.40, h * 0.25);
    windowPath.lineTo(w * 0.52, h * 0.25);
    windowPath.lineTo(w * 0.52, h * 0.41);
    windowPath.close();

    windowPath.moveTo(w * 0.55, h * 0.41);
    windowPath.lineTo(w * 0.55, h * 0.25);
    windowPath.lineTo(w * 0.67, h * 0.25);
    windowPath.lineTo(w * 0.76, h * 0.41);
    windowPath.close();

    canvas.drawPath(windowPath, windowPaint);
    canvas.drawPath(windowPath, outlinePaint);

    if (isCleanShine) drawWetShine(canvas, size);

    final wheelRadius = min(w, h) * 0.14;
    drawWheel(canvas, Offset(w * 0.28, h * 0.68), wheelRadius, style: rimStyle);
    drawWheel(canvas, Offset(w * 0.76, h * 0.68), wheelRadius, style: rimStyle);
  }
}

/// 5. Monster Truck Painter
class MonsterTruckPainter extends BaseVehiclePainter {
  const MonsterTruckPainter({
    required super.bodyColor,
    super.damagedSpots,
    super.rimStyle,
    super.decalType,
    super.decalOffset,
    super.decalScale,
    super.isCleanShine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = bodyColor;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final windowPaint = Paint()..color = const Color(0xFF80DEEA);

    final path = Path();
    path.moveTo(w * 0.15, h * 0.52);
    path.lineTo(w * 0.15, h * 0.35);
    path.lineTo(w * 0.38, h * 0.35);
    path.lineTo(w * 0.42, h * 0.16);
    path.lineTo(w * 0.68, h * 0.16);
    path.lineTo(w * 0.82, h * 0.35);
    path.lineTo(w * 0.92, h * 0.38);
    path.lineTo(w * 0.92, h * 0.52);
    path.close();

    canvas.drawPath(path, bodyPaint);
    drawDecal(canvas, size, decalType, decalOffset, decalScale);
    canvas.drawPath(path, outlinePaint);

    final windowPath = Path();
    windowPath.moveTo(w * 0.45, h * 0.32);
    windowPath.lineTo(w * 0.45, h * 0.2);
    windowPath.lineTo(w * 0.65, h * 0.2);
    windowPath.lineTo(w * 0.75, h * 0.32);
    windowPath.close();
    canvas.drawPath(windowPath, windowPaint);
    canvas.drawPath(windowPath, outlinePaint);

    if (isCleanShine) drawWetShine(canvas, size);

    final monsterWheelRadius = min(w, h) * 0.22;
    drawWheel(canvas, Offset(w * 0.28, h * 0.70), monsterWheelRadius, style: rimStyle);
    drawWheel(canvas, Offset(w * 0.74, h * 0.70), monsterWheelRadius, style: rimStyle);
  }
}

/// 6. Plane Painter
class PlanePainter extends BaseVehiclePainter {
  const PlanePainter({
    required super.bodyColor,
    super.damagedSpots,
    super.rimStyle,
    super.decalType,
    super.decalOffset,
    super.decalScale,
    super.isCleanShine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = bodyColor;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final windowPaint = Paint()..color = const Color(0xFFB2EBF2);

    final path = Path();
    path.moveTo(w * 0.1, h * 0.45);
    path.lineTo(w * 0.15, h * 0.25);
    path.lineTo(w * 0.25, h * 0.4);
    path.lineTo(w * 0.85, h * 0.4);
    path.quadraticBezierTo(w * 0.95, h * 0.45, w * 0.95, h * 0.55);
    path.lineTo(w * 0.25, h * 0.6);
    path.close();

    canvas.drawPath(path, bodyPaint);
    drawDecal(canvas, size, decalType, decalOffset, decalScale);
    canvas.drawPath(path, outlinePaint);

    final wingPaint = Paint()..color = bodyColor.withValues(alpha: 0.9);
    final wingPath = Path();
    wingPath.moveTo(w * 0.45, h * 0.4);
    wingPath.lineTo(w * 0.4, h * 0.15);
    wingPath.lineTo(w * 0.6, h * 0.15);
    wingPath.lineTo(w * 0.6, h * 0.4);
    wingPath.close();

    wingPath.moveTo(w * 0.45, h * 0.6);
    wingPath.lineTo(w * 0.4, h * 0.85);
    wingPath.lineTo(w * 0.6, h * 0.85);
    wingPath.lineTo(w * 0.6, h * 0.6);
    wingPath.close();

    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, outlinePaint);

    final cockpitPath = Path();
    cockpitPath.moveTo(w * 0.65, h * 0.42);
    cockpitPath.lineTo(w * 0.72, h * 0.35);
    cockpitPath.lineTo(w * 0.82, h * 0.42);
    cockpitPath.close();
    canvas.drawPath(cockpitPath, windowPaint);
    canvas.drawPath(cockpitPath, outlinePaint);

    if (isCleanShine) drawWetShine(canvas, size);

    final wheelRadius = min(w, h) * 0.08;
    drawWheel(canvas, Offset(w * 0.52, h * 0.78), wheelRadius, style: rimStyle);
    drawWheel(canvas, Offset(w * 0.2, h * 0.66), wheelRadius * 0.7, style: rimStyle);
  }
}
