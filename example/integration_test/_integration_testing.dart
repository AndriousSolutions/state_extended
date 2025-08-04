// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_example_app.dart';

///
Future<void> integrationTesting(WidgetTester tester) async {
  // A Singleton pattern allows for unit testing.
  final Controller con = Controller();

  // You can retrieve a State object the Controller has collected so far.
  StateX state = con.stateOf<Page1>()! as StateX;

  /// State object's first build or will be its first build
  expect(con.statex!.firstBuild, isTrue, reason: _location);

  // Remove the Debug Banner
  DevTools().debugShowCheckedModeBanner = false;
  con.appStateX?.setState(() {});
  await tester.pumpAndSettle(const Duration(seconds: 1));

  //
  await testPage1(tester);

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Test the controllers move across different State objects.
  state = con.statex!.firstState as StateX;

  expect(state, isA<AppStateX>(), reason: _location);

  state = con.statex!.lastState as StateX;

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

  /// A flag. Noting if the function setBuilder() used.
  /// Widget setBuilder(MaybeBuildWidgetType? builder)
  expect(con.setBuilderUsed, isTrue, reason: _location);

  expect(find.text((count).toString()), findsOneWidget, reason: _location);

  await testInheritedWidgetApp(tester);

  await testPage2State(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();
}
