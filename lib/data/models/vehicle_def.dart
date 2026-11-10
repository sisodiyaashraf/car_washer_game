import 'package:flutter/material.dart';

enum RepairSpotType {
  dent,
  flatTire,
  brokenLight,
  scratch,
  engine,
}

class RepairSpotDef {
  final String id;
  final Offset relativePosition; // (0.0 - 1.0) relative to vehicle bounding box
  final RepairSpotType spotType;
  final int hitsNeeded;
  final String label;

  const RepairSpotDef({
    required this.id,
    required this.relativePosition,
    required this.spotType,
    this.hitsNeeded = 1,
    required this.label,
  });
}

class PaintZoneDef {
  final String id;
  final String name;
  final Rect relativeBounds; // (0.0 - 1.0) relative bounding box

  const PaintZoneDef({
    required this.id,
    required this.name,
    required this.relativeBounds,
  });
}

class VehicleDef {
  final String id;
  final String name;
  final String? assetPath;
  final int unlockCost;
  final bool isUnlockedByDefault;
  final Color baseColor;
  final List<RepairSpotDef> repairSpots;
  final List<PaintZoneDef> paintZones;
  final String description;

  const VehicleDef({
    required this.id,
    required this.name,
    this.assetPath,
    this.unlockCost = 0,
    this.isUnlockedByDefault = false,
    required this.baseColor,
    required this.repairSpots,
    required this.paintZones,
    required this.description,
  });
}
