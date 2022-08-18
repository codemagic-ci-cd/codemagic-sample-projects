import 'dart:io';

import 'package:codemagic_demo/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:codemagic_demo/main.dart' as app;

void main() {
  // MyApp()
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      sleep(const Duration(seconds: 2));
      // Verify the counter starts at 0.
      expect(find.text('Codemagic Demo'), findsOneWidget);

      sleep(const Duration(seconds: 2));

      // Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Increment');

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);

      // Finds the floating action button to tap on.
      final Finder fabMin = find.byTooltip('Decrement');

      // Emulate a tap on the floating action button.
      await tester.tap(fabMin);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('0'), findsOneWidget);
    });
  });
}
