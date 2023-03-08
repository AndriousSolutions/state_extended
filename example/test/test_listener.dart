// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';
import 'package:flutter/foundation.dart';

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

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    //ignore: avoid_print
    print('############ Event: activate in TesterStateListener');
  }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @override
  void deactivate() {
    //ignore: avoid_print
    print('############ Event: deactivate in TesterStateListener');
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  @override
  void dispose() {
    //ignore: avoid_print
    print('############ Event: pausedLifecycleState in TesterStateListener');
    super.dispose();
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    //ignore: avoid_print
    print('############ Event: pausedLifecycleState in TesterStateListener');
  }

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {
    //ignore: avoid_print
    print('############ Event: resumedLifecycleState in TesterStateListener');
  }

  /// The application is in an inactive state and is not receiving user input.
  @override
  void inactiveLifecycleState() {
    //ignore: avoid_print
    print('############ Event: inactiveLifecycleState in TesterStateListener');
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {
    //ignore: avoid_print
    print('############ Event: detachedLifecycleState in TesterStateListener');
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resumed
    //ignore: avoid_print
    print('############ Event: detachedLifecycleState in TesterStateListener');
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async {
    if (kDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPopRoute in TesterStateListener');
    }
    return super.didPopRoute();
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  @override
  Future<bool> didPushRoute(String route) async {
    if (kDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPushRoute in TesterStateListener');
    }
    return super.didPushRoute(route);
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    if (kDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didPushRouteInformation in TesterStateListener');
    }
    return super.didPushRouteInformation(routeInformation);
  }

  /// **IMPORTANT**
  /// After this change the current State is destroyed.
  /// It is unmounted and new State object is created!
  /// Implement updateNewStateX() to update the new State object of its specific properties.
  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    if (kDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeMetrics in TesterStateListener');
    }
  }

  /// **IMPORTANT**
  /// After this change the current State is destroyed.
  /// It is unmounted and new State object is created!
  /// Implement updateNewStateX() to update the new State object of its specific properties.
  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    if (kDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeTextScaleFactor in TesterStateListener');
    }
  }

  /// **IMPORTANT**
  /// After this change the current State is destroyed.
  /// It is unmounted and new State object is created!
  /// Implement updateNewStateX() to update the new State object of its specific properties.
  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    if (kDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangePlatformBrightness in TesterStateListener');
    }
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) {
    if (kDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeLocale in TesterStateListener');
    }
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    if (kDebugMode) {
      //ignore: avoid_print
      print('############ Event: didHaveMemoryPressure in TesterStateListener');
    }
  }

  /// **IMPORTANT**
  /// After this change the current State is destroyed.
  /// It is unmounted and new State object is created!
  /// Implement updateNewStateX() to update the new State object of its specific properties.
  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    // inDebugger is deprecated but still tested here. Use inDebugMode instead.
    if (kDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeAccessibilityFeatures in TesterStateListener');
    }
  }
}
