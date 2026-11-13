import 'package:flutter/material.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/motion/motion_tokens.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../app_ui_theme.dart';
import '../app_typography.dart';

enum GameButtonVariant { pill, round }

class GameButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final GameButtonVariant variant;
  final bool isCTA;
  final bool isDisabled;
  final double size;

  const GameButton({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.variant = GameButtonVariant.pill,
    this.isCTA = false,
    this.isDisabled = false,
    this.size = 52.0,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: MotionTokens.uiPressDownDuration,
      reverseDuration: MotionTokens.uiPressSpringDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: MotionTokens.uiPressScale,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.isCTA) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isDisabled || widget.onPressed == null) return;
    HapticsService().lightImpact();
    AudioService().playButtonClick();
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isDisabled || widget.onPressed == null) return;
    _pressController.reverse().then((_) {
      widget.onPressed?.call();
    });
  }

  void _handleTapCancel() {
    if (widget.isDisabled || widget.onPressed == null) return;
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final assetState = widget.isDisabled ? 'button_disabled' : 'button_normal';

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: Colors.white, size: widget.size * 0.45),
          if (widget.label != null) const SizedBox(width: AppUITheme.spaceSM),
        ],
        if (widget.label != null)
          Text(
            widget.label!,
            style: AppTypography.bodyLarge.copyWith(
              color: Colors.white,
              fontSize: widget.size * 0.36,
            ),
          ),
        if (widget.child != null) widget.child!,
      ],
    );

    final isRound = widget.variant == GameButtonVariant.round;

    Widget buttonBody = AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseScale = widget.isCTA ? 1.0 + (_pulseController.value * 0.05) : 1.0;

        return Transform.scale(
          scale: pulseScale,
          child: Container(
            width: isRound ? widget.size : null,
            height: widget.size,
            padding: EdgeInsets.symmetric(
              horizontal: isRound ? 0 : AppUITheme.spaceLG,
            ),
            decoration: BoxDecoration(
              shape: isRound ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isRound ? null : BorderRadius.circular(AppUITheme.radiusPill),
              gradient: widget.isDisabled ? AppUITheme.disabledGradient : (widget.isCTA ? AppUITheme.goldButtonGradient : AppUITheme.blueButtonGradient),
              border: Border.all(color: AppUITheme.whiteBorder, width: 2),
              boxShadow: AppUITheme.buttonShadow,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glossy background image fallback
                Image.asset(
                  AssetPaths.ui(assetState),
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const SizedBox.shrink(),
                ),
                content,
              ],
            ),
          ),
        );
      },
    );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: buttonBody,
      ),
    );
  }
}
