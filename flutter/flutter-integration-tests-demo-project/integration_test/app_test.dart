import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart';
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('No input in name field displays error validation text',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.text('Input some text!'), findsOneWidget);
  });

  testWidgets(
    'Text is entered into field and Alert is shown inclucing name entered',
    (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      final inputText = 'Kevin';
      await tester.enterText(find.byKey(Key('text-field')), inputText);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Hey, Kevin!'), findsOneWidget);

      sleep(Duration(seconds: 5));

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    },
  );
}
