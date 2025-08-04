// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_statex.dart';

Future<void> testsAppStateX(WidgetTester tester) async {
  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  AppStateX? appStateXObj = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(appStateXObj, isA<AppStateX>(), reason: _location);

  StateXController? con = appStateXObj.controller;

// This Controller's current State object is _MyAppState as AppStateMVC
  StateX? stateXObj = con?.statex;

  expect(stateXObj, isA<AppStateX>(), reason: _location);

// The first State object is itself --- _MyAppState
  appStateXObj = stateXObj?.appStateX;

  // Deprecated. Use appSateX, yet must still be tested.
  appStateXObj = stateXObj?.rootState;

  expect(appStateXObj, isA<AppStateX>(), reason: _location);

  final snapShot = appStateXObj!.snapshot!;

  expect(snapShot.data, isTrue, reason: _location);

  /// Rebuild InheritedWidget
  appStateXObj.dataObject = 'test';

  expect(appStateXObj.dataObject == 'test', isTrue, reason: _location);

  var conCount = 0;

  appStateXObj.forEach((con) {
    conCount++;
  });

  expect(conCount > 1, isTrue, reason: _location);

  var allWithNoError = appStateXObj.forEach(reversed: true, (con) {
    conCount--;
  });

  expect(allWithNoError, isTrue, reason: _location);

  expect(conCount == 0, isTrue, reason: _location);

  allWithNoError = appStateXObj.forEach((con) {
    if (con is YetAnotherController) {
      throw Exception('Error in forEach()!');
    }
  });

  expect(allWithNoError, isFalse, reason: _location);

  for (final con in appStateXObj.controllerList) {
    conCount++;
  }

  expect(conCount > 0, isTrue, reason: _location);

  expect(appStateXObj.useInherited, isTrue, reason: _location);

  con = appStateXObj.controller!;

  expect(con, isA<ExampleAppController>());

  final contains = stateXObj?.contains(con) ?? false;

  expect(contains, isTrue, reason: _location);

  // The first State object is itself --- _MyAppState
  appStateXObj = stateXObj!.appStateX!;

  // Every StateMVC and ControllerMVC has a unique String identifier.
  var myAppStateId = appStateXObj.identifier;

  var context = appStateXObj.context;

  expect(context, isA<BuildContext>(), reason: _location);

  expect(context.widget, isA<MyApp>(), reason: _location);

  // A Controller for the 'app level' to influence the whole app.
  con = appStateXObj.controller!;

  final String keyId = con.identifier;

  con = appStateXObj.controllerById(keyId)!;

  expect(con, isA<ExampleAppController>(), reason: _location);

  final id = appStateXObj.add(TestingController());

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  var remove = appStateXObj.removeByKey(id);

  expect(remove, isTrue, reason: _location);

  final TestingController testCon = TestingController();

  /// Add a controller to a State object
  appStateXObj.add(testCon);

  /// Remove a controller to a State object
  remove = appStateXObj.remove(testCon);

  expect(remove, isTrue, reason: _location);

  /// The 'state' property is the Controller's current State object
  /// it is working with.
  stateXObj = con.statex!;

  /// Of course, Flutter provides a reference to the StatefulWidget
  /// thought the State object.
  final StatefulWidget widget = stateXObj.widget;

  expect(widget, isA<MyApp>(), reason: _location);

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  con = stateXObj.firstCon;

  expect(con, isA<ExampleAppController>(), reason: _location);

  con = stateXObj.lastCon;

  expect(con, isNot(isA<ExampleAppController>()), reason: _location);

  // If you know their identifiers, you can retrieve a Map of StateMVC objects.
  final Map<String, State> map = appStateXObj.statesById([myAppStateId]);

  // Retrieve a State object by its unique identifier.
  State? stateObj = map[myAppStateId];

  // It should be a specific type of State object.
  expect(stateObj, isA<AppStateX>(), reason: _location);

  // It should be from a specific StatefulWidget
  expect(stateObj!.widget, isA<MyApp>(), reason: _location);

  stateObj = (stateObj as StateX).lastState;

  // It should be a specific type of State object.
  expect(stateObj, isA<StateX>(), reason: _location);

  // It should be from a specific StatefulWidget
  expect(stateObj!.widget, isNot(isA<MyApp>()), reason: _location);

  con = (stateObj as StateX).controller;

  expect(con, isNot(isA<ExampleAppController>()), reason: _location);

  // Test looking up State objects by id.
  // The unique key identifier for this State object.
  final String lastKey = stateObj.identifier;

  // Returns a List of State objects using unique String identifiers.
  final list = con!.listStates([myAppStateId, lastKey]);

  stateObj = list[0];

  // It should be a specific type of State object.
  expect(stateObj, isNot(isA<AppStateX>()), reason: _location);

  appStateXObj.setBuilder((context) => const SizedBox());

  appStateXObj.activate();

  await appStateXObj.didPopRoute();

  await appStateXObj.didRequestAppExit();

  // appStateXObj.didChangeViewFocus(ViewFocusEvent event);
  //
  // await appStateXObj.didPushRouteInformation(
  //             RouteInformation routeInformation);
  //
  // appStateXObj.handleStartBackGesture(PredictiveBackEvent backEvent);
  //
  // appStateXObj.handleUpdateBackGestureProgress(PredictiveBackEvent backEvent);

  appStateXObj.handleCommitBackGesture();

  appStateXObj.handleCancelBackGesture();

  final exception = Exception('Testing');

  final errorDetails = FlutterErrorDetails(
    exception: exception,
    library: 'test_statex.dart',
    context: ErrorDescription('Testing for codecov'),
  );

  appStateXObj.recordErrorInHandler(exception);

  expect(appStateXObj.hasErrorInErrorHandler, isTrue, reason: _location);

  expect(appStateXObj.recErrorMsg == 'Testing', isTrue, reason: _location);

  var ex = appStateXObj.recordErrorInHandler();

  expect(ex, isA<Exception>(), reason: _location);

  appStateXObj.onError(errorDetails);

  appStateXObj.catchError(exception);

  appStateXObj.recordErrorInHandler(FlutterError('Test Error'));

  ex = appStateXObj.recordErrorInHandler();

  expect(ex, isA<Error>(), reason: _location);

  appStateXObj.didHaveMemoryPressure();

  appStateXObj.notifyClients();

// Every StateMVC and ControllerMVC has a unique String identifier.
  myAppStateId = appStateXObj.identifier;

  expect(myAppStateId, isNotEmpty, reason: _location);

  context = appStateXObj.context;

  expect(context.widget, isA<MyApp>(), reason: _location);

  expect(context, isA<BuildContext>(), reason: _location);

// A Controller for the 'app level' to influence the whole app.
  con = appStateXObj.controller!;

  expect(con, isA<ExampleAppController>(), reason: _location);

  con = appStateXObj.controllerByType<TestingController>();

  expect(con, isNull, reason: _location);

  con = appStateXObj.controllerByType<ExampleAppController>();

  expect(con, isA<ExampleAppController>(), reason: _location);

// As well as the base class, ControllerMVC
  expect(con, isA<StateXController>(), reason: _location);

  appStateXObj.listControllers([keyId]);

  /// Switch out the 'current' controller
  final update = appStateXObj.didUpdateController(oldCon: con, newCon: con);

  expect(update, isFalse, reason: _location);

  /// You can retrieve a State object by the 'type' of its StatefulWidget
  appStateXObj = con!.stateOf<MyApp>() as AppStateX;

  expect(appStateXObj, isA<AppStateX>(), reason: _location);
}
