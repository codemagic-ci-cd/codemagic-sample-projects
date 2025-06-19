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

      // This is just a simple example of Patrol's capabilities.
      // Patrol offers powerful native integration testing features:
      // - Native UI interactions and permissions handling
      // - Cross-platform testing on both Android and iOS
      // Learn more at https://patrol.leancode.co/
    },
  );
}
