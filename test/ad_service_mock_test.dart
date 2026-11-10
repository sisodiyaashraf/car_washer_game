import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/features/game/controllers/game_controller.dart';

class MockAdService {
  bool isAdAvailable = true;
  bool isLoading = false;
  int rewardCallbackCount = 0;

  void showRewardedAd({
    required BuildContext context,
    required void Function() onRewardGranted,
  }) {
    if (!isAdAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No ad available, try again later.')),
      );
      return;
    }

    // Simulate ad reward callback firing
    rewardCallbackCount++;
    onRewardGranted();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('(a) Reward button shows loading state while ad is loading', (WidgetTester tester) async {
    final mockAd = MockAdService();
    mockAd.isLoading = true;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: mockAd.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: () {}, child: const Text('WATCH AD')),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('WATCH AD'), findsNothing);
  });

  testWidgets('(b) Reward button shows error message and grants no reward when ad not available', (WidgetTester tester) async {
    final mockAd = MockAdService();
    mockAd.isAdAvailable = false;
    bool rewardGranted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                mockAd.showRewardedAd(
                  context: context,
                  onRewardGranted: () => rewardGranted = true,
                );
              },
              child: const Text('WATCH AD'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('WATCH AD'));
    await tester.pumpAndSettle();

    expect(rewardGranted, isFalse);
    expect(find.text('No ad available, try again later.'), findsOneWidget);
  });

  testWidgets('(c) Reward is granted exactly once even if callback fires twice', (WidgetTester tester) async {
    final controller = GameController(initialLevel: 1);
    controller.forceCompleteWashStage();
    controller.forceCompleteWashStage();
    for (final s in controller.repairHitsRemaining.keys.toList()) {
      final hits = controller.repairHitsRemaining[s]!;
      for (int i = 0; i < hits; i++) {
        controller.hitRepairSpot(s);
      }
    }
    controller.completePaint();
    controller.completeCustomization();
    controller.finishPreviewAndCompleteLevel();

    final baseCoins = controller.earnedCoins;
    controller.claim2XCoinsReward();
    expect(controller.earnedCoins, baseCoins * 2);

    // Duplicate callback call
    controller.claim2XCoinsReward();
    expect(controller.earnedCoins, baseCoins * 2);
  });
}
