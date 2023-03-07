// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

/// The 'App Level' Controller
class AppController extends StateXController {
  /// Singleton design pattern is best for Controllers.
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  Future<bool> initAsync() async {
    // Simply wait for 10 seconds at startup.
    /// In production, this is where databases are opened, logins attempted, etc.
    return Future.delayed(const Duration(seconds: 10), () {
      return true;
    });
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  @override
  void onAsyncError(FlutterErrorDetails details) {}

  /// Return true when the App is passed true to throw errors.
  bool get tripError {
    if (_tripError == null) {
      final appWidget = state?.rootState?.widget;
      var trip = appWidget != null && appWidget is MyApp;
      if (trip) {
        trip = appWidget.throwErrors ?? false;
      }
      _tripError = trip;
    }
    return _tripError!;
  }

  /// Set whether to allow for errors.
  set tripError(bool? trip) {
    if (trip != null) {
      _tripError = trip;
    }
  }

  // Store the boolean allowing for errors or not.
  bool? _tripError;

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  void initState() {
    super.initState();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: initState in Controller');
    }
  }

  /// The framework calls this method whenever this [StateX] object is closed.
  @override
  void deactivate() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: deactivate in AppController');
    }
  }

  /// Called when this object was [deactivate].
  /// Rarely actually called but good to have since was deactivated.
  /// You may have to undo what was done in [deactivate].
  /// It was removed from the widget tree for some reason but re-inserted again.
  @override
  void activate() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: activate in AppController');
    }
  }

  /// The framework calls this method when this [StateX] object will be garbage collected
  /// Note: YOU HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  /// USE [deactivate] for time critical operations.[dispose] for light cleanup.
  @override
  void dispose() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: dispose in AppController');
    }
    super.dispose();
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: pausedLifecycleState in AppController');
    }
  }

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: resumedLifecycleState in AppController');
    }
  }
}
