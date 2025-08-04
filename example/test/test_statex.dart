// ignore_for_file: unused_local_variable
// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_statex.dart';

Future<void> testsStateX(WidgetTester tester) async {
  /// Find this app's first State object.
  StateX? stateObj = tester.firstState<AppStateX>(find.byType(MyApp));

  stateObj = stateObj.stateByType<Page1State>();

  stateObj = stateObj?.ofState<Page1State>();

  // It should be from a specific StatefulWidget
  expect(stateObj!.widget, isA<Page1>(), reason: _location);

  StateXController? con = stateObj.controller;

  expect(con, isA<Controller>(), reason: _location);

  /// Returns 'the last' StateXController associated with this StateX object.
  /// Returns null if empty.
  con = stateObj.lastCon;

  expect(con, isNot(isA<Controller>()), reason: _location);

  var conCount = 0;

  /// Test the forEach() function encountering an error
  var allWithNoError = stateObj.forEach((con) {
    conCount++;
  });

  expect(conCount > 1, isTrue, reason: _location);

  /// In reverse
  allWithNoError = stateObj.forEach((con) {
    conCount--;
  }, reversed: true);

  expect(conCount == 0, isTrue, reason: _location);

  /// Return a controller by its id in a List
  final listCon = stateObj.listControllers([stateObj.identifier]);

  // Returns the most recent BuildContext/Element created in the App
  var context = stateObj.lastState!.context;

  if (context.widget is Page1) {
    // Page 1 is currently being displayed.
    expect(context.widget, isA<Page1>(), reason: _location);
  }

  con = Controller();

  // Of course, you can retrieve the State object its collected.
  // In this case, there's only one, the one in con.state.
  final StateX state01 = con.stateOf<Page1>()! as StateX;

  // print() functions called or not during development
  expect(state01.printEvents, isTrue, reason: _location);

  // The State object. (con.state as StateMVC will work!)
  final _state = con.state!;

  expect(_state, isA<State>(), reason: _location);

  // Test for the unique identifier assigned to every Controller.
  var id = stateObj.add(TestingController());

  expect(id, isNotEmpty, reason: _location);

  try {
    // Attempt to add the same controller again. (Not factory constructor)
    stateObj.add(TestingController());
    //ignore: avoid_catching_errors
  } on AssertionError catch (e) {
    // Ignore the error. It was anticipated.
    if (!e.message
        .toString()
        .contains('Multiple instances of the same Controller class')) {
      rethrow;
    }
  }

  var hasController = stateObj.containsType<TestingController>();

  expect(hasController, isTrue, reason: _location);

  hasController = stateObj.contains(TestingController());

  expect(hasController, isFalse, reason: _location);

  /// Returns the list of 'Controllers' but you must know their keys.
  final theController = stateObj.listControllers([id]);

  expect(theController, isNotEmpty, reason: _location);

  final keyList = stateObj.addAll(null);

  expect(keyList, isEmpty, reason: _location);

  final removed = stateObj.removeByKey(id);

  expect(removed, isTrue, reason: _location);

  // It's been removed. Returns null
  final noController = stateObj.controllerByType<TestingController>();

  expect(noController, isNull, reason: _location);

  // Is the widget mounted?
  final mounted = stateObj.mounted;

  expect(mounted, isTrue, reason: _location);

  // The previous State object is now unmounted.
  stateObj = con.stateOf<Page1>()! as StateX;

  var count = 0;

  // Test forEachState
  allWithNoError = con.forEachStateX((state) {
    count++;
  });

  expect(count > 0, isTrue, reason: _location);

  allWithNoError = con.forEachStateX(reversed: true, (state) {
    count--;
  });

  expect(allWithNoError, isTrue, reason: _location);

  expect(count == 0, isTrue, reason: _location);

  allWithNoError = con.forEachStateX((state) {
    if (state is Page1State) {
      throw AssertionError('Error in forEachState()!');
    }
  });

  expect(allWithNoError, isFalse, reason: _location);

  final testController = TestStateController();

  id = state01.add(testController);

  expect(id, isNotEmpty, reason: _location);

  hasController = stateObj.contains(testController);

  expect(hasController, isTrue, reason: _location);

  final boolean = await stateObj.didPopRoute();

  expect(boolean, isA<bool>(), reason: _location);

//  await stateObj.didPushRouteInformation(RouteInformation());

  stateObj.didPopNext();

  stateObj.didPush();

  stateObj.didPop();

  stateObj.didPushNext();

  // Remove the indicated controller
  expect(state01.removeByKey(id), isTrue, reason: _location);

  final widget = stateObj.widget;

  stateObj.didUpdateWidget(widget);

  context = stateObj.context;

  final locale = Localizations.localeOf(context);

  /// Called when the app's Locale changes
  stateObj.didChangeLocales([locale]);

  /// Return the 'first' controller
  final controller = stateObj.appCon;

  expect(controller, isA<ExampleAppController>(), reason: _location);

  final debug = stateObj.inDebugMode;

  expect(debug, isA<bool>(), reason: _location);

  stateObj.didUpdateWidget(widget);

  /// null testing
  stateObj.add(null);

  stateObj.setState(() {});

  // Unit test function
  await stateObj.didRequestAppExit();
}

/// Merely a 'tester' Controller used in the function above.
class TestingController extends StateXController {
  /// No factory to test multiple attempts of add a Controller to StateX
  // factory TestingController() => _this ??= TestingController._();
  // TestingController._();
  // static TestingController? _this;
}
