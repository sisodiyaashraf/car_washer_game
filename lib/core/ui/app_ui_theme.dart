import 'package:flutter/material.dart';

class AppUITheme {
  // Theme Colors
  static const Color blueGradientStart = Color(0xFF5CC3FF);
  static const Color blueGradientEnd = Color(0xFF1E7FE0);
  static const Color whiteBorder = Colors.white;
  static const Color gold = Color(0xFFFFD93D);
  static const Color green = Color(0xFF4CAF50);
  static const Color red = Color(0xFFE53935);
  static const Color navyOutline = Color(0xFF1D2B3A);
  static const Color cardBg = Color(0xFF334155);

  // Linear Gradients
  static const LinearGradient blueButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blueGradientStart, blueGradientEnd],
  );

  static const LinearGradient goldButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFE082), gold],
  );

  static const LinearGradient disabledGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF9E9E9E), Color(0xFF616161)],
  );

  // Spacing & Radii
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 12.0;
  static const double spaceLG = 16.0;
  static const double spaceXL = 24.0;

  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusPill = 30.0;

  // Box Shadows
  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x591D2B3A),
      blurRadius: 6,
      offset: Offset(0, 4),
    )
  ];

  static const List<BoxShadow> panelShadow = [
    BoxShadow(
      color: Color(0x731D2B3A),
      blurRadius: 16,
      offset: Offset(0, 8),
    )
  ];
}
