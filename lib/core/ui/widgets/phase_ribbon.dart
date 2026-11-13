import 'package:flutter/material.dart';
import '../../../core/motion/motion_tokens.dart';
import '../app_ui_theme.dart';
import '../app_typography.dart';

class PhaseRibbon extends StatefulWidget {
  final String text;

  const PhaseRibbon({super.key, required this.text});

  @override
  State<PhaseRibbon> createState() => _PhaseRibbonState();
}

class _PhaseRibbonState extends State<PhaseRibbon> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: MotionTokens.ribbonInDuration + MotionTokens.ribbonHoldDuration + MotionTokens.ribbonOutDuration,
    );

    final totalMs = _animController.duration!.inMilliseconds.toDouble();
    final inRatio = MotionTokens.ribbonInDuration.inMilliseconds / totalMs;
    final holdRatio = (MotionTokens.ribbonInDuration.inMilliseconds + MotionTokens.ribbonHoldDuration.inMilliseconds) / totalMs;

    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, -2.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: inRatio * 100,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Offset.zero),
        weight: (holdRatio - inRatio) * 100,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0, -2.0)).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: (1.0 - holdRatio) * 100,
      ),
    ]).animate(_animController);

    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant PhaseRibbon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppUITheme.goldButtonGradient,
          borderRadius: BorderRadius.circular(AppUITheme.radiusPill),
          border: Border.all(color: AppUITheme.whiteBorder, width: 2),
          boxShadow: AppUITheme.buttonShadow,
        ),
        child: Text(
          widget.text,
          style: AppTypography.bodyLarge.copyWith(color: AppUITheme.navyOutline),
        ),
      ),
    );
  }
}
