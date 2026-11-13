import 'package:flutter/services.dart';

/// Central layout configuration toggle.
/// Set to true for landscape orientation (default side-view mode), or false for portrait mode.
const bool kLandscape = true;

/// Lock system orientations based on kLandscape configuration.
Future<void> lockGameOrientation() async {
  if (kLandscape) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
