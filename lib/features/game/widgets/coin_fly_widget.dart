import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';

class CoinFlyWidget extends StatefulWidget {
  final Offset startOffset;
  final Offset targetOffset;
  final VoidCallback onComplete;

  const CoinFlyWidget({
    super.key,
    required this.startOffset,
    required this.targetOffset,
    required this.onComplete,
  });

  @override
  State<CoinFlyWidget> createState() => _CoinFlyWidgetState();
}

class _CoinFlyWidgetState extends State<CoinFlyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _coinAnimations;
  static const int coinCount = 8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _coinAnimations = List.generate(coinCount, (index) {
      final startT = (index * 0.08).clamp(0.0, 0.5);
      final endT = (startT + 0.45).clamp(0.0, 1.0);

      return Tween<Offset>(
        begin: widget.startOffset,
        end: widget.targetOffset,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startT, endT, curve: Curves.easeInOutCubic),
        ),
      );
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _controller.addListener(() {
      for (int i = 0; i < coinCount; i++) {
        if (_controller.value > (i * 0.08 + 0.4) && _controller.value < (i * 0.08 + 0.45)) {
          AudioService().playCoinSound();
          HapticsService().selectionClick();
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(coinCount, (index) {
            final animValue = _coinAnimations[index].value;
            final progress = _controller.value;
            final isVisible = progress >= (index * 0.08) && progress <= (index * 0.08 + 0.5);

            if (!isVisible) return const SizedBox.shrink();

            return Positioned(
              left: animValue.dx,
              top: animValue.dy,
              child: const Icon(
                Icons.monetization_on,
                color: AppColors.accent,
                size: 24,
              ),
            );
          }),
        );
      },
    );
  }
}
