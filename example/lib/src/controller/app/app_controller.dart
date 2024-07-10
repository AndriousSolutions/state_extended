// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

/// The 'App Level' Controller
class ExampleAppController extends StateXController with EventsControllerMixin {
  /// Singleton design pattern is best for Controllers.
  factory ExampleAppController() => _this ??= ExampleAppController._();
  ExampleAppController._();
  static ExampleAppController? _this;

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  Future<bool> initAsync() {
    // Simply wait for 10 seconds at startup.
    /// In production, this is where databases are opened, logins attempted, etc.
    return Future<bool>.delayed(const Duration(seconds: 10), () {
      return true;
    });
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  @override
  void onAsyncError(FlutterErrorDetails details) {}

  /// Store the boolean allowing for errors or not.
  bool allowErrors = false;

  /// Error right at the start
  bool errorAtStartup = false;

  /// Allow for a Splash screen or not
  bool splashScreen = false;
}
