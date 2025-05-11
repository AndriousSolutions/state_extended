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
  AppStateX? appState = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(appState, isA<AppStateX>(), reason: _location);

  StateXController? con = appState.controller;

// This Controller's current State object is _MyAppState as AppStateMVC
  final StateX? stateObj = con?.state;

  expect(stateObj, isA<AppStateX>(), reason: _location);

// The first State object is itself --- _MyAppState
  appState = stateObj?.appStateX;

  expect(appState, isA<AppStateX>(), reason: _location);

  final snapShot = appState!.snapshot!;

  expect(snapShot.data, isTrue, reason: _location);

  /// Rebuild InheritedWidget
  appState.dataObject = 'test';

  appState.setBuilder((context) => const SizedBox());

  final exception = Exception('Testing');

  final errorDetails = FlutterErrorDetails(
    exception: exception,
    library: 'test_statex.dart',
    context: ErrorDescription('Testing for codecov'),
  );

  appState.recordException(exception);

  expect(appState.recHasError, isTrue, reason: _location);

  expect(appState.recErrorMsg == 'Testing', isTrue, reason: _location);

  expect(appState.recStackTrace, isNull, reason: _location);

  var ex = appState.recordException();

  expect(ex, isA<Exception>(), reason: _location);

  appState.onError(errorDetails);

  appState.catchError(exception);

  appState.recordException(FlutterError('Test Error'));

  ex = appState.recordException();

  expect(ex, isA<Error>(), reason: _location);

  appState.didHaveMemoryPressure();

  appState.notifyClients();

// Every StateMVC and ControllerMVC has a unique String identifier.
  final myAppStateId = appState.identifier;

  expect(myAppStateId, isNotEmpty, reason: _location);

  final context = appState.context;

  expect(context, isA<BuildContext>(), reason: _location);

// A Controller for the 'app level' to influence the whole app.
  con = appState.controller!;

  expect(con, isA<ExampleAppController>(), reason: _location);

  final String keyId = con.identifier;

  con = appState.controllerById(keyId)!;

  expect(con, isA<ExampleAppController>(), reason: _location);

  con = appState.controllerByType<TestingController>();

  expect(con, isNull, reason: _location);

  con = appState.controllerByType<ExampleAppController>();

  expect(con, isA<ExampleAppController>(), reason: _location);

// As well as the base class, ControllerMVC
  expect(con, isA<StateXController>(), reason: _location);

  final id = appState.add(TestingController());

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  var remove = appState.removeByKey(id);

  expect(remove, isTrue, reason: _location);

  final TestingController testCon = TestingController();

  /// Add a controller to a State object
  appState.add(testCon);

  /// Remove a controller to a State object
  remove = appState.remove(testCon);

  expect(remove, isTrue, reason: _location);

  /// Test listControllers
  appState.listControllers([keyId]);

  /// Switch out the 'current' controller
  final update = appState.didUpdateController(oldCon: con, newCon: con);

  expect(update, isFalse, reason: _location);

  /// You can retrieve a State object by the 'type' of its StatefulWidget
  appState = con!.stateOf<MyApp>() as AppStateX;

  expect(appState, isA<AppStateX>(), reason: _location);
}
