import 'package:flutter/material.dart';
import '../models/customization_def.dart';
import '../models/vehicle_def.dart';
import '../../features/game/painters/vehicle_painters.dart';

class VehicleRepository {
  static const List<VehicleDef> vehicles = [
    VehicleDef(
      id: 'hatchback',
      imageId: 'hatchback',
      name: 'City Hatchback',
      unlockCost: 0,
      isUnlockedByDefault: true,
      baseColor: Color(0xFF1E88E5), // Blue
      description: 'A nimble city car. Perfect for daily washing!',
      wheelCenters: [Offset(0.2833, 0.7400), Offset(0.7333, 0.7400)],
      wheelRadii: [0.0733, 0.0733],
      headlightPos: Offset(0.8700, 0.5533),
      dentPos: Offset(0.6000, 0.6000),
      flatWheelIndex: 1,
      motionProfile: MotionProfile(
        engineType: 'small',
        weight: 1.0,
        wheelRadii: [0.0733, 0.0733],
        honkType: 'car',
        vehicleType: 'car',
      ),
      repairSpots: [
        RepairSpotDef(
          id: 'dent_door',
          relativePosition: Offset(0.6000, 0.6000),
          spotType: RepairSpotType.dent,
          hitsNeeded: 1,
          label: 'Door Dent',
        ),
        RepairSpotDef(
          id: 'light_front',
          relativePosition: Offset(0.8700, 0.5533),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 1,
          label: 'Broken Headlight',
        ),
        RepairSpotDef(
          id: 'tire_front',
          relativePosition: Offset(0.7333, 0.7400),
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
      imageId: 'sports',
      name: 'Speedster GT',
      unlockCost: 150,
      isUnlockedByDefault: false,
      baseColor: Color(0xFFE53935), // Red
      description: 'High-speed sports coupe. Requires extra care!',
      wheelCenters: [Offset(0.2750, 0.7167), Offset(0.7583, 0.7167)],
      wheelRadii: [0.0700, 0.0700],
      headlightPos: Offset(0.8833, 0.5933),
      dentPos: Offset(0.5000, 0.5867),
      flatWheelIndex: 0,
      motionProfile: MotionProfile(
        engineType: 'small',
        weight: 0.9,
        wheelRadii: [0.0700, 0.0700],
        honkType: 'car',
        vehicleType: 'car',
      ),
      repairSpots: [
        RepairSpotDef(
          id: 'dent_hood',
          relativePosition: Offset(0.5000, 0.5867),
          spotType: RepairSpotType.dent,
          hitsNeeded: 2,
          label: 'Hood Dent',
        ),
        RepairSpotDef(
          id: 'scratch_side',
          relativePosition: Offset(0.4000, 0.5500),
          spotType: RepairSpotType.scratch,
          hitsNeeded: 1,
          label: 'Body Scratch',
        ),
        RepairSpotDef(
          id: 'light_front',
          relativePosition: Offset(0.8833, 0.5933),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 1,
          label: 'Broken Light',
        ),
        RepairSpotDef(
          id: 'tire_rear',
          relativePosition: Offset(0.2750, 0.7167),
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
      imageId: 'pickup',
      name: 'Utility Pickup',
      unlockCost: 300,
      isUnlockedByDefault: false,
      baseColor: Color(0xFF43A047), // Green
      description: 'Heavy duty worker truck. Comes with lots of mud!',
      wheelCenters: [Offset(0.2500, 0.7400), Offset(0.7500, 0.7400)],
      wheelRadii: [0.0767, 0.0767],
      headlightPos: Offset(0.8867, 0.5333),
      dentPos: Offset(0.2000, 0.6000),
      flatWheelIndex: 0,
      motionProfile: MotionProfile(
        engineType: 'truck',
        weight: 1.5,
        wheelRadii: [0.0767, 0.0767],
        honkType: 'truck',
        vehicleType: 'car',
      ),
      repairSpots: [
        RepairSpotDef(
          id: 'dent_bed',
          relativePosition: Offset(0.2000, 0.6000),
          spotType: RepairSpotType.dent,
          hitsNeeded: 2,
          label: 'Truck Bed Dent',
        ),
        RepairSpotDef(
          id: 'tire_front',
          relativePosition: Offset(0.7500, 0.7400),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 2,
          label: 'Front Tire',
        ),
        RepairSpotDef(
          id: 'light_front',
          relativePosition: Offset(0.8867, 0.5333),
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
      imageId: 'cruiser',
      name: 'Patrol Cruiser',
      unlockCost: 500,
      isUnlockedByDefault: false,
      baseColor: Color(0xFF1565C0), // Police Blue
      description: 'Official police vehicle. Fix the sirens and clean up!',
      wheelCenters: [Offset(0.2750, 0.7400), Offset(0.7333, 0.7400)],
      wheelRadii: [0.0733, 0.0733],
      headlightPos: Offset(0.8767, 0.5600),
      dentPos: Offset(0.6167, 0.6167),
      flatWheelIndex: 1,
      motionProfile: MotionProfile(
        engineType: 'small',
        weight: 1.1,
        wheelRadii: [0.0733, 0.0733],
        honkType: 'car',
        vehicleType: 'car',
      ),
      repairSpots: [
        RepairSpotDef(
          id: 'siren',
          relativePosition: Offset(0.5700, 0.2200),
          spotType: RepairSpotType.brokenLight,
          hitsNeeded: 2,
          label: 'Roof Siren Bar',
        ),
        RepairSpotDef(
          id: 'dent_fender',
          relativePosition: Offset(0.6167, 0.6167),
          spotType: RepairSpotType.dent,
          hitsNeeded: 2,
          label: 'Fender Dent',
        ),
        RepairSpotDef(
          id: 'tire_front',
          relativePosition: Offset(0.7333, 0.7400),
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
      imageId: 'monster',
      name: 'Monster Crusher',
      unlockCost: 750,
      isUnlockedByDefault: false,
      baseColor: Color(0xFFFB8C00), // Orange
      description: 'Gigantic tires, extreme mud, ultimate challenge!',
      wheelCenters: [Offset(0.2167, 0.7167), Offset(0.7833, 0.7167)],
      wheelRadii: [0.1200, 0.1200],
      headlightPos: Offset(0.8200, 0.4200),
      dentPos: Offset(0.3500, 0.4067),
      flatWheelIndex: 1,
      motionProfile: MotionProfile(
        engineType: 'bus',
        weight: 2.5,
        wheelRadii: [0.1200, 0.1200],
        honkType: 'truck',
        vehicleType: 'car',
      ),
      repairSpots: [
        RepairSpotDef(
          id: 'tire_giant_1',
          relativePosition: Offset(0.2167, 0.7167),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 3,
          label: 'Giant Rear Wheel',
        ),
        RepairSpotDef(
          id: 'tire_giant_2',
          relativePosition: Offset(0.7833, 0.7167),
          spotType: RepairSpotType.flatTire,
          hitsNeeded: 3,
          label: 'Giant Front Wheel',
        ),
        RepairSpotDef(
          id: 'engine_top',
          relativePosition: Offset(0.3500, 0.4067),
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
      imageId: 'biplane',
      name: 'Sky Explorer Biplane',
      unlockCost: 1000,
      isUnlockedByDefault: false,
      baseColor: Color(0xFF8E24AA), // Purple
      description: 'A classic vintage airplane needing a thorough wash!',
      wheelCenters: [Offset(0.5167, 0.8533), Offset(0.6417, 0.8533)],
      wheelRadii: [0.0367, 0.0367],
      headlightPos: Offset(0.8633, 0.5500),
      dentPos: Offset(0.5000, 0.5667),
      flatWheelIndex: 0,
      motionProfile: MotionProfile(
        engineType: 'plane',
        weight: 1.8,
        wheelRadii: [0.0367, 0.0367],
        honkType: 'plane',
        vehicleType: 'plane',
      ),
      repairSpots: [
        RepairSpotDef(
          id: 'propeller',
          relativePosition: Offset(0.8633, 0.5500),
          spotType: RepairSpotType.engine,
          hitsNeeded: 2,
          label: 'Propeller Hub',
        ),
        RepairSpotDef(
          id: 'wing_top',
          relativePosition: Offset(0.5000, 0.3000),
          spotType: RepairSpotType.scratch,
          hitsNeeded: 2,
          label: 'Top Wing Tear',
        ),
        RepairSpotDef(
          id: 'tail_fin',
          relativePosition: Offset(0.2000, 0.3500),
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
      case 'sports':
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
      case 'pickup':
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
      case 'cruiser':
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
      case 'monster':
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
      case 'biplane':
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
