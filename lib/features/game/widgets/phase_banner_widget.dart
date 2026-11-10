import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/game_controller.dart';

class PhaseBannerWidget extends StatefulWidget {
  final GamePhase phase;

  const PhaseBannerWidget({super.key, required this.phase});

  @override
  State<PhaseBannerWidget> createState() => _PhaseBannerWidgetState();
}

class _PhaseBannerWidgetState extends State<PhaseBannerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  String get _bannerText {
    switch (widget.phase) {
      case GamePhase.washSoap:
        return 'STAGE 1: SOAP FOAM!';
      case GamePhase.washRinse:
        return 'STAGE 2: RINSE WATER!';
      case GamePhase.repair:
        return 'NOW FIX THE DAMAGE!';
      case GamePhase.paint:
        return 'PAINT BOOTH!';
      case GamePhase.customization:
        return 'DECALS & RIMS!';
      case GamePhase.preview:
        return 'SHOWCASE PREVIEW!';
      case GamePhase.done:
        return 'LEVEL COMPLETED!';
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));

    _fadeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_animController);

    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant PhaseBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) {
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
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Text(
            _bannerText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
