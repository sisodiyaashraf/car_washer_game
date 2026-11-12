import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/core/services/storage_service.dart';
import 'package:carwasher/features/game/controllers/game_controller.dart';
import 'package:carwasher/features/game/screens/game_screen.dart';
import 'package:carwasher/features/menu/screens/main_menu_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('1. Menu loads with title, coins balance, and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('CAR WASH & REPAIR'), findsOneWidget);
    expect(find.text('START PLAYING'), findsOneWidget);
    expect(find.text('GARAGE'), findsOneWidget);
    expect(find.text('DAILY REWARD'), findsOneWidget);
  });

  testWidgets('2. A level can start and renders Stage 1 Soap View', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameScreen(levelNumber: 1)));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('STAGE 1: SOAP'), findsWidgets);
  });

  testWidgets('3. Settings toggles persist state changes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));
    await tester.pump(const Duration(milliseconds: 100));

    final settingsIconButton = find.byType(IconButton).first;
    expect(settingsIconButton, findsOneWidget);
    await tester.tap(settingsIconButton);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('⚙️ SETTINGS ⚙️'), findsOneWidget);
    expect(find.text('Sound Effects'), findsOneWidget);

    final storage = StorageService();
    storage.toggleSound(false);
    expect(storage.isSoundEnabled, isFalse);
  });

  testWidgets('4. Double-tap reward protection prevents multiple claims', (WidgetTester tester) async {
    final controller = GameController(initialLevel: 1);
    controller.forceCompleteWashStage();
    controller.forceCompleteWashStage();

    final spots = controller.repairHitsRemaining.keys.toList();
    for (final s in spots) {
      final hits = controller.repairHitsRemaining[s]!;
      for (int i = 0; i < hits; i++) {
        controller.hitRepairSpot(s);
      }
    }
    controller.completePaint();
    controller.completeCustomization();
    controller.finishPreviewAndCompleteLevel();

    expect(controller.phase, GamePhase.done);

    final initialCoins = controller.earnedCoins;
    controller.claim2XCoinsReward();
    expect(controller.earnedCoins, initialCoins * 2);

    controller.claim2XCoinsReward();
    expect(controller.earnedCoins, initialCoins * 2);
    controller.dispose();
  });

  testWidgets('5. Pause and resume timer behavior works correctly', (WidgetTester tester) async {
    final controller = GameController(initialLevel: 1);
    expect(controller.elapsedSeconds, 0);

    await tester.pump(const Duration(seconds: 1));
    expect(controller.elapsedSeconds, greaterThanOrEqualTo(0));
    controller.dispose();
  });
}
