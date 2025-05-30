// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show AppExitResponse, Locale;

import '/src/controller.dart';

import '/src/view.dart';

///
mixin EventsStateMixin<T extends StatefulWidget> on StateX<T> {
  ///
  String get eventStateClassName => _cName ??= eventStateClassNameOnly('$this');

  set eventStateClassName(String? name) =>
      _cName ??= name?.isEmpty ?? true ? null : name;

  String? _cName;

  @override
  void initState() {
    super.initState();
    LogController.log('initState() in $eventStateClassName');
  }

  /// Whenever it removes
  @override
  void deactivate() {
    LogController.log('deactivate() in $eventStateClassName');
    super.deactivate();
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    LogController.log('activate() in $eventStateClassName');
    super.activate();
  }

  /// The framework calls this method when this StateX object will never
  /// build again.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  @override
  void dispose() {
    LogController.log('dispose() in $eventStateClassName');
    super.dispose();
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding runAsync() routine.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    LogController.log('onAsyncError() in $eventStateClassName');
  }

  /// Error Handler
  @override
  void onError(FlutterErrorDetails details) {
    LogController.log('onError() in $eventStateClassName');
  }

  /// Called when this State is *first* added to as a Route observer?!
  @override
  void didPush() {
    super.didPush();
    LogController.log('didPush() in $eventStateClassName');
  }

  /// New route has been pushed, and this State object's route is no longer current.
  @override
  void didPushNext() {
    super.didPushNext();
    LogController.log('didPushNext() in $eventStateClassName');
  }

  /// Called when this State is popped off a route.
  @override
  void didPop() {
    LogController.log('didPop() in $eventStateClassName');
    super.didPop();
  }

  /// The top route has been popped off, and this route shows up.
  @override
  void didPopNext() {
    LogController.log('didPopNext() in $eventStateClassName');
    super.didPopNext();
  }

  /// Call a State object's setState()
  @override
  void setState(VoidCallback fn, {bool? log}) {
    if (log ?? true) {
      LogController.log('setState() in $eventStateClassName');
    }
    super.setState(fn);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    /// The Timer is too frequent and interrupts the running App.
    // super.updateShouldNotify(oldWidget);
    return true;
  }

  /// This method is also called immediately after [initState].
  /// Otherwise called only if this State object's Widget
  /// is a 'dependency' of InheritedWidget.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LogController.log('didChangeDependencies() in $eventStateClassName');
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    LogController.log('didChangeMetrics() in $eventStateClassName');
    super.didChangeMetrics();
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    LogController.log(
      'didChangeTextScaleFactor() in $eventStateClassName',
    );
    super.didChangeTextScaleFactor();
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    LogController.log(
      'didChangePlatformBrightness() in $eventStateClassName',
    );
    super.didChangePlatformBrightness();
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    LogController.log('didChangeLocales() in $eventStateClassName');
    super.didChangeLocales(locales);
  }

  /// The application is in an inactive state and is not receiving user input.
  /// Apps in this state should assume that they may be [pausedAppLifecycleState] at any time.
  @override
  void inactiveAppLifecycleState() {
    LogController.log(
      'inactiveAppLifecycleState() in $eventStateClassName',
    );
  }

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  @override
  void hiddenAppLifecycleState() {
    LogController.log(
      'hiddenAppLifecycleState() in $eventStateClassName',
    );
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedAppLifecycleState() {
    LogController.log(
      'pausedAppLifecycleState() in $eventStateClassName',
    );
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedAppLifecycleState() {
    LogController.log(
      'detachedAppLifecycleState() in $eventStateClassName',
    );
  }

  /// The application is visible and responding to user input.
  @override
  void resumedAppLifecycleState() {
    LogController.log(
      'resumedAppLifecycleState() in $eventStateClassName',
    );
  }

  /// Called when there's a memory constraint.
  @override
  void didHaveMemoryPressure() {
    LogController.log('didHaveMemoryPressure() in $eventStateClassName');
    super.didHaveMemoryPressure();
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    LogController.log(
      'didChangeAccessibilityFeatures() in $eventStateClassName',
    );
    super.didChangeAccessibilityFeatures();
  }

  /// Called when a request is received from the system to exit the application.
  @override
  Future<AppExitResponse> didRequestAppExit() {
    LogController.log('didRequestAppExit() in $eventStateClassName');
    return super.didRequestAppExit();
  }
}

///
mixin EventsControllerMixin on StateXController {
  ///
  String get controllerName => _cname ??= eventStateClassNameOnly('$this');

  set controllerName(String? name) =>
      _cname ??= name?.isEmpty ?? true ? null : name;

  String? _cname;

  /// Called once when the Controller is first used
  @override
  void initState() {
    super.initState();
    LogController.log('initState() in $controllerName');
  }

  /// Called with evey new State object to use this controller if any
  @override
  void stateInit(state) {
    super.stateInit(state);
    LogController.log(
        'stateInit(${eventStateClassNameOnly('$state')}) in $controllerName');
  }

  /// Called with every [StateX] associated with this Controller
  @override
  Future<bool> initAsyncState(StateX state) async {
    final init = await super.initAsyncState(state);

    // Impose a print if the State prints
    if (state.debugPrintEvents) {
      // Use debugPrint() to print out to the console when an event fires
      debugPrintEvents = state.debugPrintEvents;
    }
    LogController.log(
        'initAsyncState(${eventStateClassNameOnly('$state')}) in $controllerName');
    return init;
  }

  /// Whenever it's removed from the Widget Tree
  @override
  void deactivate() {
    super.deactivate();
    LogController.log('deactivate() in $controllerName');
  }

  /// Called when a State object is 'remove' from the Widget tree.
  /// Called with every State object currently using this controller
  @override
  void deactivateState(state) {
    super.deactivateState(state);
    LogController.log(
        'deactivateState(${eventStateClassNameOnly('$state')}) in $controllerName');
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    super.activate();
    LogController.log('activate() in $controllerName');
  }

  /// Called when a State object is 'reinserted' into the Widget tree.
  /// Called with every State object currently using this controller
  @override
  void activateState(state) {
    super.activateState(state);
    LogController.log(
        'activateState(${eventStateClassNameOnly('$state')}) in $controllerName');
  }

  /// The framework calls this method when this StateX object will never
  /// build again.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
    LogController.log('dispose() in $controllerName');
  }

  /// The framework calls this method when this StateX object will never build again.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  /// Called with every State object currently using this controller
  @override
  void disposeState(state) {
    super.disposeState(state);
    LogController.log(
        'dispose(${eventStateClassNameOnly('$state')}) in $controllerName');
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding runAsync() routine.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    super.onAsyncError(details);
    LogController.log('onAsyncError() in $controllerName');
  }

  /// Error Handler
  @override
  void onError(FlutterErrorDetails details) {
    super.onError(details);
    LogController.log('onError() in $controllerName');
  }

  /// Called when this State is *first* added to as a Route observer?!
  @override
  void didPush() {
    super.didPush();
    LogController.log('didPush() in $controllerName');
  }

  /// New route has been pushed, and this State object's route is no longer current.
  @override
  void didPushNext() {
    super.didPushNext();
    LogController.log('didPushNext() in $controllerName');
  }

  /// Called when this State is popped off a route.
  @override
  void didPop() {
    LogController.log('didPop() in $controllerName');
    super.didPop();
  }

  /// The top route has been popped off, and this route shows up.
  @override
  void didPopNext() {
    LogController.log('didPopNext() in $controllerName');
    super.didPopNext();
  }

  /// Call a State object's setState()
  @override
  void setState(VoidCallback fn) {
    LogController.log('setState() in $controllerName');
    super.setState(fn);
  }

  /// This method is also called immediately after [initState].
  /// Otherwise called only if this State object's Widget
  /// is a 'dependency' of InheritedWidget.
  /// When a InheritedWidget's build() function is called
  /// the dependent widget's build() function is also called but not before
  /// their didChangeDependencies() function.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LogController.log('didChangeDependencies() in $controllerName');
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    LogController.log('didChangeMetrics() in $controllerName');
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    LogController.log('didChangeTextScaleFactor() in $controllerName');
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    LogController.log('didChangePlatformBrightness() in $controllerName');
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    LogController.log('didChangeLocales() in $controllerName');
  }

  /// The application is in an inactive state and is not receiving user input.
  /// Apps in this state should assume that they may be [pausedAppLifecycleState] at any time.
  @override
  void inactiveAppLifecycleState() {
    super.inactiveAppLifecycleState();
    LogController.log('inactiveAppLifecycleState() in $controllerName');
  }

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  @override
  void hiddenAppLifecycleState() {
    super.hiddenAppLifecycleState();
    LogController.log('hiddenAppLifecycleState() in $controllerName');
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedAppLifecycleState() {
    super.pausedAppLifecycleState();
    LogController.log('pausedAppLifecycleState() in $controllerName');
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedAppLifecycleState() {
    super.detachedAppLifecycleState();
    LogController.log('detachedAppLifecycleState() in $controllerName');
  }

  /// The application is visible and responding to user input.
  @override
  void resumedAppLifecycleState() {
    super.resumedAppLifecycleState();
    LogController.log('resumedAppLifecycleState() in $controllerName');
  }

  /// Called when there's a memory constraint.
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    LogController.log('didHaveMemoryPressure() in $controllerName');
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    LogController.log('didChangeAccessibilityFeatures() in $controllerName');
  }

  /// Called when a request is received from the system to exit the application.
  @override
  Future<AppExitResponse> didRequestAppExit() {
    LogController.log('didRequestAppExit() in $controllerName');
    return super.didRequestAppExit();
  }
}

/// Pass a Class name to return only the base name.
String eventStateClassNameOnly(String? name) {
  if (name != null) {
    final hash = name.indexOf('#');
    if (hash > 0) {
      name = name.substring(0, hash);
    } else {
      final parts = name.split(' ');
      name = parts.last.replaceAll("'", '');
    }
  }
  return name ?? '';
}
