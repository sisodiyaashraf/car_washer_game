import 'package:flutter/material.dart';
import '../models/customization_def.dart';

class CustomizationRepository {
  static const List<DecalDef> decals = [
    DecalDef(id: 'none', name: 'No Decal', type: DecalType.none, icon: Icons.block),
    DecalDef(id: 'stripes', name: 'Racing Stripes', type: DecalType.stripes, icon: Icons.line_weight),
    DecalDef(id: 'flames', name: 'Hot Flames', type: DecalType.flames, icon: Icons.local_fire_department),
    DecalDef(id: 'racing_number', name: 'Speed #07', type: DecalType.racingNumber, icon: Icons.tag),
    DecalDef(id: 'stars', name: 'Star Burst', type: DecalType.stars, icon: Icons.star),
    DecalDef(id: 'camo', name: 'Military Camo', type: DecalType.camo, icon: Icons.grid_view),
    DecalDef(id: 'checker', name: 'Checkered Flag', type: DecalType.checker, icon: Icons.flag),
  ];

  static const List<RimStyleDef> rims = [
    RimStyleDef(id: 'classic', name: 'Classic Rim', style: RimStyle.classic, icon: Icons.adjust),
    RimStyleDef(id: 'sport_spoke', name: 'Sport 5-Spoke', style: RimStyle.sportSpoke, icon: Icons.motion_photos_on),
    RimStyleDef(id: 'offroad_beadlock', name: 'Offroad Beadlock', style: RimStyle.offroadBeadlock, icon: Icons.brightness_low),
    RimStyleDef(id: 'star_alloy', name: 'Star Alloy', style: RimStyle.starAlloy, icon: Icons.stars),
  ];
}
