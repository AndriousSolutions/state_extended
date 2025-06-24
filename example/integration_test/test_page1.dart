//
import 'package:example/src/controller.dart'
    show AppSettingsController, Controller;

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_page1.dart';

Future<void> testPage1(WidgetTester tester) async {
  //
  const count = 9;

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsAtLeast(1), reason: _location);

  expect(find.byKey(const Key('Text')), findsOneWidget, reason: _location);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
    // Turn the 'Use InheritedWidget' switch on anf off
    if (cnt == 3) {
      await tester.tap(find.byKey(const Key('InheritedSwitch')));
      await tester.pumpAndSettle();
    }
    // Turn the 'Use ChangeNotifier' switch on anf off
    if (cnt == 6) {
      await tester.tap(find.byKey(const Key('ChangeNotifierSwitch')));
      await tester.pumpAndSettle();
    }
    // Invoke an error
    if (cnt == 8) {
      AppSettingsController().errorButton = true;
    }
  }

  // Successfully incremented.
  expect(find.text('0'), findsNothing, reason: _location);

  expect(find.text(count.toString()), findsAny, reason: _location);

  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  // A Singleton pattern allows for unit testing.
  Controller? con = Controller();

  // You can retrieve a State object the Controller has collected so far.
  StateX state = con.stateOf<Page2>()! as StateX;

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('Page 1 Counter')));
    await tester.pumpAndSettle();
  }

  /// This should be the 'latest' State object running in the App
  expect(state.isLastState, isTrue, reason: _location);

  /// Go to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  expect(find.text((count * 2).toString()), findsAny, reason: _location);

  state = con.statex!;

  expect(state, isA<Page1State>(), reason: _location);

  con = state.controllerByType<Controller>();

  expect(con, isA<Controller>(), reason: _location);

  String? id = con?.identifier;

  final stateXController = state.controllerById(id);

  expect(stateXController, isA<StateXController?>(), reason: _location);

  con = stateXController as Controller;

  expect(con, isA<Controller>(), reason: _location);

  final testController = TestStateController();

  // Testing the 'setState()' function called during System events.
  // Testing the activate and deactivate of this State object.
  id = state.add(testController);

  expect(id, isNotEmpty, reason: _location);

  if (!state.mounted) {
    // Should not happen, but don't trip it here regardless! gp
    expect(state.mounted, isFalse, reason: _location);
  }

  /// Explicitly test this System event
  (state as Page1State).didHaveMemoryPressure();

  // Remove the indicated controller
  final event = state.removeByKey(id);

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  state = con.stateOf<Page1>()! as StateX;

  state = con.statex!;

  expect(state.mounted, isTrue, reason: _location);

  expect(state, isA<Page1State>(), reason: _location);
}
