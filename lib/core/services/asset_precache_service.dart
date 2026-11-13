import 'package:flutter/material.dart';
import '../constants/asset_paths.dart';
import '../../data/repositories/tool_repository.dart';

class AssetPrecacheService {
  static Future<void> precacheGameAssets(BuildContext context) async {
    // Precache Bay Backgrounds
    final bays = ['wash_bay', 'repair_garage', 'paint_booth'];
    for (final bay in bays) {
      final path = AssetPaths.background(bay);
      precacheImage(AssetImage(path), context);
    }

    // Precache Wash Tool Icons
    for (final tool in ToolRepository.washTools) {
      final path = AssetPaths.toolIcon(tool.id);
      precacheImage(AssetImage(path), context);
    }
  }
}
