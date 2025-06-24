// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show AppExitResponse;

import '/src/controller.dart' show AppSettingsController, StateXController;

import '/src/view.dart';

/// Multiple Controllers can be assigned to one State object.
/// Includes the mixin, StateXonErrorMixin, to supply an error handler
class AnotherController extends StateXController
    with StateXonErrorMixin, EventsControllerMixin {
  /// It's a good practice to make Controllers using the Singleton pattern
  factory AnotherController() => _this ??= AnotherController._();

  AnotherController._() : _appSettings = AppSettingsController();
  static AnotherController? _this;

  final AppSettingsController _appSettings;

  /// Explicitly cause an error
  bool get initAsyncError => _appSettings.initAsyncError;

  set initAsyncError(bool? error) => _appSettings.initAsyncError = error;

  /// Explicitly return false
  bool get initAsyncFailed => _appSettings.initAsyncFailed;

  set initAsyncFailed(bool? error) => _appSettings.initAsyncFailed = error;

  /// Supply the name of this class
  String get className =>
      toString().replaceAll('Instance of', '').replaceAll("'", '');

  @override
  Future<bool> initAsync() async {
    var init = await super.initAsync();
    if (initAsyncFailed) {
      init = false;
    }
    return init;
  }

  @override
  Future<bool> initAsyncState(state) async {
    await super.initAsyncState(state);
    if (initAsyncError) {
      throw Exception('Error in AnotherController.initAsync()!');
    }
    return true;
  }

  /// The initAsync() function has failed and a 'error' widget will be displayed.'
  /// This takes in the snapshot.error details.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    //
    final errorMessage = details.exception.toString();

    if (errorMessage.contains('Error in AnotherController.initAsync()!')) {
      debugPrint(
          "########### Caught 'Error in AnotherController.initAsync()!' in onAsyncError() for $className");
    }

    if (errorMessage
        .contains('AnotherController.initAsync() returned false!')) {
      debugPrint(
          "########### Caught 'AnotherController.initAsync() returned false!' in onAsyncError() for $className");
    }
  }

  /// Provide the setState() function to external actors
  @override
  void setState(VoidCallback fn) => super.setState(fn);

  /// Retrieve the State object by type
  /// Returns null if not found
  @override
  StateX? stateOf<T extends StatefulWidget>() => super.stateOf<T>() as StateX?;

  /// Retrieve the State object by type
  /// Returns null if not found
  @override
  T? ofState<T extends State>() => super.ofState<T>();

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  void initState() => super.initState();

  /// Called whenever its [StateX] object is placed in the 'background.'
  @override
  void deactivate() => super.deactivate();

  /// Called when this [StateX] object is itself disposed of.
  @override
  void dispose() => super.dispose();

  /// Override this method to respond when the [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) =>
      super.didUpdateWidget(oldWidget);

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget is a dependency of
  /// [InheritedWidget].
  @override
  void didChangeDependencies() => super.didChangeDependencies();

  /// Called whenever the application is reassembled during hot reload.
  @override
  void reassemble() => super.reassemble();

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async => false;

  /// Called when app pushes a new route onto the navigator.
  @override
  Future<bool> didPushRoute(String route) async => false;

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    // Already called by another State object currently running.
    if (calledChangeMetrics) {
      return;
    }
    super.didChangeMetrics();
  }

  /// Called when the platform's text sizes in the application.
  @override
  void didChangeTextScaleFactor() => super.didChangeTextScaleFactor();

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() => super.didChangePlatformBrightness();

  /// Called when the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) =>
      super.didChangeLocales(locales);

  /// Called when the system puts the app in the background or
  /// returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.suspending (Android only)
    super.didChangeAppLifecycleState(state);
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() => super.didHaveMemoryPressure();

  /// Called when a request is received from the system to exit the application.
  /// Exiting the application can proceed with
  ///    AppExitResponse.exit;
  /// Cancel and do not exit the application with
  ///    AppExitResponse.cancel;
  // Windows only
  @override
  Future<AppExitResponse> didRequestAppExit() async => AppExitResponse.exit;

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() =>
      super.didChangeAccessibilityFeatures();
}
