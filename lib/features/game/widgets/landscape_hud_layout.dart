import 'package:flutter/material.dart';
import '../../../core/ui/widgets/game_button.dart';
import '../../../core/ui/widgets/tool_slot.dart';
import '../../../core/ui/widgets/top_hud.dart';
import '../../../data/models/wash_tool_def.dart';
import '../../../data/repositories/tool_repository.dart';

class LandscapeHudLayout extends StatelessWidget {
  final int coins;
  final double progress;
  final WashToolDef selectedTool;
  final ValueChanged<WashToolDef> onToolSelected;
  final VoidCallback onPausePressed;
  final VoidCallback onHomePressed;
  final VoidCallback onSettingsPressed;
  final Widget gameArea;

  const LandscapeHudLayout({
    super.key,
    required this.coins,
    required this.progress,
    required this.selectedTool,
    required this.onToolSelected,
    required this.onPausePressed,
    required this.onHomePressed,
    required this.onSettingsPressed,
    required this.gameArea,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main Game World View
          Positioned.fill(child: gameArea),

          // Top Bar (TopHUD)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: TopHud(
              coins: coins,
              progress: progress,
              onPausePressed: onPausePressed,
            ),
          ),

          // Left Vertical Column of Tool Groups
          Positioned(
            left: 16,
            top: 70,
            bottom: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GameButton(
                  onPressed: () {},
                  variant: GameButtonVariant.round,
                  size: 48,
                  icon: Icons.cleaning_services,
                ),
                const SizedBox(height: 12),
                GameButton(
                  onPressed: () {},
                  variant: GameButtonVariant.round,
                  size: 48,
                  icon: Icons.handyman,
                ),
              ],
            ),
          ),

          // Right Column Action Buttons
          Positioned(
            right: 16,
            top: 70,
            bottom: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GameButton(
                  onPressed: onHomePressed,
                  variant: GameButtonVariant.round,
                  size: 48,
                  icon: Icons.home,
                ),
                const SizedBox(height: 12),
                GameButton(
                  onPressed: onSettingsPressed,
                  variant: GameButtonVariant.round,
                  size: 48,
                  icon: Icons.settings,
                ),
              ],
            ),
          ),

          // Bottom Center Tool Slots Row
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ToolRepository.washTools.map((tool) {
                    final isSelected = tool.id == selectedTool.id;

                    return ToolSlot(
                      toolId: tool.id,
                      toolName: tool.name,
                      fallbackIcon: tool.icon,
                      isSelected: isSelected,
                      isLocked: !tool.isUnlockedByDefault,
                      onTap: () => onToolSelected(tool),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
