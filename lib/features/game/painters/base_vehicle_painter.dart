import 'dart:math';
import 'package:flutter/material.dart';
import '../../../data/models/customization_def.dart';

abstract class BaseVehiclePainter extends CustomPainter {
  final Color bodyColor;
  final Map<String, bool>? damagedSpots; // spotId -> isRepaired
  final RimStyle rimStyle;
  final DecalType decalType;
  final Offset decalOffset;
  final double decalScale;
  final bool isCleanShine;

  const BaseVehiclePainter({
    required this.bodyColor,
    this.damagedSpots,
    this.rimStyle = RimStyle.classic,
    this.decalType = DecalType.none,
    this.decalOffset = const Offset(0.5, 0.45),
    this.decalScale = 1.0,
    this.isCleanShine = false,
  });

  @override
  bool shouldRepaint(covariant BaseVehiclePainter oldDelegate) {
    return oldDelegate.bodyColor != bodyColor ||
        oldDelegate.damagedSpots != damagedSpots ||
        oldDelegate.rimStyle != rimStyle ||
        oldDelegate.decalType != decalType ||
        oldDelegate.decalOffset != decalOffset ||
        oldDelegate.decalScale != decalScale ||
        oldDelegate.isCleanShine != isCleanShine;
  }
}

/// Helper function to draw custom styled wheel
void drawWheel(Canvas canvas, Offset center, double radius, {RimStyle style = RimStyle.classic}) {
  final tirePaint = Paint()
    ..color = const Color(0xFF2B2B2B)
    ..style = PaintingStyle.fill;

  final rimPaint = Paint()
    ..color = const Color(0xFFE0E0E0)
    ..style = PaintingStyle.fill;

  final outlinePaint = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  canvas.drawCircle(center, radius, tirePaint);
  canvas.drawCircle(center, radius, outlinePaint);
  canvas.drawCircle(center, radius * 0.65, rimPaint);
  canvas.drawCircle(center, radius * 0.65, outlinePaint);

  final hubPaint = Paint()..color = const Color(0xFF616161);

  switch (style) {
    case RimStyle.sportSpoke:
      final spokePaint = Paint()
        ..color = const Color(0xFF424242)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;
      for (int i = 0; i < 5; i++) {
        final angle = (i * 72) * pi / 180;
        final start = center;
        final end = Offset(center.dx + radius * 0.6 * cos(angle), center.dy + radius * 0.6 * sin(angle));
        canvas.drawLine(start, end, spokePaint);
      }
      canvas.drawCircle(center, radius * 0.25, hubPaint);
      break;

    case RimStyle.offroadBeadlock:
      final beadlockPaint = Paint()..color = const Color(0xFFFFB703);
      canvas.drawCircle(center, radius * 0.62, Paint()..color = Colors.black);
      for (int i = 0; i < 8; i++) {
        final angle = (i * 45) * pi / 180;
        final boltPos = Offset(center.dx + radius * 0.55 * cos(angle), center.dy + radius * 0.55 * sin(angle));
        canvas.drawCircle(boltPos, 2.0, beadlockPaint);
      }
      canvas.drawCircle(center, radius * 0.3, hubPaint);
      break;

    case RimStyle.starAlloy:
      final starPath = Path();
      for (int i = 0; i < 5; i++) {
        final angle = (i * 72 - 90) * pi / 180;
        final outer = Offset(center.dx + radius * 0.6 * cos(angle), center.dy + radius * 0.6 * sin(angle));
        final innerAngle = ((i * 72 + 36) - 90) * pi / 180;
        final inner = Offset(center.dx + radius * 0.25 * cos(innerAngle), center.dy + radius * 0.25 * sin(innerAngle));
        if (i == 0) {
          starPath.moveTo(outer.dx, outer.dy);
        } else {
          starPath.lineTo(outer.dx, outer.dy);
        }
        starPath.lineTo(inner.dx, inner.dy);
      }
      starPath.close();
      canvas.drawPath(starPath, Paint()..color = const Color(0xFFB0BEC5));
      canvas.drawCircle(center, radius * 0.2, hubPaint);
      break;

    case RimStyle.classic:
      canvas.drawCircle(center, radius * 0.25, hubPaint);
      break;
  }
}

