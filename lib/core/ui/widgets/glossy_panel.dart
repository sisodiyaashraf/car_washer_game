import 'package:flutter/material.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/motion/motion_tokens.dart';
import '../app_ui_theme.dart';
import '../app_typography.dart';
import 'game_button.dart';

class GlossyPanel extends StatefulWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const GlossyPanel({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  @override
  State<GlossyPanel> createState() => _GlossyPanelState();
}

class _GlossyPanelState extends State<GlossyPanel> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: MotionTokens.panelInDuration,
      reverseDuration: MotionTokens.panelOutDuration,
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: MotionTokens.panelInCurve,
        reverseCurve: MotionTokens.panelOutCurve,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animController.reverse().then((_) {
      if (widget.onClose != null) widget.onClose!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: AppUITheme.navyOutline,
          borderRadius: BorderRadius.circular(AppUITheme.radiusXL),
          border: Border.all(color: AppUITheme.whiteBorder, width: 2.5),
          boxShadow: AppUITheme.panelShadow,
        ),
        child: Stack(
          children: [
            Image.asset(
              AssetPaths.ui('panel'),
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const SizedBox.shrink(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glossy Blue Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    gradient: AppUITheme.blueButtonGradient,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppUITheme.radiusXL - 2)),
                  ),
                  child: Center(
                    child: Text(widget.title, style: AppTypography.displayMedium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppUITheme.spaceLG),
                  child: widget.child,
                ),
              ],
            ),
            if (widget.onClose != null)
              Positioned(
                right: 8,
                top: 8,
                child: GameButton(
                  onPressed: _dismiss,
                  variant: GameButtonVariant.round,
                  size: 32,
                  icon: Icons.close,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
