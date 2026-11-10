import 'package:flutter/material.dart';
import '../models/customization_def.dart';
import '../models/vehicle_def.dart';
import '../../features/game/painters/vehicle_painters.dart';

class VehicleRepository {
  static const List<VehicleDef> vehicles = [
    VehicleDef(
      id: 'hatchback',
      name: 'City Hatchback',
      unlockCost: 0,
      isUnlockedByDefault: true,
      baseColor: Color(0xFF1E88E5), // Blue
      description: 'A nimble city car. Perfect for daily washing!',
      repairSpots: [
        RepairSpotDef(
          id: 'dent_door',
          relativePosition: Offset(0.45, 0.55),
          spotType: RepairSpotType.dent,
          hitsNeeded: 1,
          label: 'Door Dent',
        ),
        RepairSpotDef(
          id: 'light_front',
          relativePosition: Offset(0.90, 0.55),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 1,
          label: 'Broken Headlight',
        ),
        RepairSpotDef(
          id: 'tire_front',
          relativePosition: Offset(0.75, 0.75),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 1,
          label: 'Flat Tire',
        ),
      ],
      paintZones: [
        PaintZoneDef(
          id: 'body',
          name: 'Main Body',
          relativeBounds: Rect.fromLTWH(0.1, 0.2, 0.85, 0.5),
        ),
      ],
    ),
    VehicleDef(
      id: 'sports_car',
      name: 'Speedster GT',
      unlockCost: 150,
      isUnlockedByDefault: false,
      baseColor: Color(0xFFE53935), // Red
      description: 'High-speed sports coupe. Requires extra care!',
      repairSpots: [
        RepairSpotDef(
          id: 'dent_hood',
          relativePosition: Offset(0.80, 0.45),
          spotType: RepairSpotType.dent,
          hitsNeeded: 2,
          label: 'Hood Dent',
        ),
        RepairSpotDef(
          id: 'scratch_side',
          relativePosition: Offset(0.50, 0.55),
          spotType: RepairSpotType.scratch,
          hitsNeeded: 1,
          label: 'Body Scratch',
        ),
        RepairSpotDef(
          id: 'light_front',
          relativePosition: Offset(0.92, 0.50),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 1,
          label: 'Broken Light',
        ),
        RepairSpotDef(
          id: 'tire_rear',
          relativePosition: Offset(0.25, 0.70),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 1,
          label: 'Rear Flat Tire',
        ),
      ],
      paintZones: [
        PaintZoneDef(
          id: 'body',
          name: 'Main Body',
          relativeBounds: Rect.fromLTWH(0.05, 0.22, 0.9, 0.45),
        ),
      ],
    ),
    VehicleDef(
      id: 'pickup_truck',
      name: 'Utility Pickup',
      unlockCost: 300,
      isUnlockedByDefault: false,
      baseColor: Color(0xFF43A047), // Green
      description: 'Heavy duty worker truck. Comes with lots of mud!',
      repairSpots: [
        RepairSpotDef(
          id: 'dent_bed',
          relativePosition: Offset(0.25, 0.50),
          spotType: RepairSpotType.dent,
          hitsNeeded: 2,
          label: 'Truck Bed Dent',
        ),
        RepairSpotDef(
          id: 'tire_front',
          relativePosition: Offset(0.76, 0.75),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 2,
          label: 'Front Tire',
        ),
        RepairSpotDef(
          id: 'light_front',
          relativePosition: Offset(0.92, 0.52),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 1,
          label: 'Headlight',
        ),
      ],
      paintZones: [
        PaintZoneDef(
          id: 'body',
          name: 'Cab & Bed',
          relativeBounds: Rect.fromLTWH(0.08, 0.22, 0.88, 0.5),
        ),
      ],
    ),
    VehicleDef(
      id: 'police_car',
      name: 'Patrol Cruiser',
      unlockCost: 500,
      isUnlockedByDefault: false,
      baseColor: Color(0xFF1565C0), // Police Blue/Dark
      description: 'Official police vehicle. Fix the sirens and clean up!',
      repairSpots: [
        RepairSpotDef(
          id: 'siren',
          relativePosition: Offset(0.57, 0.18),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 2,
          label: 'Roof Siren Bar',
        ),
        RepairSpotDef(
          id: 'dent_fender',
          relativePosition: Offset(0.85, 0.50),
          spotType: RepairSpotType.dent,
          hitsNeeded: 2,
          label: 'Fender Dent',
        ),
        RepairSpotDef(
          id: 'tire_front',
          relativePosition: Offset(0.76, 0.72),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 1,
          label: 'Front Tire',
        ),
      ],
      paintZones: [
        PaintZoneDef(
          id: 'body',
          name: 'Cruiser Body',
          relativeBounds: Rect.fromLTWH(0.08, 0.22, 0.88, 0.48),
        ),
      ],
    ),
    VehicleDef(
      id: 'monster_truck',
      name: 'Monster Crusher',
      unlockCost: 750,
      isUnlockedByDefault: false,
      baseColor: Color(0xFFFB8C00), // Orange
      description: 'Gigantic tires, extreme mud, ultimate challenge!',
      repairSpots: [
        RepairSpotDef(
          id: 'tire_giant_1',
          relativePosition: Offset(0.28, 0.72),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 3,
          label: 'Giant Rear Wheel',
        ),
        RepairSpotDef(
          id: 'tire_giant_2',
          relativePosition: Offset(0.74, 0.72),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 3,
          label: 'Giant Front Wheel',
        ),
        RepairSpotDef(
          id: 'engine_top',
          relativePosition: Offset(0.50, 0.25),
          spotType: RepairSpotType.engine,
          hitsNeeded: 2,
          label: 'Supercharger',
        ),
      ],
      paintZones: [
        PaintZoneDef(
          id: 'body',
          name: 'Monster Frame',
          relativeBounds: Rect.fromLTWH(0.15, 0.16, 0.78, 0.38),
        ),
      ],
    ),
    VehicleDef(
      id: 'plane',
      name: 'Sky Explorer Biplane',
      unlockCost: 1000,
      isUnlockedByDefault: false,
      baseColor: Color(0xFF8E24AA), // Purple
      description: 'A classic vintage airplane needing a thorough wash!',
      repairSpots: [
        RepairSpotDef(
          id: 'propeller',
          relativePosition: Offset(0.95, 0.48),
          spotType: RepairSpotType.engine,
          hitsNeeded: 2,
          label: 'Propeller Hub',
        ),
        RepairSpotDef(
          id: 'wing_top',
          relativePosition: Offset(0.50, 0.20),
          spotType: RepairSpotType.scratch,
          hitsNeeded: 2,
          label: 'Top Wing Tear',
        ),
        RepairSpotDef(
          id: 'tail_fin',
          relativePosition: Offset(0.15, 0.30),
          spotType: RepairSpotType.dent,
          hitsNeeded: 1,
          label: 'Tail Fin Dent',
        ),
      ],
      paintZones: [
        PaintZoneDef(
          id: 'body',
          name: 'Fuselage & Wings',
          relativeBounds: Rect.fromLTWH(0.1, 0.15, 0.85, 0.7),
        ),
      ],
    ),
  ];

