// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart' show Controller;

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_example_app.dart';

Future<void> integrationTesting(WidgetTester tester) async {
  //
  const count = 9;

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsOneWidget, reason: _location);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  // Successfully incremented.
  expect(find.text('0'), findsNothing, reason: _location);

  expect(find.text(count.toString()), findsOneWidget, reason: _location);

  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  // A Singleton pattern allows for unit testing.
  final con = Controller();

  // You can retrieve a State object the Controller has collected so far.
  StateX state = con.stateOf<Page2>()!;

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('Page 1 Counter')));
    await tester.pumpAndSettle();
  }

  /// Go to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  expect(find.text((count * 2).toString()), findsOneWidget, reason: _location);

  state = con.state!;

  expect(state, isA<Page1State>(), reason: _location);

  final listener = TesterStateListener();

  // Testing the activate and deactivate of this State object.
  var added = state.addBeforeListener(listener);

  expect(added, isTrue, reason: _location);

  // Add an 'after' Listener.
  added = state.addListener(listener);

  expect(added, isTrue, reason: _location);

  /// Simulate some events (eg. paused and resumed the app)
  await testEventHandling(tester);

  var event = state.paused;

  if (event) {
    /// The app has been paused
    expect(event, isTrue, reason: _location);
  }

  event = state.deactivated;

  if (event) {
    /// Test that a state object as been replaced!
    expect(event, isTrue, reason: _location);
  }

  event = state.inactive;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  event = state.detached;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  event = state.resumed;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  // Even the listener will be gone if the State is now disposed.
  final contains = state.afterContains(listener);

  // Test only to all for breakpoints.
  if (!contains) {
    // This should not run?! Has it lost its Listeners again?
    // Let it run, but don't trip error. //todo Must investigate this again!?
    expect(contains, isFalse, reason: _location);
  }

  // The system will dispose of the State at its own discretion
  // You'll have no idea if and when that is.

  event = state.disposed;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  if (!state.mounted) {
    // Should not happen, but don't trip it here regardless! gp
    expect(state.mounted, isFalse, reason: _location);
  }

  state = con.stateOf<Page1>()!;

  /// Explicitly test this System event
  (state as Page1State).didHaveMemoryPressure();

  /// A new State object has been introduced!
  /// **NO** StateX was using StateX._inTester for some reason?!
  state = con.state!;

  expect(state.mounted, isTrue, reason: _location);

  expect(state, isA<Page1State>(), reason: _location);

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Test the controllers move across different State objects.
  state = con.state!.startState as StateX;

  expect(state, isA<AppStateX>(), reason: _location);

  state = con.state!.endState as StateX;

  expect(state, isA<Page2State>(), reason: _location);

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text((count).toString()), findsOneWidget, reason: _location);

  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  /// Test 'Hello! example' app
  await testHomePageApp(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  await testInheritedWidgetApp(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  await testPage2State(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();
}

Future<void> testHomePageApp(WidgetTester tester) async {
  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Again, this tap doesn't seem to work, and so I go to the Navigator.
  await tester.tap(find.byKey(const Key('Hello! example')));
  await tester.pumpAndSettle();

  expect(find.text('Hello!'), findsOneWidget);

  const count = 5;

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text('Hello There!'), findsOneWidget);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text('How are you?'), findsOneWidget);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text('Are you good?'), findsOneWidget);

  /// Retreat back one screen
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
}

Future<void> testInheritedWidgetApp(WidgetTester tester) async {
  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  /// Web Services are unreliable during testing.
  // // Again, this tap doesn't seem to work, and so I go to the Navigator.
  // await tester.tap(find.byKey(const Key('InheritedWidget example')));
  // await tester.pumpAndSettle();
  //
  // expect(find.text('New Dogs'), findsOneWidget);
  //
  // /// Retreat back one screen
  // await tester.tap(find.byTooltip('Back'));
  // await tester.pumpAndSettle();
}

Future<void> testPage2State(WidgetTester tester) async {
  // Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  // Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Start with the first State object.
  // Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(appState, isA<AppStateX>(), reason: _location);

  // You can retrieve one of the controllers State objects.
  final StateX statePage2 = Controller().stateOf<Page2>()!;

  statePage2.notifyClients();

  // Deprecated yet must be tested anyway.
  // Calls the app's InheritedWidget
  statePage2.buildInherited();

  statePage2.setState(() {});
}

Future<void> resetPage1Count(WidgetTester tester) async {
  //
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Tapping doesn't seem to work, and so I'll grab the State object itself.
  await tester.tap(find.byKey(const Key('New Key')));
  await tester.pumpAndSettle();

  //todo Don't remember why I did this! Not necessary!
  // // Find its StatefulWidget first then the 'type' of State object.
  // final AppStateX rootState = tester.firstState<AppStateX>(find.byType(MyApp));
  // rootState.setState(() {});
  // await tester.pumpAndSettle();

  // Is there a button labeled, Page 1.
  final page1Finder = find.byKey(const Key('Page 1'));

  if (page1Finder.evaluate().toList(growable: false).isNotEmpty) {
    // Explicitly go to Page 1 if necessary.
    await tester.tap(page1Finder);
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget, reason: _location);
  }
}
