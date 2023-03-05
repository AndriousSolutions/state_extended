// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

const _location = '========================== test_statex.dart';

Future<void> testsStateX(WidgetTester tester) async {
  //

  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  StateX stateObj = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(stateObj, isA<AppStateX>(), reason: _location);

  var conCount = 0;

  stateObj.forEach((con) {
    conCount++;
  });

  expect(conCount > 1, isTrue, reason: _location);

  stateObj.forEach(reversed: true, (con) {
    conCount--;
  });

  expect(conCount == 0, isTrue, reason: _location);

  StateXController? con = stateObj.controller!;

  expect(con, isA<AppController>());

  // This Controller's current State object is _MyAppState as AppStateMVC
  stateObj = con.state!;

  expect(stateObj, isA<AppStateX>(), reason: _location);

  // The first State object is itself --- _MyAppState
  AppStateX appState = stateObj.rootState!;

  expect(appState, isA<AppStateX>(), reason: _location);

  /// Rebuild InheritedWidget
  appState.inheritedNeedsBuild('Test');

  final exception = Exception('Testing');

  // Test its if statement.
  appState.catchError(exception);

  appState.recordException(exception);

  expect(appState.hasError, isTrue, reason: _location);

  expect(appState.errorMsg == 'Testing', isTrue, reason: _location);

  expect(appState.stackTrace, isNull, reason: _location);

  appState.setState(() {});

  // Test 'refresh' alternative
  appState.notifyClients();
  appState.buildInherited();

  // Every StateMVC and ControllerMVC has a unique String identifier.
  final myAppStateId = appState.identifier;

  BuildContext context = appState.context;

  expect(context, isA<BuildContext>(), reason: _location);

  // A Controller for the 'app level' to influence the whole app.
  con = appState.controller!;

  expect(con, isA<AppController>(), reason: _location);

  final String keyId = con.identifier;

  con = appState.controllerById(keyId)!;

  expect(con, isA<AppController>(), reason: _location);

  // Deprecated by must still be tested.
  con = appState.controllerByType<TestingController>();

  expect(con, isNull, reason: _location);

  con = appState.controllerByType<AppController>();

  expect(con, isA<AppController>(), reason: _location);

  // As well as the base class, ControllerMVC
  expect(con, isA<StateXController>(), reason: _location);

  // You can retrieve a State object by the 'type' of its StatefulWidget
  appState = con!.stateOf<MyApp>() as AppStateX;

  expect(appState, isA<AppStateX>(), reason: _location);

  if (appState.inheritedType is InheritedWidget) {
    // Return the type of 'Inherited Widget' used.
    expect(appState.inheritedType, isA<InheritedWidget>(), reason: _location);
  }

  // Testing for Test Coverage. It's the true setState() function for appState
  appState.setSuperState(() {});

  // The 'state' property is the Controller's current State object
  // it is working with.
  stateObj = con.state!;

  // Of course, Flutter provides a reference to the StatefulWidget
  // thought the State object.
  StatefulWidget widget = stateObj.widget;

  expect(widget, isA<MyApp>(), reason: _location);

  // Returns the most recent BuildContext/Element created in the App
  context = appState.endState!.context;

  if (context.widget is Page1) {
    // Page 1 is currently being displayed.
    expect(context.widget, isA<Page1>(), reason: _location);
  }

  if (context.widget is HomePage) {
    // MyHomePage is currently being displayed.
    expect(context.widget, isA<HomePage>(), reason: _location);
  }

  // Deprecated but must still be tested.
  stateObj = appState.lastState! as StateX;

  expect(stateObj, isA<Page1State>(), reason: _location);

  stateObj = appState.lastStateX!;

  expect(stateObj, isA<Page1State>(), reason: _location);

  // We know Controller's current State object is _MyHomePageState
  stateObj = con.state!;

  // This is confirmed by testing for its StatefulWidget
  expect(stateObj.widget, isA<MyApp>(), reason: _location);

  /// Call for testing coverage
  appState.dependOnInheritedWidget(context);

  con = Controller();

  // Of course, you can retrieve the State object its collected.
  // In this case, there's only one, the one in con.state.
  final StateX state = con.stateOf<Page1>()!;

  // Test looking up State objects by id.
  // The unique key identifier for this State object.
  final String keyIdPage1 = state.identifier;

  // Returns the StateMVC object using an unique String identifiers.
  stateObj = appState.stateById(keyIdPage1)!;

  expect(stateObj.widget, isA<Page1>(), reason: _location);

  stateObj = appState.stateByType<Page1State>()!;

  expect(stateObj.widget, isA<Page1>(), reason: _location);

  // If you know their identifiers, you can retrieve a Map of StateMVC objects.
  final Map<String, StateX> map =
      appState.statesById([myAppStateId, keyIdPage1]);

  // Retrieve a State object by its unique identifier.
  StateX? state02 = map[myAppStateId];

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

  // Returns a List of StateView objects using unique String identifiers.
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

  // Determine if app is running in a tester
  expect(state02.inFlutterTester, isTrue, reason: _location);

  // Determines if running in an IDE or in production.
  // Returns true if the App is under in the Debugger and not production.
  final debugging = appState.inDebugMode && con.inDebugMode;

  expect(debugging, isA<bool>(), reason: _location);

  // The State object. (con.state as StateMVC will work!)
  final _state = con.state!;

  expect(_state, isA<State>(), reason: _location);

  // Test for the unique identifier assigned to every Controller.
  final id = stateObj.add(TestingController());

  expect(id, isNotEmpty, reason: _location);

  final keyList = stateObj.addList(null);

  expect(keyList, isEmpty, reason: _location);

  final removed = stateObj.removeByKey(id);

  expect(removed, isTrue, reason: _location);

  // Is the widget mounted?
  final mounted = stateObj.mounted;

  expect(mounted, isTrue, reason: _location);

  // The previous State object is now unmounted.
  stateObj = con.stateOf<Page1>()!;

  var count = 0;

  stateObj.forEachState((state) {
    count++;
  });

  expect(count > 1, isTrue, reason: _location);

  stateObj.forEachState(reversed: true, (state) {
    count--;
  });

  expect(count == 0, isTrue, reason: _location);

  /// Usually you would call this function on a subclass of StateMVC
  /// We're testing the very class, StateMVC, itself and so the warning if fine:
  /// The member 'xxxxxxx' can only be used within instance members
  /// of subclasses of 'package:state_extended/state_extended.dart'.
  bool? boolean = await stateObj.didPopRoute();

  expect(boolean, isA<bool>(), reason: _location);

  final String path = WidgetsBinding.instance.window.defaultRouteName;

  boolean =
      await stateObj.didPushRouteInformation(RouteInformation(location: path));

  expect(boolean, isA<bool>(), reason: _location);

  boolean = await stateObj.didPushRoute('/');

  expect(boolean, isA<bool>(), reason: _location);

  widget = stateObj.widget;

  stateObj.didUpdateWidget(widget);

  context = stateObj.context;

  final locale = Localizations.localeOf(context);

  /// Called when the app's Locale changes
  stateObj.didChangeLocale(locale);

  /// Called when the returning from another app.
  stateObj.didChangeAppLifecycleState(AppLifecycleState.resumed);

  stateObj.reassemble();

  stateObj.deactivate();

  stateObj.didChangeMetrics();

  stateObj.didChangeTextScaleFactor();

  stateObj.didChangePlatformBrightness();

  stateObj.didHaveMemoryPressure();

  stateObj.didChangeAccessibilityFeatures();

  /// Testing the Life-cycle Event Handling
  final controller = stateObj.rootCon;

  expect(controller, isA<Controller>(), reason: _location);

  final debug = stateObj.inDebugMode;

  expect(debug, isA<bool>(), reason: _location);

  boolean = await stateObj.didPushRouteInformation(RouteInformation(
      location: WidgetsBinding.instance.window.defaultRouteName));

  expect(boolean, isFalse, reason: _location);

  stateObj.didUpdateWidget(widget);

  /// Simulate a reinsertion into the Widget tree
  stateObj.activate();

  /// Called when the app is inactive.
  stateObj.didChangeAppLifecycleState(AppLifecycleState.inactive);

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  stateObj.didChangeAppLifecycleState(AppLifecycleState.paused);

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  stateObj.didChangeAppLifecycleState(AppLifecycleState.detached);

  /// Called when the returning from another app.
  stateObj.didChangeAppLifecycleState(AppLifecycleState.resumed);

  stateObj.didChangeDependencies();

  /// null testing
  stateObj.add(null);

  stateObj.setState(() {});
}

/// Merely a 'tester' Controller used in the function above.
class TestingController extends StateXController {
  factory TestingController() => _this ??= TestingController._();
  TestingController._();
  static TestingController? _this;
}
