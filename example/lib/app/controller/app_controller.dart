// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

/// The 'App Level' Controller
class ExampleAppController extends StateXController
    with EventsControllerMixin, TabsScaffoldController {
  // TwoTabScaffoldController {
  /// Singleton design pattern is best for Controllers.
  factory ExampleAppController() => _this ??= ExampleAppController._();
  ExampleAppController._() : _appSettings = AppSettingsController();
  static ExampleAppController? _this;
  // The App's settings
  final AppSettingsController _appSettings;

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  Future<bool> initAsync() async {
    await super.initAsync();
    //
    var init = await _appSettings.initAsync();

    // Throw an error right here at the beginning to test recovery code.
    if (initAppAsyncError) {
      // initAppAsyncError = false;
      throw Exception('Error in initAsync()!');
    }

    /// In production, this is where databases are opened, logins attempted, etc.
    if (initAsyncDelay) {
      // Simply wait for 10 seconds at startup.
      init = await Future<bool>.delayed(const Duration(seconds: 10), () {
        return true;
      });
    }
    return init;
  }

  /// Called with every [StateX] associated with this Controller
  /// Initialize any 'time-consuming' operations at the beginning.
  @override
  Future<bool> initAsyncState(State state) async {
    return true;
  }

  /// Called by every [StateX] object associated with it.
  /// Override this method to perform initialization,
  @override
  void stateInit(State state) {
    return;
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
    //
    if (details.exception.toString().contains('Error in initAsync()!')) {
      assert(() {
        debugPrint(
            '########### Caught error in onAsyncError() for $controllerName');
        return true;
      }());
    }
  }

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
  Key get page1Key => _page1Key ??= UniqueKey();
  set page1Key(Key? key) {
    _page1Key = key;
  }

  Key? _page1Key;

  /// Supply a delay at startup
  bool get initAsyncDelay => _appSettings.initAsyncDelay;

  /// Error in a button press
  bool get errorButton => _appSettings.errorButton;

  /// Error in the App's initAsync()
  bool get initAppAsyncError => _appSettings.initAppAsyncError;
  set initAppAsyncError(bool? error) => _appSettings.initAppAsyncError = error;

  /// Error in builder()
  bool get errorInBuilder => _appSettings.errorInBuilder;
  set errorInBuilder(bool? splash) => _appSettings.errorInBuilder = splash;

  /// Error in catchAsyncError()
  bool get errorCatchAsyncError => _appSettings.errorCatchAsyncError;
  set errorCatchAsyncError(bool? error) =>
      _appSettings.errorCatchAsyncError = error;

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
