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

class MotionProfile {
  final String engineType; // small, truck, bus, plane
  final double weight; // arrival time & bounce amplitude multiplier
  final List<double> wheelRadii;
  final Offset exhaustPos;
  final Color smokeColor;
  final String honkType; // car, truck, plane
  final String vehicleType; // car, tracked, plane, helicopter

  const MotionProfile({
    this.engineType = 'small',
    this.weight = 1.0,
    required this.wheelRadii,
    this.exhaustPos = const Offset(0.1, 0.7),
    this.smokeColor = Colors.grey,
    this.honkType = 'car',
    this.vehicleType = 'car',
  });
}

class VehicleDef {
  final String id;
  final String imageId;
  final String name;
  final String? assetPath;
  final int unlockCost;
  final bool isUnlockedByDefault;
  final Color baseColor;
  final List<RepairSpotDef> repairSpots;
  final List<PaintZoneDef> paintZones;
  final String description;

  // Normalized positions (0 to 1) for 2:1 aspect ratio mapping
  final List<Offset> wheelCenters;
  final List<double> wheelRadii;
  final Offset headlightPos;
  final Offset dentPos;
  final int flatWheelIndex;
  final MotionProfile motionProfile;

  const VehicleDef({
    required this.id,
    required this.imageId,
    required this.name,
    this.assetPath,
    this.unlockCost = 0,
    this.isUnlockedByDefault = false,
    required this.baseColor,
    required this.repairSpots,
    required this.paintZones,
    required this.description,
    required this.wheelCenters,
    required this.wheelRadii,
    required this.headlightPos,
    required this.dentPos,
    required this.flatWheelIndex,
    required this.motionProfile,
  });
}
