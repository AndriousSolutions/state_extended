// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Responsible for the event handling in all the Controllers and State objects.
///
/// dartdoc:
/// {@category StateX class}
/// {@category Event handling}
/// {@category State Object Controller}
mixin StateXEventHandlers implements AsyncOps, RouteAware, StateXonErrorMixin {
  /// A unique key is assigned to all State Controllers, State objects
  /// Used in large projects to separate objects into teams.
  String get identifier => _id;
  final String _id = Uuid().generateV4();

  /// debugPrint the 'event handlers'
  bool get printEvents => _printEvents;
  bool _printEvents = false;

  /// Clean up the Class name
  String get _consoleClassName =>
      toString().replaceAll('Instance of ', '').replaceAll("'", '');

  /// Leading line
  String? _consoleLeadingLine = ' ';

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @mustCallSuper
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine initState() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Implement any asynchronous operations needed done at start up.
  @override
  Future<bool> initAsync() async {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine initAsync() in $_consoleClassName');
      }
      return true;
    }());
    return true;
  }

  /// Call initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  bool runInitAsync() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine runInitAsync() in $_consoleClassName');
      }
      return true;
    }());
    return true;
  }

  /// Called with every [StateX] associated with this Controller
  /// Initialize any 'time-consuming' operations at the beginning.
  /// Implement any asynchronous operations needed done at start up.
  @override
  Future<bool> initAsyncState(covariant State state) async {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine initAsyncState() in $_consoleClassName');
      }
      return true;
    }());
    return true;
  }

  /// initAsync() has failed and a 'error' widget instead will be displayed.
  /// This takes in the snapshot.error details.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine onAsyncError() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine deactivate() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  void activate() {
    /// In some cases, however, after a [State] object has been deactivated, the
    /// framework will reinsert it into another part of the tree (e.g., if the
    /// subtree containing this [State] object is grafted from one location in
    /// the tree to another due to the use of a [GlobalKey]). If that happens,
    /// the framework will call [activate] to give the [State] object a chance to
    /// reacquire any resources that it released in [deactivate]. It will then
    /// also call [build] to give the object a chance to adapt to its new
    /// location in the tree.
    ///
    /// The framework does not call this method the first time a [State] object
    /// is inserted into the tree. Instead, the framework calls [initState] in
    /// that situation.
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine activate() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Override this method to respond to when the [StatefulWidget] is recreated.
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    /// The framework always calls build() after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didUpdateWidget() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when immediately after [initState].
  /// Otherwise called only if a dependency of an [InheritedWidget].
  void didChangeDependencies() {
    ///
    /// if a State object's [build] references an [InheritedWidget] with
    /// [context.dependOnInheritedWidgetOfExactType]
    /// its Widget is now a 'dependency' of that that InheritedWidget.
    /// Later, if that InheritedWidget's build() function is called, all its dependencies
    /// build() functions are also called but not before this method again.
    /// Subclasses rarely use this method, but its an option if needed.
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangeDependencies() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when the application's UI dimensions change.
  /// For example, when a phone is rotated.
  // To override WidgetsBindingObserver.didChangeMetrics()
  void didChangeMetrics() {
    /// Called when the application's dimensions change. For example,
    /// when a phone is rotated.
    ///
    /// In general, this is not overridden often as the layout system takes care of
    /// automatically recomputing the application geometry when the application
    /// size changes
    ///
    /// This method exposes notifications from [Window.onMetricsChanged].
    /// See sample code below. No need to call super if you override.
    ///   @override
    ///   void didChangeMetrics() {
    ///     setState(() { _lastSize = ui.window.physicalSize; });
    ///   }
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangeMetrics() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when the platform's text scale factor changes.
  // To override WidgetsBindingObserver.didChangeTextScaleFactor()
  void didChangeTextScaleFactor() {
    /// Called when the platform's text scale factor changes.
    ///
    /// This typically happens as the result of the user changing system
    /// preferences, and it should affect all of the text sizes in the
    /// application.
    ///
    /// This method exposes notifications from [Window.onTextScaleFactorChanged].
    /// See sample code below. No need to call super if you override.
    ///   @override
    ///   void didChangeTextScaleFactor() {
    ///     setState(() { _lastTextScaleFactor = ui.window.textScaleFactor; });
    ///   }
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangeTextScaleFactor() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Brightness changed.
  // To override WidgetsBindingObserver.didChangePlatformBrightness()
  void didChangePlatformBrightness() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangePlatformBrightness() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when the system tells the app that the user's locale has changed.
  // To override WidgetsBindingObserver.didChangeLocales()
  void didChangeLocales(List<Locale>? locales) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangeLocales() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  // To override WidgetsBindingObserver.didChangeAccessibilityFeatures()
  void didChangeAccessibilityFeatures() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangeAccessibilityFeatures() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when the system is running low on memory.
  // To override WidgetsBindingObserver.didHaveMemoryPressure()
  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didHaveMemoryPressure() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Determine if its dependencies should be updated.
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine updateShouldNotify() in $_consoleClassName');
      }
      return true;
    }());
    return true;
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  // To override WidgetsBindingObserver.didChangeAppLifecycleState()
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.detached
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.hidden
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didChangeAppLifecycleState($state) in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The application is in an inactive state and is not receiving user input.
  ///
  /// On iOS, this state corresponds to an app or the Flutter host view running
  /// in the foreground inactive state. Apps transition to this state when in
  /// a phone call, responding to a TouchID request, when entering the app
  /// switcher or the control center, or when the UIViewController hosting the
  /// Flutter app is transitioning.
  ///
  /// On Android, this corresponds to an app or the Flutter host view running
  /// in the foreground inactive state.  Apps transition to this state when
  /// another activity is focused, such as a split-screen app, a phone call,
  /// a picture-in-picture app, a system dialog, or another window.
  ///
  /// Apps in this state should assume that they may be [pausedLifecycleState] at any time.
  void inactiveAppLifecycleState() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine inactiveAppLifecycleState() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  void hiddenAppLifecycleState() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine hiddenAppLifecycleState() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void pausedAppLifecycleState() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine pausedAppLifecycleState() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The application is visible and responding to user input.
  void resumedAppLifecycleState() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine resumedAppLifecycleState() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Either be in the progress of attaching when the  engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  void detachedAppLifecycleState() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine detachedAppLifecycleState() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  // To override WidgetsBindingObserver.reassemble()
  void reassemble() {
    /// Called whenever the application is reassembled during debugging, for
    /// example during hot reload.
    ///
    /// This method should rerun any initialization logic that depends on global
    /// state, for example, image loading from asset bundles (since the asset
    /// bundle may have changed).
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine reassemble() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when a request is received from the system to exit the application.
  /// Exiting the application can proceed with
  ///    AppExitResponse.exit;
  /// Cancel and do not exit the application with
  ///    AppExitResponse.cancel;
  // To override WidgetsBindingObserver.didRequestAppExit()
  Future<AppExitResponse> didRequestAppExit() async {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didRequestAppExit() in $_consoleClassName');
      }
      return true;
    }());
    return AppExitResponse.exit;
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  ///
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification, for example by closing an active dialog
  /// box, and false otherwise. The [WidgetsApp] widget uses this
  /// mechanism to notify the [Navigator] widget that it should pop
  /// its current route if possible.
  ///
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  // To override WidgetsBindingObserver.didPopRoute()
  Future<bool> didPopRoute() async {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine didPopRoute() in $_consoleClassName');
      }
      return true;
    }());
    // Return false to pop out
    return false;
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification. Observers are notified in registration
  /// order until one returns true.
  ///
  // ignore: comment_references
  /// This method exposes the `pushRoute` notification from [SystemChannels.navigation].
  @Deprecated('Use didPushRouteInformation instead. '
      'This feature was deprecated after v3.8.0-14.0.pre.')
  // To override WidgetsBindingObserver.didPushRoute()
  Future<bool> didPushRoute(String route) async {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine didPushRoute() in $_consoleClassName');
      }
      return true;
    }());
    return false;
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification. Observers are notified in registration
  /// order until one returns true.
  ///
  // ignore: comment_references
  /// This method exposes the `popRoute` notification from [SystemChannels.navigation].
  ///
  // To override WidgetsBindingObserver.didPushRouteInformation()
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine didPushRouteInformation() in $_consoleClassName');
      }
      return true;
    }());
    return true;
  }

  /// Called when this State is *first* added to as a Route observer?!
  // To override WidgetsBindingObserver.didPush()
  @override
  void didPush() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine didPush() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// New route has been pushed, and this State object's route is no longer current.
  // To override WidgetsBindingObserver.didPush()
  @override
  void didPushNext() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine didPushNext() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when this State is popped off a route.
  // To override WidgetsBindingObserver.didPop()
  @override
  void didPop() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine didPop() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The top route has been popped off, and this route shows up.
  // To override WidgetsBindingObserver.didPopNext()
  @override
  void didPopNext() {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine didPopNext() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Offer an error handler
  @override
  void onError(FlutterErrorDetails details) {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('$_consoleLeadingLine onError() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Logs 'every' error as the error count is reset.
  @override
  void logErrorDetails(FlutterErrorDetails details, {bool? force}) {
    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '$_consoleLeadingLine logErrorDetails() in $_consoleClassName');
      }
      return true;
    }());
  }
}

/// Supply a readable name of a provided object/class
String _consoleNameOfClass(Object? obj) {
  String name = '';
  if (obj != null) {
    name = obj.toString();
    final hash = name.indexOf('#');
    if (hash > 0) {
      name = name.substring(0, hash);
    } else {
      name = name.replaceAll('Instance of ', ''); //.replaceAll("'", '');
      final parts = name.split(' ');
      name = parts.last.replaceAll("'", '');
    }
  }
  return name;
}
