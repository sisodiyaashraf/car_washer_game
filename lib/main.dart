import 'dart:async';
import 'package:flutter/material.dart';
import 'core/ads/ad_service.dart';
import 'core/constants/game_constants.dart';
import 'core/layout/game_layout.dart';
import 'core/purchases/purchase_service.dart';
import 'core/services/audio_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/menu/screens/main_menu_screen.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await lockGameOrientation();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Global Error Handler Captured: ${details.exceptionAsString()}');
    };

    await StorageService().init();
    await AdService().initialize();
    PurchaseService().initialize();

    runApp(const CarWasherApp());
  }, (error, stackTrace) {
    debugPrint('Uncaught Error in Zone: $error\n$stackTrace');
  });
}

class CarWasherApp extends StatefulWidget {
  const CarWasherApp({super.key});

  @override
  State<CarWasherApp> createState() => _CarWasherAppState();
}

class _CarWasherAppState extends State<CarWasherApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioService().switchBgm(BgmTrack.menu);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PurchaseService().dispose();
    AudioService().stopBgm();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioService().stopBgm();
    } else if (state == AppLifecycleState.resumed) {
      AudioService().switchBgm(BgmTrack.menu);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();

    return MaterialApp(
      title: GameConstants.appName,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: storage.showPerformanceOverlay,
      theme: AppTheme.lightTheme,
      home: const MainMenuScreen(),
    );
  }
}
