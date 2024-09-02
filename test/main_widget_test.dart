import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrationbuddy/main.dart';
import 'package:hydrationbuddy/providers/hydration_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Initial UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => HydrationProvider(),
        child: const MyApp(),
      ),
    );

    // Check that the initial text is displayed
    expect(find.text('Water Intake Goal: 2000 ml'), findsOneWidget);
    expect(find.text('Total Consumed: 0 ml'), findsOneWidget);
  });

  testWidgets('Adding water updates UI', (WidgetTester tester) async {
    final hydrationProvider = HydrationProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => hydrationProvider,
        child: const MyApp(),
      ),
    );

    await tester.tap(find.text('250 ml'));
    await tester.pump();

    expect(find.text('Total Consumed: 250 ml'), findsOneWidget);

    await tester.tap(find.text('500 ml'));
    await tester.pump();

    expect(find.text('Total Consumed: 750 ml'), findsOneWidget);
  });

  testWidgets('Setting a goal updates the goal text', (WidgetTester tester) async {
    final hydrationProvider = HydrationProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => hydrationProvider,
        child: const MyApp(),
      ),
    );

    // Open the Set Goal dialog
    await tester.tap(find.text('Set Goal'));
    await tester.pump();

    // Enter a new goal
    await tester.enterText(find.byType(TextField), '3000');
    await tester.tap(find.text('Set'));
    await tester.pump();

    expect(find.text('Water Intake Goal: 3000 ml'), findsOneWidget);
  });

  testWidgets('Resetting water consumption resets the UI', (WidgetTester tester) async {
    final hydrationProvider = HydrationProvider();
    hydrationProvider.addWater(500);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => hydrationProvider,
        child: const MyApp(),
      ),
    );

    await tester.tap(find.text('Reset'));
    await tester.pump();

    expect(find.text('Total Consumed: 0 ml'), findsOneWidget);
  });
}
