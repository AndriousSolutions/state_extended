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
    // Retrieve the Settings ASAP
    var init = await _appSettings.initAsync();

    // Have the debugPrint() function fire in the many event handlers
    // Only when NOT testing
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      debugPrintEvents = _appSettings.printoutEvents;
      statex?.debugPrintEvents = _appSettings.printoutEvents;
    }

    if (init) {
      init = await super.initAsync();
    }

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
      if (details.exception.toString().contains('Error in initAsync()!')) {
        debugPrint(
            '########### Caught error in onAsyncError() for $controllerName');
      }
      return true;
    }());
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