  static VehicleDef getVehicleById(String id) {
    return vehicles.firstWhere(
      (v) => v.id == id,
      orElse: () => vehicles.first,
    );
  }

  static CustomPainter buildVehiclePainter({
    required String vehicleId,
    required Color bodyColor,
    Map<String, bool>? damagedSpots,
    RimStyle rimStyle = RimStyle.classic,
    DecalType decalType = DecalType.none,
    Offset decalOffset = const Offset(0.5, 0.45),
    double decalScale = 1.0,
    bool isCleanShine = false,
  }) {
    switch (vehicleId) {
      case 'sports_car':
        return SportsCarPainter(
          bodyColor: bodyColor,
          damagedSpots: damagedSpots,
          rimStyle: rimStyle,
          decalType: decalType,
          decalOffset: decalOffset,
          decalScale: decalScale,
          isCleanShine: isCleanShine,
        );
      case 'pickup_truck':
        return PickupTruckPainter(
          bodyColor: bodyColor,
          damagedSpots: damagedSpots,
          rimStyle: rimStyle,
          decalType: decalType,
          decalOffset: decalOffset,
          decalScale: decalScale,
          isCleanShine: isCleanShine,
        );
      case 'police_car':
        return PoliceCarPainter(
          bodyColor: bodyColor,
          damagedSpots: damagedSpots,
          rimStyle: rimStyle,
          decalType: decalType,
          decalOffset: decalOffset,
          decalScale: decalScale,
          isCleanShine: isCleanShine,
        );
      case 'monster_truck':
        return MonsterTruckPainter(
          bodyColor: bodyColor,
          damagedSpots: damagedSpots,
          rimStyle: rimStyle,
          decalType: decalType,
          decalOffset: decalOffset,
          decalScale: decalScale,
          isCleanShine: isCleanShine,
        );
      case 'plane':
        return PlanePainter(
          bodyColor: bodyColor,
          damagedSpots: damagedSpots,
          rimStyle: rimStyle,
          decalType: decalType,
          decalOffset: decalOffset,
          decalScale: decalScale,
          isCleanShine: isCleanShine,
        );
      case 'hatchback':
      default:
        return HatchbackPainter(
          bodyColor: bodyColor,
          damagedSpots: damagedSpots,
          rimStyle: rimStyle,
          decalType: decalType,
          decalOffset: decalOffset,
          decalScale: decalScale,
          isCleanShine: isCleanShine,
        );
    }
  }
}
