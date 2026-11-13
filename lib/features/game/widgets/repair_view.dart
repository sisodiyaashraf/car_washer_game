import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/camera/camera_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/motion/motion_tokens.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../../../data/models/vehicle_def.dart';
import '../controllers/game_controller.dart';
import 'repair/broken_light_repair_widget.dart';
import 'repair/dent_repair_widget.dart';
import 'repair/flat_tire_repair_widget.dart';
import 'repair/part_replacement_widget.dart';
import 'repair/repair_spot_highlight.dart';

class RepairView extends StatefulWidget {
  const RepairView({super.key});

  @override
  State<RepairView> createState() => _RepairViewState();
}

class _RepairViewState extends State<RepairView> with SingleTickerProviderStateMixin {
  String? _focusedSpotId;
  late AnimationController _popController;
  late Animation<double> _popScale;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: MotionTokens.fixConfirmationDuration,
    );

    _popScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: MotionTokens.fixConfirmationScaleMax).chain(CurveTween(curve: MotionTokens.fixConfirmationCurve)), weight: 70),
      TweenSequenceItem(tween: Tween(begin: MotionTokens.fixConfirmationScaleMax, end: 1.0), weight: 30),
    ]).animate(_popController);
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  void _handleSpotSelected(RepairSpotDef spot) {
    setState(() {
      _focusedSpotId = spot.id;
    });
    try {
      context.read<CameraController>().focusOn(spot.relativePosition, 1.25, vsync: this);
    } catch (_) {}
  }

  void _handleSpotHit(RepairSpotDef spot) {
    final controller = context.read<GameController>();
    controller.hitRepairSpot(spot.id);

    try {
      context.read<CameraController>().shake(4.0);
    } catch (_) {}

    HapticsService().mediumImpact();

    final remaining = controller.repairHitsRemaining[spot.id] ?? 0;
    if (remaining <= 0) {
      AudioService().playPartSnap();
      HapticsService().successPattern();
      _popController.forward(from: 0.0).then((_) {
        setState(() {
          _focusedSpotId = null;
        });
        try {
          context.read<CameraController>().reset(vsync: this);
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;
    final spots = vehicle.repairSpots;

    return Column(
      children: [
        // Repair Phase Header Banner
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.build, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'GARAGE REPAIR: FIX ALL VEHICLE DAMAGE',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.92;
                final height = width / 2.0;

                return SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    children: [
                      // Active Repair Spot Indicators & Interactive Widgets
                      ...spots.map((spot) {
                        final hits = controller.repairHitsRemaining[spot.id] ?? spot.hitsNeeded;
                        final isRepaired = hits <= 0;
                        final spotPos = Offset(spot.relativePosition.dx * width, spot.relativePosition.dy * height);

                        if (isRepaired) return const SizedBox.shrink();

                        return Positioned(
                          left: spotPos.dx - 28,
                          top: spotPos.dy - 28,
                          child: ScaleTransition(
                            scale: _focusedSpotId == spot.id ? _popScale : const AlwaysStoppedAnimation(1.0),
                            child: _buildRepairSpotWidget(spot, hits),
                          ),
                        );
                      }),
                      // Spot Focus Bouncing Target Overlay
                      if (_focusedSpotId == null)
                        ...spots.where((s) => (controller.repairHitsRemaining[s.id] ?? 1) > 0).map((spot) {
                          final spotPos = Offset(spot.relativePosition.dx * width, spot.relativePosition.dy * height);
                          return RepairSpotHighlight(
                            position: spotPos,
                            onTap: () => _handleSpotSelected(spot),
                          );
                        }),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Draggable Engine Parts Tray if engine repair active
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: PartTrayWidget(),
        ),
      ],
    );
  }

  Widget _buildRepairSpotWidget(RepairSpotDef spot, int hits) {
    switch (spot.spotType) {
      case RepairSpotType.dent:
      case RepairSpotType.scratch:
        return DentRepairWidget(
          hitsRemaining: hits,
          onTap: () => _handleSpotHit(spot),
        );
      case RepairSpotType.flatTire:
        return FlatTireRepairWidget(
          hitsRemaining: hits,
          onCompleteStep: () => _handleSpotHit(spot),
        );
      case RepairSpotType.brokenLight:
        return BrokenLightRepairWidget(
          hitsRemaining: hits,
          onCompleteStep: () => _handleSpotHit(spot),
        );
      case RepairSpotType.engine:
        return PartReplacementWidget(
          hitsRemaining: hits,
          onCompleteStep: () => _handleSpotHit(spot),
        );
    }
  }
}
