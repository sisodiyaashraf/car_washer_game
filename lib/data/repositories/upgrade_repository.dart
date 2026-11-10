import 'package:flutter/material.dart';
import '../models/upgrade_def.dart';

class UpgradeRepository {
  static const List<ToolUpgradeDef> upgrades = [
    ToolUpgradeDef(
      id: 'brush_radius',
      name: 'Super Scrub Radius',
      icon: Icons.cleaning_services,
      baseCost: 100,
      costMultiplier: 150,
      description: 'Increases soap sponge & brush coverage area (+20% per level).',
    ),
    ToolUpgradeDef(
      id: 'repair_speed',
      name: 'Power Tool Efficiency',
      icon: Icons.handyman,
      baseCost: 150,
      costMultiplier: 200,
      description: 'Bonus hit strength when repairing dents and vehicle parts.',
    ),
    ToolUpgradeDef(
      id: 'coin_multiplier',
      name: 'Golden Wash Polish',
      icon: Icons.monetization_on,
      baseCost: 200,
      costMultiplier: 250,
      description: 'Earn +25% bonus coins for every completed level per tier.',
    ),
  ];
}
