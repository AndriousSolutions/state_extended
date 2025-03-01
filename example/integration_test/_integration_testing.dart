// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart' show Controller;

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_example_app.dart';

///
Future<void> integrationTesting(WidgetTester tester) async {
  //
  await testPage1(tester);

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  StateX state;

  // A Singleton pattern allows for unit testing.
  final Controller? con = Controller();

  // Test the controllers move across different State objects.
  state = con?.state!.firstState as StateX;

  expect(state, isA<AppStateX>(), reason: _location);

  state = con?.state!.lastState as StateX;

  expect(state, isA<Page2State>(), reason: _location);

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  const count = 9;

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text((count).toString()), findsOneWidget, reason: _location);

  await testInheritedWidgetApp(tester);

  await testPage2State(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();
}
