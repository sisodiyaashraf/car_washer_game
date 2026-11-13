import 'package:flutter/material.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../app_ui_theme.dart';

class ToolSlot extends StatefulWidget {
  final String toolId;
  final String toolName;
  final IconData fallbackIcon;
  final bool isSelected;
  final bool isLocked;
  final bool isAdRewarded;
  final int? countBadge;
  final VoidCallback onTap;

  const ToolSlot({
    super.key,
    required this.toolId,
    required this.toolName,
    required this.fallbackIcon,
    this.isSelected = false,
    this.isLocked = false,
    this.isAdRewarded = false,
    this.countBadge,
    required this.onTap,
  });

  @override
  State<ToolSlot> createState() => _ToolSlotState();
}

class _ToolSlotState extends State<ToolSlot> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticsService().selectionClick();
        AudioService().playButtonClick();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          final glowAlpha = widget.isSelected ? 0.4 + (_glowController.value * 0.4) : 0.0;

          return Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isSelected ? AppUITheme.gold : AppUITheme.cardBg,
              border: Border.all(
                color: widget.isSelected ? AppUITheme.gold : AppUITheme.whiteBorder,
                width: widget.isSelected ? 3 : 2,
              ),
              boxShadow: [
                if (widget.isSelected)
                  BoxShadow(
                    color: AppUITheme.gold.withValues(alpha: glowAlpha),
                    blurRadius: 12,
                    spreadRadius: 3,
                  )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Tool Image Icon
                Image.asset(
                  AssetPaths.toolIcon(widget.toolId),
                  width: 32,
                  height: 32,
                  errorBuilder: (c, e, s) => Icon(
                    widget.fallbackIcon,
                    color: widget.isSelected ? Colors.black87 : Colors.white,
                    size: 26,
                  ),
                ),
                // Locked Padlock Overlay
                if (widget.isLocked)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock, color: Colors.white, size: 20),
                        if (widget.isAdRewarded)
                          const Icon(Icons.play_circle_filled, color: AppUITheme.gold, size: 14),
                      ],
                    ),
                  ),
                // Count Badge
                if (widget.countBadge != null && widget.countBadge! > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppUITheme.red,
                      ),
                      child: Text(
                        '${widget.countBadge}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
