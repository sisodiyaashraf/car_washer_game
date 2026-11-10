import 'package:flutter/material.dart';

class ToolUpgradeDef {
  final String id;
  final String name;
  final IconData icon;
  final int currentLevel;
  final int maxLevel;
  final int baseCost;
  final int costMultiplier;
  final String description;

  const ToolUpgradeDef({
    required this.id,
    required this.name,
    required this.icon,
    this.currentLevel = 0,
    this.maxLevel = 3,
    required this.baseCost,
    this.costMultiplier = 150,
    required this.description,
  });

  int get nextCost => baseCost + (currentLevel * costMultiplier);
  bool get isMaxed => currentLevel >= maxLevel;

  ToolUpgradeDef copyWithLevel(int newLevel) {
    return ToolUpgradeDef(
      id: id,
      name: name,
      icon: icon,
      currentLevel: newLevel,
      maxLevel: maxLevel,
      baseCost: baseCost,
      costMultiplier: costMultiplier,
      description: description,
    );
  }
}
