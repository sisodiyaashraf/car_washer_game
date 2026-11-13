import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/ui/app_ui_theme.dart';
import '../../../core/ui/app_typography.dart';
import '../../../core/ui/widgets/game_button.dart';
import '../../../core/ui/widgets/glossy_panel.dart';
import '../../../core/ui/widgets/phase_ribbon.dart';
import '../../../core/ui/widgets/tool_slot.dart';
import '../../../core/ui/widgets/top_hud.dart';

class UiGalleryScreen extends StatefulWidget {
  const UiGalleryScreen({super.key});

  @override
  State<UiGalleryScreen> createState() => _UiGalleryScreenState();
}

class _UiGalleryScreenState extends State<UiGalleryScreen> {
  int _selectedToolIndex = 0;
  bool _showPanel = false;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(body: Center(child: Text('Debug Only')));
    }

    return Scaffold(
      backgroundColor: AppUITheme.navyOutline,
      appBar: AppBar(
        title: const Text('UI Design System Gallery'),
        backgroundColor: AppUITheme.blueGradientEnd,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppUITheme.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top HUD Component:', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              TopHud(
                coins: 450,
                progress: 0.65,
                onPausePressed: () {},
              ),
              const SizedBox(height: 24),

              const Text('Phase Ribbon:', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              const Center(child: PhaseRibbon(text: 'STAGE 1: SOAP FOAM!')),
              const SizedBox(height: 24),

              const Text('Game Buttons:', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  GameButton(onPressed: () {}, label: 'Pill Button'),
                  GameButton(onPressed: () {}, label: 'CTA Pulse', isCTA: true),
                  GameButton(onPressed: () {}, label: 'Disabled', isDisabled: true),
                  GameButton(onPressed: () {}, variant: GameButtonVariant.round, icon: Icons.play_arrow),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Tool Slots:', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  ToolSlot(
                    toolId: 'sponge',
                    toolName: 'Sponge',
                    fallbackIcon: Icons.soap,
                    isSelected: _selectedToolIndex == 0,
                    onTap: () => setState(() => _selectedToolIndex = 0),
                  ),
                  ToolSlot(
                    toolId: 'spray_hose',
                    toolName: 'Hose',
                    fallbackIcon: Icons.water_drop,
                    isSelected: _selectedToolIndex == 1,
                    onTap: () => setState(() => _selectedToolIndex = 1),
                  ),
                  ToolSlot(
                    toolId: 'pressure_washer',
                    toolName: 'Washer',
                    fallbackIcon: Icons.speed,
                    isLocked: true,
                    isAdRewarded: true,
                    isSelected: _selectedToolIndex == 2,
                    onTap: () => setState(() => _selectedToolIndex = 2),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => setState(() => _showPanel = !_showPanel),
                child: const Text('Toggle Glossy Panel Dialog'),
              ),
              const SizedBox(height: 12),
              if (_showPanel)
                Center(
                  child: GlossyPanel(
                    title: 'PREVIEW PANEL',
                    onClose: () => setState(() => _showPanel = false),
                    child: const Column(
                      children: [
                        Text('Sample content inside Glossy Panel dialog.', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
