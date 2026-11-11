import 'package:flutter/material.dart';

enum DecalType {
  none,
  stripes,
  flames,
  racingNumber,
  stars,
  camo,
  checker,
}

enum RimStyle {
  classic,
  sportSpoke,
  offroadBeadlock,
  starAlloy,
}

class DecalDef {
  final String id;
  final String name;
  final DecalType type;
  final IconData icon;

  const DecalDef({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });
}

class RimStyleDef {
  final String id;
  final String name;
  final RimStyle style;
  final IconData icon;

  const RimStyleDef({
    required this.id,
    required this.name,
    required this.style,
    required this.icon,
  });
}

class VehicleCustomization {
  final String vehicleId;
  final Color paintColor;
  final String paintColorName;
  final DecalType decalType;
  final Offset decalOffset;
  final double decalScale;
  final RimStyle rimStyle;

  const VehicleCustomization({
    required this.vehicleId,
    required this.paintColor,
    this.paintColorName = 'blue',
    this.decalType = DecalType.none,
    this.decalOffset = const Offset(0.5, 0.45),
    this.decalScale = 1.0,
    this.rimStyle = RimStyle.classic,
  });

  VehicleCustomization copyWith({
    Color? paintColor,
    String? paintColorName,
    DecalType? decalType,
    Offset? decalOffset,
    double? decalScale,
    RimStyle? rimStyle,
  }) {
    return VehicleCustomization(
      vehicleId: vehicleId,
      paintColor: paintColor ?? this.paintColor,
      paintColorName: paintColorName ?? this.paintColorName,
      decalType: decalType ?? this.decalType,
      decalOffset: decalOffset ?? this.decalOffset,
      decalScale: decalScale ?? this.decalScale,
      rimStyle: rimStyle ?? this.rimStyle,
    );
  }
}
