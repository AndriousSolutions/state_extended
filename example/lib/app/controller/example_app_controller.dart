// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/scheduler.dart';

import '/src/controller.dart';

import '/src/view.dart';

/// The 'App Level' Controller
class ExampleAppController extends StateXController
    with EventsControllerMixin, TabsScaffoldController {
  // TwoTabScaffoldController {
  /// Singleton design pattern is best for Controllers.
  factory ExampleAppController() => _this ??= ExampleAppController._();

  ExampleAppController._()
      : _appSettings = AppSettingsController(),
        _controller = Controller();

  static ExampleAppController? _this;

  // The App's settings
  final AppSettingsController _appSettings;

  // The Home screen's controller
  final Controller _controller;

  /// Called when it's [StateX] object is itself disposed of.
  @override
  void dispose() {
    // Good practice to nullify static instance reference.
    // Flutter's garbage collection does its best, but why not if no longer used
    _this = null;
    super.dispose();
  }

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  Future<bool> initAsync() async {
    // Retrieve the Settings ASAP
    var init = await _appSettings.initAsync();

    // Attain a reference to the App's State object
    _appSettings.addState(statex);

    // Have the debugPrint() function fire in the many event handlers
    // Only when NOT testing
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      debugPrintEvents = _appSettings.printoutEvents;
      statex?.debugPrintEvents = _appSettings.printoutEvents;
    }

    if (init) {
      init = await super.initAsync();
    }
    return init;
  }

  @override
  Future<bool> initAsyncState(state) async {
    //
    var init = await super.initAsyncState(state);

    if (init) {
      //
      if (state is AppStateX) {
        /// In production, this is where databases are opened, logins attempted, etc.
        if (initAsyncDelay) {
          //
          // init = false;

          // Simply wait for 10 seconds at startup.
          await Future<bool>.delayed(const Duration(seconds: 10), () {
            init = true;
            return true;
          });
        }

        //
        // Throw an error right here at the beginning to test recovery code.
        if (initAppAsyncError) {
          // initAppAsyncError = false;
          throw Exception("Error in App's initAsync()!");
        }
      }
    }
    return init;
  }

  @override
  Future<void> deactivate() async {
    await _appSettings.deactivate();
  }

  @override
  void inactiveAppLifecycleState() {
    _appSettings.inactiveAppLifecycleState();
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    _appSettings.reassemble();
  }

  /// The initAsync() function has failed and a 'error' widget will be displayed.'
  /// This takes in the snapshot.error details.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    super.onAsyncError(details); // Not really necessary. Just for Codecov
    //
    assert(() {
      if (details.exception
          .toString()
          .contains("Error in App's initAsync()!")) {
        debugPrint(
            '########### Caught error in onAsyncError() for $controllerName');
      }
      return true;
    }());
  }

  /// Catch it if the initAsync() throws an error
  /// WITH GREAT POWER COMES GREAT RESPONSIBILITY
  /// Return true to ignore the error, false to continue the error handling
  @override
  Future<bool> catchAsyncError(Object error) async {
    //
    final errMag = error.toString();

    var caught = errMag.contains("Error in App's initAsync()!");

    if (caught) {
      caught = _appSettings.catchInitAppAsyncError;
      if (!caught) {
        // Return to true or you're trapped not recovering
        _appSettings.catchInitAppAsyncError = true;
      }
    }

    if (caught) {
      assert(() {
        debugPrint(
            '=========== Caught error in catchAsyncError() for $controllerName');
        return true;
      }());

      // Supplied when start up is completed
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Allows for a SnackBar
        MyApp.app.showSnackBar('An error at startup but was caught');
      });
    }

    return caught;
  }

  /// when the Drawer is just opened.
  void onOpenDrawer() => _controller.onOpenDrawer();

  /// When the Drawer is just closed.
  void onCloseDrawer() => _controller.onCloseDrawer();

  ///
  ThemeData get themeData =>
      ThemeData.light(useMaterial3: _appSettings.useMaterial3);

  ///
  CupertinoThemeData get cupertinoThemeData {
    CupertinoThemeData theme =
        MaterialBasedCupertinoThemeData(materialTheme: themeData);
    final context = state?.context;
    if (context != null) {
      theme = theme.resolveFrom(context);
    }
    return theme;
  }

  /// Page1 Key
  /// Changing it will recreate its State object.
  Key? get page1Key => _controller.page1Key;

  set page1Key(Key? key) => _controller.page1Key = key;

  /// Supply a delay at startup
  bool get initAsyncDelay => _appSettings.initAsyncDelay;

  /// Error in a button press
  bool get errorButton => _appSettings.errorButton;

  /// Error in the App's initAsync()
  bool get initAppAsyncError => _appSettings.initAppAsyncError;

  set initAppAsyncError(bool? error) => _appSettings.initAppAsyncError = error;

  /// Catch the error in App's initAsync()
  bool get catchInitAppAsyncError => _appSettings.catchInitAppAsyncError;

  /// Error in builder()
  bool get errorInBuilder => _appSettings.errorInBuilder;

  set errorInBuilder(bool? error) => _appSettings.errorInBuilder = error;

  /// Error in catchAsyncError()
  bool get errorCatchAsyncError => _appSettings.errorCatchAsyncError;

  set errorCatchAsyncError(bool? error) =>
      _appSettings.errorCatchAsyncError = error;

  /// Catch error in catchAsyncError()
  bool get catchErrorCatchAsyncError => _appSettings.catchErrorCatchAsyncError;

  ///
  @override
  void deactivateTabsScaffold() => _appSettings.deactivateTabsScaffold();

  ///
  @override
  void tabSwitch(int index) => _appSettings.tabSwitch(index);

  ///
  @override
  void tabSwitchBack() => _appSettings.tabSwitchBack();
}
