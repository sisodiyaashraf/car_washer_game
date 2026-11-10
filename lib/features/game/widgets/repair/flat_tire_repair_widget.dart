import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
    _pumpTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        _airPressureGauge = (_airPressureGauge + 0.1).clamp(0.0, 1.0);
        if (_airPressureGauge >= 1.0) {
          _pumpTimer?.cancel();
          widget.onCompleteStep();
        }
      });
    });
  }

  void _stopPump() {
    _pumpTimer?.cancel();
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
        width: 50,
        height: 50,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
        child: const Icon(Icons.check, color: Colors.white),
      );
    }

    if (!_wheelPlaced) {
      return DragTarget<String>(
        onAcceptWithDetails: (details) {
          setState(() {
            _wheelPlaced = true;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.shade700,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.tire_repair, color: Colors.white, size: 26),
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
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            child: const Icon(Icons.compress, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: _airPressureGauge,
              color: AppColors.success,
              backgroundColor: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
