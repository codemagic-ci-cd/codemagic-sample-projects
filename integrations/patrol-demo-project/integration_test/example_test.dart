import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MyApp(),
      );
      const incrementButtonKey = Key('increment_button');
      const counterTextKey = Key('counter_text');

      await $(incrementButtonKey).tap();
      await $(counterTextKey).$('1').waitUntilVisible();
      await $(incrementButtonKey).tap();
      await $(counterTextKey).$('2').waitUntilVisible();
    },
  );
}
