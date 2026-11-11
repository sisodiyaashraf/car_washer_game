class AssetPaths {
  static const String baseImages = 'assets/images';

  static String vehicleClean(String id) => '$baseImages/vehicles/vehicle_${id}_clean.png';
  static String vehicleDamaged(String id) => '$baseImages/vehicles/vehicle_${id}_damaged.png';
  static String vehiclePaint(String id, String colorName) => '$baseImages/vehicles/paint/vehicle_${id}_clean_$colorName.png';
  static String background(String phase) => '$baseImages/backgrounds/bg_$phase.png';
  static String toolIcon(String id) => '$baseImages/tools/tool_$id.png';
  static String decal(String id) => '$baseImages/decals/decal_$id.png';
  static String rim(String id) => '$baseImages/rims/rim_$id.png';
  static String ui(String name) => '$baseImages/ui/ui_$name.png';

  // New Drive-in & Motion Assets
  static String wheelSprite(String family) => '$baseImages/wheels/wheel_$family.png';
  static String fxDust() => '$baseImages/fx/fx_dust.png';
  static String fxSpeedline() => '$baseImages/fx/fx_speedline.png';
  static String fxHeadlightBeam() => '$baseImages/fx/fx_headlight_beam.png';
  static String fxHonk() => '$baseImages/fx/fx_honk.png';
  static String propGarageDoor() => '$baseImages/props/prop_garage_door.png';
}
