import 'package:flutter/material.dart';
import '../models/wash_tool_def.dart';

class ToolRepository {
  static const List<WashToolDef> washTools = [
    WashToolDef(
      id: 'sponge',
      name: 'Soapy Sponge',
      type: WashToolType.sponge,
      icon: Icons.soap,
      radiusRatio: 0.12,
      isForSoap: true,
      unlockCost: 0,
      isUnlockedByDefault: true,
      description: 'Lathers vehicle with rich soap bubbles.',
    ),
    WashToolDef(
      id: 'spray_hose',
      name: 'Garden Hose',
      type: WashToolType.sprayHose,
      icon: Icons.water_drop,
      radiusRatio: 0.14,
      isForSoap: false,
      unlockCost: 0,
      isUnlockedByDefault: true,
      description: 'Rinses off soap foam with water stream.',
    ),
    WashToolDef(
      id: 'pressure_washer',
      name: 'Turbo Pressure Washer',
      type: WashToolType.pressureWasher,
      icon: Icons.speed,
      radiusRatio: 0.22,
      isForSoap: false,
      unlockCost: 100,
      isUnlockedByDefault: false,
      description: 'High pressure wide water jet for super fast rinsing!',
    ),
    WashToolDef(
      id: 'wheel_brush',
      name: 'Wheel Scrub Brush',
      type: WashToolType.wheelBrush,
      icon: Icons.cleaning_services,
      radiusRatio: 0.16,
      isForSoap: true,
      unlockCost: 50,
      isUnlockedByDefault: false,
      description: 'Specialized scrub brush for rims and tires.',
    ),
  ];

  static WashToolDef getWashToolById(String id) {
    return washTools.firstWhere(
      (t) => t.id == id,
      orElse: () => washTools.first,
    );
  }
}
