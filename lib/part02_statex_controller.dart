// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Your 'working' class most concerned with the app's functionality.
/// Add it to a 'StateX' object to associate it with that State object.
///
/// dartdoc:
/// {@category Testing}
/// {@category Get started}
/// {@category Event handling}
/// {@category State Object Controller}
class StateXController
    with
        WidgetsBindingInstanceMixin,
        StateXEventHandlers,
        SetStateMixin,
        AppStateMixin,
        AsyncOps,
        _RebuildControllerStatesMixin {
  /// Optionally supply a State object to 'link' to this object.
  /// Thus, assigned as 'current' StateX for this object
  StateXController([StateX? state]) {
    addState(state);
    _consoleLeadingLine = '###########';
  }

  /// Print to console every event handler
  StateXController.config({StateX? state, bool? printEvents}) {
    StateXController(state);
    // Show the 'event handler' functions
    _debugPrintEvents = printEvents ?? true;
  }

  /// The framework will call this method exactly once.
  /// Override this method to perform initialization,
  @override
  void initState() {
    super.initState();
    _initChangeNotifier();
  }

  /// Called by every [StateX] object associated with it.
  /// Override this method to perform initialization,
  void stateInit(covariant State state) {
    assert(() {
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine stateInit($state) in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Flag indicating if initState() was already called
  bool get initStateCalled => _initStateCalled ?? false;
  bool? _initStateCalled;

  /// Asynchronous operations must complete successfully.
  @override
  @mustCallSuper
  Future<bool> initAsync() async {
    assert(() {
      // Optionally call super for debugPrint()
      if (_debugPrintEvents) {
        debugPrint('$_consoleLeadingLine initAsync() in $this');
      }
      return true;
    }());
    return super.initAsync();
  }

  /// Called with every [StateX] associated with this Controller
  /// Initialize any 'time-consuming' operations at the beginning.
  /// Implement any asynchronous operations needed done at start up.
  @override
  Future<bool> initAsyncState(covariant State state) async {
    final init = super.initAsyncState(state);
    // Optionally call super for debugPrint()
    assert(() {
      // Impose a print if the State prints
      if (state is StateX && state._debugPrintEvents) {
        // Use debugPrint() to print out to the console when an event fires
        debugPrintEvents = state._debugPrintEvents;
      }
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine initAsyncState($state) in $_consoleClassName');
      }
      return true;
    }());
    return init;
  }

  /// initAsync() has failed and a 'error' widget instead will be displayed.
  /// This takes in the snapshot.error details.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    // Optionally call super for debugPrint()
    assert(() {
      if (_debugPrintEvents) {
        debugPrint('$_consoleLeadingLine onAsyncError() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Catch it if the initAsync() throws an error
  /// WITH GREAT POWER COMES GREAT RESPONSIBILITY
  /// Return true to ignore the error, false to continue the error handling
  Future<bool> catchAsyncError(Object error) async => false;

  /// Associate this StateXController to the specified State object
  /// to use that State object's functions and features.
  /// Returns that State object's unique identifier.
  String addState(StateX? state) {
    String id;
    if (state == null) {
      id = '';
    } else {
      if (state.add(this).isNotEmpty) {
        id = state.identifier;
      } else {
        id = '';
      }
    }
    return id;
  }

  /// Reference the App State object
  @override
  AppStateX? get appStateX {
    if (_appStateX == null) {
      if (firstState != null && firstState is AppStateX) {
        _appStateX = firstState as AppStateX;
      } else {
        _appStateX = lastContext?.findAncestorStateOfType<AppStateX>();
      }
    }
    return _appStateX;
  }

  AppStateX? _appStateX;

  /// Supply the StateX object
  StateX? get statex =>
      _state == null || _state is! StateX ? null : _state as StateX;

  /// Link a widget to an InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) =>
      statex?.dependOnInheritedWidget(context) ?? false;

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  bool notifyClients() {
    final notify = statex?.notifyClients() ?? false;
    notifyListeners();
    return notify;
  }

  /// Call a State object's setState()
  /// and notify any listeners
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    notifyListeners();
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  // @override
  // void deactivate() {
  //   // Optionally call super for debugPrint()
  //   super.deactivate();
  // }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  void deactivateState(covariant State state) {
    // Optionally call super for debugPrint()
    assert(() {
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine deactivate($state) in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  // @override
  // void activate() {
  //   // Optionally call super for debugPrint()
  //   super.activate();
  // }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  void activateState(covariant State state) {
    // Optionally call super for debugPrint()
    assert(() {
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine activateState($state) in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [StateX] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).
    // Clear its ChangeNotifier
    _disposeChangeNotifier();

    /// Clean up memory
    disposeSetState();

    // App State object
    _appStateX = null;

    // If instantiated in a factory constructor
    // Note: You don't know when this function will fire!
    // _initStateCalled = false;

    // Optionally call super for debugPrint()
    assert(() {
      if (_debugPrintEvents) {
        debugPrint('$_consoleLeadingLine dispose() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  void disposeState(covariant State state) {
    /// The framework calls this method when this [StateX] object will never
    /// build again. The [State] object's lifecycle is terminated.
    // Optionally call super for debugPrint()
    assert(() {
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine disposeState($state) in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Override this method to respond to when the [StatefulWidget] is recreated.
  // @override
  // void didUpdateWidget(covariant StatefulWidget oldWidget) {
  //   /// The framework always calls build() after calling [didUpdateWidget], which
  //   /// means any calls to [setState] in [didUpdateWidget] are redundant.
  //   // Optionally call super for debugPrint()
  //   super.didUpdateWidget(oldWidget);
  // }

  /// Called when immediately after [initState].
  /// Otherwise called only if a dependency of an [InheritedWidget].
  // @override
  // void didChangeDependencies() {
  //   // Optionally call super for debugPrint()
  //   super.didChangeDependencies();
  // }

  /// Called when the application's UI dimensions change.
  /// For example, when a phone is rotated.
  // @override
  // void didChangeMetrics() {
  //   /// Use getter [calledChangeMetrics] to only run this once.
  //   /// You sharing controllers with multiple Stat objects is common.
  //   // Optionally call super for debugPrint()
  //   super.didChangeMetrics();
  // }

  /// The 'didChangeMetrics' event has already been called in a previous State object
  /// that contains this Controller.
  bool get calledChangeMetrics {
    bool change = false;
    final list = _stateSet.toList(growable: false);
    for (final State state in list) {
      // You're at the current State object
      if (state == this.state) {
        change = _didCallChange;
        _didCallChange = false;
        break;
      }
      if (!_didCallChange && (state as StateX).controllerList.contains(this)) {
        _didCallChange = true;
        break;
      }
    }
    return change;
  }

  bool _didCallChange = false;

  /// Called when the platform's text scale factor changes.
  // Save on function calls
  // @override
  // void didChangeTextScaleFactor() {
  //   // Optionally call super for debugPrint()
  //   super.didChangeTextScaleFactor();
  // }

  /// Brightness changed.
  // Save on function calls
  // @override
  // void didChangePlatformBrightness() {
  //   // Optionally call super for debugPrint()
  //   super.didChangePlatformBrightness();
  // }

  /// Called when the system tells the app that the user's locale has changed.
  // Save on function calls
  // @override
  // void didChangeLocales(List<Locale>? locales) {
  //   // Optionally call super for debugPrint()
  //   super.didChangeLocales(locales);
  // }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  // Save on function calls
// @override
  // void didChangeAccessibilityFeatures() {
  //   // Optionally call super for debugPrint()
  //   super.didChangeAccessibilityFeatures();
  // }

  /// Called when the system is running low on memory.
  // Save on function calls
  // @override
  // void didHaveMemoryPressure() {
  //   // Optionally call super for debugPrint()
  //   super.didHaveMemoryPressure();
  // }

  /// Determine if its dependencies should be updated.
  // Save on function calls
  // @override
  // bool updateShouldNotify(covariant InheritedWidget oldWidget) {
  //   // Optionally call super for debugPrint()
  //   return super.updateShouldNotify(oldWidget);
  // }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  // Save on function calls
// @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   /// Passing these possible values:
  //   /// AppLifecycleState.detached
  //   /// AppLifecycleState.resumed
  //   /// AppLifecycleState.inactive (may be paused at any time)
  //   /// AppLifecycleState.hidden
  //   /// AppLifecycleState.paused (may enter the suspending state at any time)
  //   // Optionally call super for debugPrint()
  //   super.didChangeAppLifecycleState(state);
  // }

  /// The application is in an inactive state and is not receiving user input.
  // Save on function calls
  // @override
  // void inactiveAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.inactiveAppLifecycleState();
  // }

  /// All views of an application are hidden, either because the application is
  // Save on function calls
// @override
  // void hiddenAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.hiddenAppLifecycleState();
  // }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  // Save on function calls
// @override
  // void pausedAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.pausedAppLifecycleState();
  // }

  /// The application is visible and responding to user input.
  // Save on function calls
  // @override
  // void resumedAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.resumedAppLifecycleState();
  // }

  /// Either be in the progress of attaching when the  engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  // Save on function calls
// @override
  // void detachedAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.detachedAppLifecycleState();
  // }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  // Save on function calls
  // @override
  // void reassemble() {
  //   // Optionally call super for debugPrint()
  //   super.reassemble();
  // }

  /// Called when a request is received from the system to exit the application.
  // Save on function calls
// @override
  // Future<AppExitResponse> didRequestAppExit() async {
  //   // Optionally call super for debugPrint()
  //   return super.didRequestAppExit();
  // }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  // Save on function calls
// @override
  // Future<bool> didPopRoute() async {
  //   // Optionally call super for debugPrint()
  //   return super.didPopRoute();
  // }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  // Save on function calls
// @override
  // Future<bool> didPushRoute(String route) async {
  //   // ignore: deprecated_member_use_from_same_package
  //   return super.didPushRoute(route);
  // }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  // Save on function calls
// @override
  // Future<bool> didPushRouteInformation(
  //     RouteInformation routeInformation) async {
  //   // Optionally call super for debugPrint()
  //   return super.didPushRouteInformation(routeInformation);
  // }

  /// Called when this State is *first* added to as a Route observer?!
  // Save on function calls
// @override
  // void didPush() {
  //   // Optionally call super for debugPrint()
  //   super.didPush();
  // }

  /// New route has been pushed, and this State object's route is no longer current.
  // Save on function calls
  // @override
  // void didPushNext() {
  //   // Optionally call super for debugPrint()
  //   super.didPushNext();
  // }

  /// Called when this State is popped off a route.
  // Save on function calls
  // @override
  // void didPop() {
  //   // Optionally call super for debugPrint()
  //   super.didPop();
  // }

  /// The top route has been popped off, and this route shows up.
  // Save on function calls
  // @override
  // void didPopNext() {
  //   // Optionally call super for debugPrint()
  //   super.didPopNext();
  // }

  /// Called at the start of a predictive back gesture.
  /// If an observer returns true then that observer, and only that observer,
  /// will be notified of subsequent events in
  /// this same gesture (for example [handleUpdateBackGestureProgress], etc.).
  ///
  /// Observers are expected to return true if they were able to handle the
  /// notification, If all observers indicate they are not handling this back gesture by
  /// returning false, then a navigation pop will result when
  /// [handleCommitBackGesture] is called, as in a non-predictive system back
  /// gesture.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  // Save on function calls
  // @override
  // bool handleStartBackGesture(PredictiveBackEvent backEvent) {
  //   // Optionally call super for debugPrint()
  //   return super.handleStartBackGesture(backEvent);
  // }

  /// Called when a predictive back gesture moves.
  ///
  /// The observer which was notified of this gesture's [handleStartBackGesture]
  /// is the same observer notified for this.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  // Save on function calls
  // @override
  // void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
  //   // Optionally call super for debugPrint()
  //   return super.handleUpdateBackGestureProgress(backEvent);
  // }

  /// Called when a predictive back gesture is finished successfully, indicating
  /// that the current route should be popped.
  ///
  /// The observer which was notified of this gesture's [handleStartBackGesture]
  /// is the same observer notified for this. If there is none, then a
  /// navigation pop will result, as in a non-predictive system back gesture.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  // Save on function calls
  // @override
  // void handleCommitBackGesture() {
  //   // Optionally call super for debugPrint()
  //   return super.handleCommitBackGesture();
  // }

  /// Called when a predictive back gesture is canceled, indicating that no
  /// navigation should occur.
  ///
  /// The observer which was notified of this gesture's [handleStartBackGesture]
  /// is the same observer notified for this.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  // Save on function calls
  // @override
  // void handleCancelBackGesture() {
  //   // Optionally call super for debugPrint()
  //   return super.handleCommitBackGesture();
  // }

  /// Offer an error handler
  @override
  void onError(FlutterErrorDetails details) {
    // Optionally call super for debugPrint()
    assert(() {
      if (_debugPrintEvents) {
        debugPrint('$_consoleLeadingLine onError() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Logs 'every' error as the error count is reset.
  @override
  void logErrorDetails(FlutterErrorDetails details, {bool? force}) {
    //
    if (logStateXError || (force ?? false)) {
      // Don't when in DebugMode.
      if (!kDebugMode) {
        // Resets the count of errors to show a complete error message not an abbreviated one.
        FlutterError.resetErrorCount();
      }
      // https://docs.flutter.dev/testing/errors#errors-caught-by-flutter
      // Log the error.
      FlutterError.presentError(details);
    } else {
      // Won't log this time with this call.
      logStateXError = true; // Next time.
    }
    // Optionally call super for debugPrint()

    // Record the triggered event
    assert(() {
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine logErrorDetails() in $_consoleClassName');
      }
      return true;
    }());
  }

  /// Flag whether to log error details or not
  @override
  bool logStateXError = true;
}
