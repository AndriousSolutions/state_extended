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
  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  StateX stateObj = tester.firstState<AppStateX>(find.byType(MyApp));

  var conCount = 0;

  stateObj.forEach((con) {
    conCount++;
  });

  expect(conCount > 1, isTrue, reason: _location);

  var each = stateObj.forEach(reversed: true, (con) {
    conCount--;
  });

  expect(each, isTrue, reason: _location);

  expect(conCount == 0, isTrue, reason: _location);

  each = stateObj.forEach((con) {
    if (con is YetAnotherController) {
      throw Exception('Error in forEach()!');
    }
  });

  expect(each, isFalse, reason: _location);

  for (final con in stateObj.controllerList) {
    conCount++;
  }

  expect(conCount > 0, isTrue, reason: _location);

  expect(stateObj.useInherited, isTrue, reason: _location);

  StateXController? con = stateObj.controller!;

  expect(con, isA<ExampleAppController>());

  final contains = stateObj.contains(con);

  expect(contains, isTrue, reason: _location);

  // The first State object is itself --- _MyAppState
  final appState = stateObj.appStateX!;

  // Every StateMVC and ControllerMVC has a unique String identifier.
  final myAppStateId = appState.identifier;

  BuildContext context = appState.context;

  expect(context, isA<BuildContext>(), reason: _location);
  //
  // A Controller for the 'app level' to influence the whole app.
  con = appState.controller!;

  final String keyId = con.identifier;

  con = appState.controllerById(keyId)!;

  expect(con, isA<ExampleAppController>(), reason: _location);

  var id = appState.add(TestingController());

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  var remove = appState.removeByKey(id);

  expect(remove, isTrue, reason: _location);

  final TestingController testCon = TestingController();

  /// Add a controller to a State object
  appState.add(testCon);

  /// Remove a controller to a State object
  remove = appState.remove(testCon);

  expect(remove, isTrue, reason: _location);

  /// The 'state' property is the Controller's current State object
  /// it is working with.
  stateObj = con.statex!;

  /// Of course, Flutter provides a reference to the StatefulWidget
  /// thought the State object.
  StatefulWidget widget = stateObj.widget;

  expect(widget, isA<MyApp>(), reason: _location);

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  con = stateObj.firstCon;

  expect(con, isA<ExampleAppController>(), reason: _location);

  /// Returns 'the last' StateXController associated with this StateX object.
  /// Returns null if empty.
  con = stateObj.lastCon;

  expect(con, isA<AppSettingsController>(), reason: _location);

  /// Test the forEach() function encountering an error
  each = stateObj.forEach((con) {
    var state = con.firstState;
    state = con.lastState;
  });

  /// reversed
  each = stateObj.forEach((con) {
    var state = con.firstState;
    state = con.lastState;
    if (state is StateX?) {
      var overridden = state?.buildOverridden;
      overridden = state?.usingCupertino;
      overridden = state?.buildFOverridden;
      overridden = state?.builderOverridden;
    }
  }, reversed: true);

  /// Return a controller by its id in a List
  final listCon = stateObj.listControllers([keyId]);

  // Returns the most recent BuildContext/Element created in the App
  context = appState.lastState!.context;

  if (context.widget is Page1) {
    // Page 1 is currently being displayed.
    expect(context.widget, isA<Page1>(), reason: _location);
  }

  /// Call for testing coverage
  appState.dependOnInheritedWidget(context);

  con = Controller();

  // Of course, you can retrieve the State object its collected.
  // In this case, there's only one, the one in con.state.
  final StateX state01 = con.stateOf<Page1>()! as StateX;

  // print() functions called or not during development
  expect(state01.debugPrintEvents, isFalse, reason: _location);

  // Test looking up State objects by id.
  // The unique key identifier for this State object.
  final String keyIdPage1 = state01.identifier;

  // Returns the StateX object using an unique String identifiers.
  stateObj = appState.stateById(keyIdPage1)! as StateX;

  expect(stateObj.widget, isA<Page1>(), reason: _location);

  stateObj = appState.stateByType<Page1State>()!;

  expect(stateObj.widget, isA<Page1>(), reason: _location);

  /// Call for testing coverage
  stateObj.dependOnInheritedWidget(context);

  // If you know their identifiers, you can retrieve a Map of StateMVC objects.
  final Map<String, State> map =
      appState.statesById([myAppStateId, keyIdPage1]);

  // Retrieve a State object by its unique identifier.
  State? state02 = map[myAppStateId];

  // It should be a specific type of State object.
  expect(state02, isA<AppStateX>(), reason: _location);

  // It should be from a specific StatefulWidget
  expect(state02!.widget, isA<MyApp>(), reason: _location);

  // It should be a specific type of State object.
  state02 = map[keyIdPage1];

  // It should be a specific type of State object.
  expect(state02, isA<StateX>(), reason: _location);

  // It should be from a specific StatefulWidget
  expect(state02!.widget, isA<Page1>(), reason: _location);

  // Returns a List of State objects using unique String identifiers.
  final list = appState.listStates([myAppStateId, keyIdPage1]);

  state02 = list[0];

  // It should be a specific type of State object.
  expect(state02, isA<AppStateX>(), reason: _location);

  // It should be from a specific StatefulWidget
  expect(state02.widget, isA<MyApp>(), reason: _location);

  state02 = list[1];

  // It should be a specific type of State object.
  expect(state02, isA<StateX>(), reason: _location);

  // It should be from a specific StatefulWidget
  expect(state02.widget, isA<Page1>(), reason: _location);

// Unable to determine and be Web compatible.
//  // Determine if app is running in a tester
//  expect(state02.inFlutterTester, isTrue, reason: _location);

  // Determines if running in an IDE or in production.
  // Returns true if the App is under in the Debugger and not production.
  final debugging = appState.inDebugMode && con.inDebugMode;

  expect(debugging, isA<bool>(), reason: _location);

  // The State object. (con.state as StateMVC will work!)
  final _state = con.state!;

  expect(_state, isA<State>(), reason: _location);

  // Test for the unique identifier assigned to every Controller.
  id = stateObj.add(TestingController());

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
  each = stateObj.forEachStateX((state) {
    count++;
  });

  expect(count > 1, isTrue, reason: _location);

  each = stateObj.forEachStateX(reversed: true, (state) {
    count--;
  });

  expect(each, isTrue, reason: _location);

  expect(count == 0, isTrue, reason: _location);

  each = stateObj.forEachStateX((state) {
    if (state is Page1State) {
      throw AssertionError('Error in forEachState()!');
    }
  });

  expect(each, isFalse, reason: _location);

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

  widget = stateObj.widget;

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