/// Helper function to draw Decal on vehicle body
void drawDecal(Canvas canvas, Size size, DecalType type, Offset relativeOffset, double scale) {
  if (type == DecalType.none) return;

  final center = Offset(size.width * relativeOffset.dx, size.height * relativeOffset.dy);
  final decalWidth = size.width * 0.3 * scale;
  final decalHeight = size.height * 0.2 * scale;

  canvas.save();
  canvas.translate(center.dx, center.dy);

  final decalPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  switch (type) {
    case DecalType.stripes:
      canvas.drawRect(Rect.fromLTWH(-decalWidth * 0.4, -decalHeight * 0.6, decalWidth * 0.25, decalHeight * 1.2), decalPaint);
      canvas.drawRect(Rect.fromLTWH(-decalWidth * 0.05, -decalHeight * 0.6, decalWidth * 0.25, decalHeight * 1.2), decalPaint);
      break;

    case DecalType.flames:
      final flamePath = Path();
      flamePath.moveTo(-decalWidth * 0.4, 0);
      flamePath.quadraticBezierTo(-decalWidth * 0.1, -decalHeight * 0.4, decalWidth * 0.3, -decalHeight * 0.2);
      flamePath.quadraticBezierTo(0, 0, decalWidth * 0.4, decalHeight * 0.3);
      flamePath.quadraticBezierTo(-decalWidth * 0.2, decalHeight * 0.1, -decalWidth * 0.4, 0);
      flamePath.close();
      canvas.drawPath(flamePath, Paint()..color = const Color(0xFFFF5722));
      break;

    case DecalType.racingNumber:
      canvas.drawCircle(Offset.zero, decalWidth * 0.3, Paint()..color = Colors.white);
      canvas.drawCircle(Offset.zero, decalWidth * 0.3, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2);
      final textPainter = TextPainter(
        text: const TextSpan(
          text: '07',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      break;

    case DecalType.stars:
      for (int i = 0; i < 3; i++) {
        final offsetX = (i - 1) * decalWidth * 0.3;
        canvas.drawCircle(Offset(offsetX, 0), 8 * scale, Paint()..color = const Color(0xFFFFD54F));
      }
      break;

    case DecalType.camo:
      final camoPaint = Paint()..color = const Color(0xFF388E3C).withValues(alpha: 0.7);
      canvas.drawOval(Rect.fromLTWH(-decalWidth * 0.3, -decalHeight * 0.3, decalWidth * 0.4, decalHeight * 0.4), camoPaint);
      canvas.drawOval(Rect.fromLTWH(0, -decalHeight * 0.2, decalWidth * 0.4, decalHeight * 0.5), Paint()..color = const Color(0xFF1B5E20));
      break;

    case DecalType.checker:
      final gridPaint = Paint()..color = Colors.black87;
      final sizeBox = 8.0 * scale;
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 4; c++) {
          if ((r + c) % 2 == 0) {
            canvas.drawRect(Rect.fromLTWH(-decalWidth * 0.4 + c * sizeBox, -decalHeight * 0.3 + r * sizeBox, sizeBox, sizeBox), gridPaint);
          }
        }
      }
      break;

    default:
      break;
  }

  canvas.restore();
}

/// Helper function to draw wet shine highlights
void drawWetShine(Canvas canvas, Size size) {
  final shinePaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.35)
    ..style = PaintingStyle.fill;

  final path = Path();
  path.moveTo(size.width * 0.2, size.height * 0.2);
  path.lineTo(size.width * 0.35, size.height * 0.2);
  path.lineTo(size.width * 0.15, size.height * 0.7);
  path.lineTo(size.width * 0.1, size.height * 0.7);
  path.close();

  canvas.drawPath(path, shinePaint);
}
