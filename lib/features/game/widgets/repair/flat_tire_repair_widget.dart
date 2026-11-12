import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptics_service.dart';

class FlatTireRepairWidget extends StatefulWidget {
  final int hitsRemaining;
  final VoidCallback onCompleteStep;

  const FlatTireRepairWidget({
    super.key,
    required this.hitsRemaining,
    required this.onCompleteStep,
  });

  @override
  State<FlatTireRepairWidget> createState() => _FlatTireRepairWidgetState();
}

class _FlatTireRepairWidgetState extends State<FlatTireRepairWidget> {
  bool _wheelPlaced = false;
  double _airPressureGauge = 0.0;
  Timer? _pumpTimer;

  void _startPump() {
    if (!_wheelPlaced) return;
    _pumpTimer?.cancel();
    AudioService().playAirPump();

    _pumpTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      HapticsService().lightImpact();
      setState(() {
        _airPressureGauge = (_airPressureGauge + 0.12).clamp(0.0, 1.0);
        if (_airPressureGauge >= 1.0) {
          _pumpTimer?.cancel();
          AudioService().playPartSnap();
          HapticsService().successPattern();
          widget.onCompleteStep();
        }
      });
    });
  }

  void _stopPump() {
    _pumpTimer?.cancel();
    AudioService().stopSfx();
  }

  @override
  void dispose() {
    _pumpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRepaired = widget.hitsRemaining <= 0;
    if (isRepaired) {
      return Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      );
    }

    if (!_wheelPlaced) {
      return DragTarget<String>(
        onAcceptWithDetails: (details) {
          AudioService().playPartSnap();
          HapticsService().mediumImpact();
          setState(() {
            _wheelPlaced = true;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.shade700,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
            ),
            child: Center(
              child: Image.asset(
                AssetPaths.toolIcon('spare_tire'),
                width: 32,
                height: 32,
                errorBuilder: (c, e, s) => const Icon(Icons.tire_repair, color: Colors.white, size: 26),
              ),
            ),
          );
        },
      );
    }

    // Wheel placed -> hold air pump gesture
    return GestureDetector(
      onLongPressStart: (_) => _startPump(),
      onLongPressEnd: (_) => _stopPump(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
            ),
            child: Center(
              child: Image.asset(
                AssetPaths.toolIcon('air_pump'),
                width: 32,
                height: 32,
                errorBuilder: (c, e, s) => const Icon(Icons.compress, color: Colors.white, size: 26),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _airPressureGauge,
                minHeight: 8,
                color: AppColors.success,
                backgroundColor: Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
