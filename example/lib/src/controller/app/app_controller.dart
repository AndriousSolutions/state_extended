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
}
