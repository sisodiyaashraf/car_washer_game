import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/customization_view.dart';
import '../widgets/done_view.dart';
import '../widgets/paint_view.dart';
import '../widgets/phase_banner_widget.dart';
import '../widgets/phase_indicator_bar.dart';
import '../widgets/repair_view.dart';
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
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            // Clean exit handler
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Consumer<GameController>(
              builder: (context, controller, child) {
                return Column(
                  children: [
                    const PhaseIndicatorBar(),
                    TutorialHintWidget(phase: controller.phase),
                    PhaseBannerWidget(phase: controller.phase),
                    Expanded(
                      child: _buildPhaseView(controller.phase),
                    ),
                  ],
                );
              },
            ),
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
