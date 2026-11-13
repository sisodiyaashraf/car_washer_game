import 'package:flutter/material.dart';

class AppTypography {
  static const String displayFont = 'FredokaDisplay';
  static const String bodyFont = 'FredokaBody';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}
