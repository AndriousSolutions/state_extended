// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

//
const _location = '========================== test_listener.dart';

/// Introduce State Listeners for the testing.
Future<void> testsStateListener(WidgetTester tester) async {
  //
  // Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(appState.widget, isA<MyApp>());

  final con = Controller();

  // Of course, you can retrieve the State object its currently collected.
  // In this case, there's only one, the one in con.state.
  final StateX state = con.stateOf<Page1>()!;

  final listener = TesterStateListener();

  final id = listener.identifier;

  // Testing the Adding of Listeners to a State object
  final added = state.addBeforeListener(listener);

  expect(added, isTrue, reason: _location);

  // Test for 'Before' Listener has been added.
  var contains = state.beforeContains(listener);

  expect(contains, isTrue, reason: _location);

  // Add an 'after' Listener.
  state.addAfterListener(listener);

  // Test for 'After' Listener has been added.
  contains = state.afterContains(listener);

  expect(contains, isTrue, reason: _location);

  final add = state.addListener(listener);

  // Should be false as it's already an 'after listener.'
  expect(add, isFalse, reason: _location);

  var stateListener = state.beforeListener(id);

  stateListener = state.afterListener(id)!;

  expect(stateListener, isA<TesterStateListener>(), reason: _location);

  stateListener = con.beforeListener(id);

  expect(stateListener, isA<TesterStateListener>(), reason: _location);

  stateListener = con.afterListener(id);

  expect(stateListener, isA<TesterStateListener>(), reason: _location);

  var list = state.beforeList([id]);

  expect(list, isNotEmpty, reason: _location);

  list = state.afterList([id]);

  expect(list, isNotEmpty, reason: _location);

  final remove = state.removeListener(listener);

  expect(remove, isTrue, reason: _location);

  list = state.beforeList([id]);

  expect(list, isEmpty, reason: _location);

  list = state.afterList([id]);

  expect(list, isEmpty, reason: _location);
}

/// A 'listener' for testing.
class TesterStateListener with StateListener {
  factory TesterStateListener() => _this ??= TesterStateListener._();
  TesterStateListener._();
  static TesterStateListener? _this;
}
