import 'package:flutter/material.dart';

class ToolMotionDef {
  final String toolId;
  final Offset pivotOffset;
  final Offset handOffset;
  final double tiltDegreesMax; // 6 to 12 degrees
  final double idleSwayFreq; // 2 Hz
  final double idleSwayAmp; // 1 px
  final double squashScaleOnPress; // 0.85
  final double stretchScaleOnRelease; // 1.15
  final double recoilOffset; // 4 px for pressure washer

  const ToolMotionDef({
    required this.toolId,
    this.pivotOffset = const Offset(0.5, 0.5),
    this.handOffset = const Offset(0.0, 30.0),
    this.tiltDegreesMax = 10.0,
    this.idleSwayFreq = 2.0,
    this.idleSwayAmp = 1.0,
    this.squashScaleOnPress = 0.85,
    this.stretchScaleOnRelease = 1.15,
    this.recoilOffset = 0.0,
  });

  static const Map<String, ToolMotionDef> defs = {
    'sponge': ToolMotionDef(
      toolId: 'sponge',
      pivotOffset: Offset(0.5, 0.5),
      tiltDegreesMax: 8.0,
      squashScaleOnPress: 0.85,
      stretchScaleOnRelease: 1.15,
    ),
    'spray_hose': ToolMotionDef(
      toolId: 'spray_hose',
      pivotOffset: Offset(0.3, 0.7),
      tiltDegreesMax: 12.0,
      recoilOffset: 2.0,
    ),
    'pressure_washer': ToolMotionDef(
      toolId: 'pressure_washer',
      pivotOffset: Offset(0.2, 0.8),
      tiltDegreesMax: 10.0,
      recoilOffset: 4.0,
    ),
    'wheel_brush': ToolMotionDef(
      toolId: 'wheel_brush',
      pivotOffset: Offset(0.5, 0.8),
      tiltDegreesMax: 10.0,
      squashScaleOnPress: 0.90,
    ),
    'foam_cannon': ToolMotionDef(
      toolId: 'foam_cannon',
      pivotOffset: Offset(0.2, 0.8),
      tiltDegreesMax: 12.0,
      recoilOffset: 3.0,
    ),
    'squeegee': ToolMotionDef(
      toolId: 'squeegee',
      pivotOffset: Offset(0.5, 0.9),
      tiltDegreesMax: 6.0,
    ),
    'dryer': ToolMotionDef(
      toolId: 'dryer',
      pivotOffset: Offset(0.3, 0.7),
      tiltDegreesMax: 10.0,
    ),
    'polisher': ToolMotionDef(
      toolId: 'polisher',
      pivotOffset: Offset(0.5, 0.5),
      tiltDegreesMax: 6.0,
      squashScaleOnPress: 0.88,
    ),
  };

  static ToolMotionDef getDef(String toolId) {
    return defs[toolId] ?? defs['sponge']!;
  }
}
