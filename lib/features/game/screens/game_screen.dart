import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/camera/camera_controller.dart';
import '../../../core/services/audio_service.dart';
import '../controllers/game_controller.dart';
import '../controllers/vehicle_motion.dart';
import '../widgets/customization_view.dart';
import '../widgets/done_view.dart';
import '../widgets/paint_view.dart';
import '../widgets/phase_banner_widget.dart';
import '../widgets/phase_indicator_bar.dart';
import '../widgets/repair_view.dart';
import '../widgets/stage_widget.dart';
import '../widgets/tutorial_hint_widget.dart';
import '../widgets/vehicle_preview_view.dart';
import '../widgets/wash_view.dart';

class GameScreen extends StatelessWidget {
  final int levelNumber;

  const GameScreen({super.key, this.levelNumber = 1});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameController>(
      create: (_) => GameController(initialLevel: levelNumber),
      child: const _GameScreenBody(),
    );
  }
}

class _GameScreenBody extends StatefulWidget {
  const _GameScreenBody();

  @override
  State<_GameScreenBody> createState() => _GameScreenBodyState();
}

class _GameScreenBodyState extends State<_GameScreenBody> with TickerProviderStateMixin {
  late VehicleMotion _motion;
  late CameraController _camera;

  @override
  void initState() {
    super.initState();
    _motion = VehicleMotion();
    _camera = CameraController();
    AudioService().switchBgm(BgmTrack.gameplay);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = context.read<GameController>();
      _motion.startDriveIn(
        vsync: this,
        wheelRadius: controller.vehicleDef.wheelRadii.first,
        weight: controller.vehicleDef.motionProfile.weight,
        reducedMotion: false,
      );
    });
  }

  @override
  void dispose() {
    _motion.dispose();
    _camera.dispose();
    super.dispose();
  }

  String _getBgPhase(GamePhase phase) {
    switch (phase) {
      case GamePhase.washSoap:
      case GamePhase.washRinse:
        return 'wash_bay';
      case GamePhase.repair:
        return 'repair_garage';
      case GamePhase.paint:
      case GamePhase.customization:
      case GamePhase.preview:
      case GamePhase.done:
        return 'paint_booth';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VehicleMotion>.value(value: _motion),
        ChangeNotifierProvider<CameraController>.value(value: _camera),
      ],
      child: PopScope(
        canPop: true,
        child: Scaffold(
          body: Consumer<GameController>(
            builder: (context, controller, child) {
              final bgPhase = _getBgPhase(controller.phase);

              return GestureDetector(
                onTap: () {
                  if (_motion.state == MotionState.arriving || _motion.state == MotionState.leaving) {
                    _motion.skipAnimation();
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Layered Parallax Stage
                    StageWidget(
                      bgPhase: bgPhase,
                      vehicle: controller.vehicleDef,
                      motion: _motion,
                      camera: _camera,
                      paintColorName: controller.vehiclePaintColorName,
                      isDamaged: controller.phase == GamePhase.washSoap || controller.phase == GamePhase.washRinse,
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          const PhaseIndicatorBar(),
                          TutorialHintWidget(phase: controller.phase),
                          PhaseBannerWidget(phase: controller.phase),
                          Expanded(
                            child: IgnorePointer(
                              ignoring: _motion.isInputLocked,
                              child: _buildPhaseView(controller.phase),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseView(GamePhase phase) {
    switch (phase) {
      case GamePhase.washSoap:
      case GamePhase.washRinse:
        return const WashView();
      case GamePhase.repair:
        return const RepairView();
      case GamePhase.paint:
        return const PaintView();
      case GamePhase.customization:
        return const CustomizationView();
      case GamePhase.preview:
        return const VehiclePreviewView();
      case GamePhase.done:
        return const DoneView();
    }
  }
}
