import 'package:flutter/material.dart';

enum WashToolType {
  sponge,
  sprayHose,
  pressureWasher,
  wheelBrush,
}

class WashToolDef {
  final String id;
  final String name;
  final WashToolType type;
  final IconData icon;
  final double radiusRatio; // Ratio relative to canvas size
  final bool isForSoap; // true if soap tool, false if rinse tool
  final int unlockCost;
  final bool isUnlockedByDefault;
  final String description;

  const WashToolDef({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.radiusRatio,
    required this.isForSoap,
    this.unlockCost = 0,
    this.isUnlockedByDefault = true,
    required this.description,
  });
}
