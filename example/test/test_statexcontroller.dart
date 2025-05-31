// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

const location = '========================== test_controller.dart';

void testsStateXController(WidgetTester tester) {
  //

  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  AppStateX appState = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(appState.widget, isA<MyApp>());

  /// Returns the unique identifier assigned to the Controller object.
  /// Unnecessary. Merely demonstrating an alternative to 'adding' a
  /// Controller object to a StatMVC object.
  /// In fact, it's already there and will merely return its assigned id.
  String conId = appState.add(Controller());

  expect(conId, isA<String>(), reason: location);

  Controller con = appState.controllerById(conId) as Controller;

  expect(con, isA<Controller>(), reason: location);

  /// Do the reverse, test 'adding' a State object to a Controller.
  conId = con.addState(appState);

  expect(conId, equals(appState.identifier), reason: location);

  /// null testing
  conId = appState.add(null);

  expect(conId, isEmpty);

  appState = con.appStateX!;

  expect(appState, isA<AppStateX>(), reason: location);

  con = Controller();

  String keyId = con.identifier;

  con = appState.controllerById(keyId) as Controller;

  expect(con, isA<Controller>(), reason: location);

  final List<String> keyIds = appState.addList([Controller()]);

  expect(keyIds, isNotEmpty, reason: location);

  con = appState.controllerById(keyIds[0]) as Controller;

  expect(con, isA<Controller>(), reason: location);

  /// Even the 'first' State object has a reference to itself
  appState = appState.appStateX!;

  expect(appState.widget, isA<MyApp>(), reason: location);

  /// Returns the most recent BuildContext/Element created in the App
  final BuildContext context = con.state!.lastState!.context;

  expect(context.widget, isA<Page1>(), reason: location);

  /// Call for testing coverage
  con.dependOnInheritedWidget(context);

  /// Test AppController class
  _testAppController(tester);

  /// This State object 'contains' this Controller.
  var another = AnotherController();

  keyId = another.identifier;

  another = appState.controllerById(keyId) as AnotherController;

  expect(another, isA<AnotherController>(), reason: location);

  /// This State object 'contains' this Controller.
  var andAnother = YetAnotherController();

  keyId = andAnother.identifier;

  andAnother = appState.controllerById(keyId) as YetAnotherController;

  expect(andAnother, isA<YetAnotherController>(), reason: location);

  con = Controller();

  conId = con.identifier;

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by its key id Note the casting.
  con = appState.controllerById(conId) as Controller;

  expect(con, isA<Controller>(), reason: location);

  // The Set of State objects
//  con.states; // Deprecated

  // Continuing the testing coverage
  con.notifyClients();

  // Loop through the Controller's State objects
  con.forEachState((state) {
    for (final c in state.controllerList) {
      if (c == con) {
      } else {}
    }
  });

  // Loop through the Controller's State objects in reverse
  con.forEachState((state) {
    if (state.mounted) {}
  }, reversed: true);
}

void _testAppController(WidgetTester tester) {
  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  final StateX appState = tester.firstState<AppStateX>(find.byType(MyApp));

  /// The first Controller added to the App's first State object
  final controller = appState.appCon;

  expect(controller, isA<ExampleAppController>());

  // ignore: unused_local_variable
  final rootCon = controller as ExampleAppController;
}
