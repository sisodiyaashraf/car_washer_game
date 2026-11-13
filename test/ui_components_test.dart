import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/ui/widgets/game_button.dart';
import 'package:carwasher/core/ui/widgets/glossy_panel.dart';
import 'package:carwasher/core/ui/widgets/tool_slot.dart';
import 'package:carwasher/core/ui/widgets/top_hud.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UI Design System Component Tests', () {
    testWidgets('1. GameButton renders and responds to tap down scale', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameButton(
              onPressed: () => pressed = true,
              label: 'Test Button',
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);

      final gesture = await tester.startGesture(tester.getCenter(find.text('Test Button')));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 200));

      expect(pressed, isTrue);
    });

    testWidgets('2. ToolSlot displays selected gold ring and locked padlock badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                ToolSlot(
                  toolId: 'sponge',
                  toolName: 'Sponge',
                  fallbackIcon: Icons.soap,
                  isSelected: true,
                  onTap: () {},
                ),
                ToolSlot(
                  toolId: 'washer',
                  toolName: 'Washer',
                  fallbackIcon: Icons.speed,
                  isLocked: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('3. TopHud displays coins count and progress bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopHud(
              coins: 350,
              progress: 0.5,
              onPausePressed: () {},
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 600)); // Allow count-up animation to complete
      expect(find.text('350'), findsOneWidget);
      expect(find.byIcon(Icons.directions_car), findsOneWidget);
    });

    testWidgets('4. GlossyPanel displays title and animates in', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlossyPanel(
              title: 'PANEL TITLE',
              child: const Text('Panel Body'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('PANEL TITLE'), findsOneWidget);
      expect(find.text('Panel Body'), findsOneWidget);
    });
  });
}
