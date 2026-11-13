import 'package:flutter/material.dart';

class MotionTokens {
  // UI Press Animations
  static const Duration uiPressDownDuration = Duration(milliseconds: 90);
  static const double uiPressScale = 0.92;
  static const Duration uiPressSpringDuration = Duration(milliseconds: 160);

  // Panel Transitions
  static const Duration panelInDuration = Duration(milliseconds: 320);
  static const Curve panelInCurve = Curves.easeOutBack;
  static const Duration panelOutDuration = Duration(milliseconds: 200);
  static const Curve panelOutCurve = Curves.easeInCubic;

  // Banner & Phase Ribbons
  static const Duration ribbonInDuration = Duration(milliseconds: 380);
  static const Duration ribbonHoldDuration = Duration(milliseconds: 1200);
  static const Duration ribbonOutDuration = Duration(milliseconds: 260);

  // Camera Zoom & Spring Parameters
  static const Duration cameraZoomDuration = Duration(milliseconds: 450);
  static const double cameraZoomStiffness = 180.0;
  static const double cameraZoomDamping = 20.0;
  static const double cameraZoomMin = 1.0;
  static const double cameraZoomMax = 1.35;

  // Fix Confirmation Pop
  static const Duration fixConfirmationDuration = Duration(milliseconds: 280);
  static const double fixConfirmationScaleMax = 1.2;
  static const Curve fixConfirmationCurve = Curves.easeOutBack;

  // Coin Fly Animation
  static const Duration coinFlyDuration = Duration(milliseconds: 600);
  static const Curve coinFlyCurve = Curves.easeInOutCubic;
}
