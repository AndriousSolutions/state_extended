// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// The extension of the State class.
///
/// dartdoc:
/// {@category Testing}
/// {@category Get started}
/// {@category StateX class}
/// {@category Error handling}
/// {@category Event handling}
/// {@category Using FutureBuilder}
/// {@category Using InheritedWidget}
abstract class StateX<T extends StatefulWidget> extends State<StatefulWidget>
    with
        WidgetsBindingObserver,
        _ControllersByType,
        RootState,
        AsyncOps,
        FutureBuilderStateMixin,
        InheritedWidgetStateMixin,
        StateXonErrorMixin,
        RecordExceptionMixin,
        _MapOfStates
    implements StateListener {
  //
  /// With an optional StateXController parameter and use of built-in FutureBuilder & InheritedWidget
  StateX({
    StateXController? controller,
    bool? runAsync,
    bool? useInherited,
    bool? printEvents,
  }) {
    // Add to the list of StateX objects present in the app!
    _addToMapOfStates(this);
    // A flag whether the built-in FutureBuilder always runs.
    _runAsync = runAsync ?? false;
    // A flag determining whether the built-in InheritedWidget is used or not.
    _useInherited = useInherited ?? false;
    // Show the 'event' functions WidgetsBinding.instance.addObserver(this)
    _printEvents = printEvents ?? false;
    // Associate the controller to this State object
    _controller = controller;
    // Any subsequent calls to add() will be assigned to stateX.
    add(_controller);
  }

  /// Implement builder() function in your StateX class instead of build() to use
  /// the built-in FutureBuilder Widget and built-in InheritedWidget.
  ///
  /// Widget builder(BuildContext context)

  /// Implement buildF() function in your StateX class instead of the build() function
  /// to use the built-in FutureBuilder Widget and not the InheritedWidget.
  ///
  /// Widget buildF(BuildContext context)

  /// Implement the build() function in your StateX class to NOT use
  /// the built-in FutureBuilder Widget and built-in InheritedWidget
  ///
  /// Widget build(BuildContext context)
  ///

  // debugPrint the 'event' functions from WidgetsBinding.instance.addObserver(this)
  bool get printEvents => _printEvents;
  bool _printEvents = false;

  // Current controller
  StateXController? _controller;

  /// You need to be able access the widget.
  @override
  // ignore: avoid_as
  T get widget => super.widget as T;

  /// Provide the 'main' controller to this 'State View.'
  /// If _controller == null, get the 'first assigned' controller if any.
  StateXController? get controller => _controller ??= firstCon;

  /// Add a specific StateXController to this View.
  /// Returns the StateXController's unique String identifier.
  @override
  String add(StateXController? controller) {
    String id;
    if (controller == null) {
      id = '';
    } else {
      id = super.add(controller); // mixin _ControllersByType
      // Something is not right with that controller.
      if (id.isEmpty) {
        assert(() {
          final type = controller.runtimeType;
          if (_mapControllerByType.containsKey(type)) {
            final con = _mapControllerByType[type];
            if (con != null) {
              assert(
                controller.identifier == con.identifier,
                'Multiple instances of the same Controller class, $type, is not allowed in a StateX class. '
                'They are allowed in the AppStateX class but not in the StateX class. '
                'Either extend the Controller class, $type, or add to AppStateX. '
                "To then retrieve from the 'rootState', use its 'identifier' property. "
                'Controller classes with factory constructors are encouraged instead.',
              );
            }
          }
          return true;
        }());
      } else {
        /// This connects the StateXController to this State object!
        controller._pushStateToSetter(this);
      }
    }
    return id;
  }

  /// Remove a specific StateXController to this View.
  /// Returns the StateXController's unique String identifier.
  @override
  bool remove(StateXController? controller) =>
      super.remove(controller); // mixin _ControllersByType

  /// Update the 'first' controller if necessary
  /// Place in the [didUpdateWidget] function in the special case
  /// the StatefulWidget supplies the controller:
  /// e.g. didUpdateController(oldWidget.controller, widget.controller);
  bool didUpdateController({
    StateXController? oldCon,
    StateXController? newCon,
  }) {
    bool update = oldCon != null && newCon != null && _controller != null;
    // Test if supplied the parameters and there's a 'first' controller, _controller
    if (update) {
      // Don't bother if it's the same controller instance.
      update = _controller!.identifier != oldCon.identifier;

      if (update) {
        _controller = newCon;
      }
    }
    return update;
  }

  /// Add a list of 'Controllers' to be associated with this StatX object.
  @override
  List<String> addList(List<StateXController>? list) {
    if (list == null) {
      return <String>[];
    }
    // Associate a list of 'Controllers' to this StateX object at one time.
    return super.addList(list);
  }

  /// The unique identifier for this State object.
  @override
  String get identifier => _id;

  /// Contains the unique String identifier.
  @override
  final String _id = Uuid().generateV4();

  /// Retrieve a StateXController by type.
  @override
  U? controllerByType<U extends StateXController>() {
    // Look in this State object's list of Controllers.
    U? con = super.controllerByType<U>();

    // Check the 'App State' by type  if not yet found
    return con ??= rootState?.controllerByType<U>();
  }

  /// Retrieve a StateXController by its a unique String identifier.
  @override
  StateXController? controllerById(String? id) {
    // It's by id, look in the root state first
    StateXController? con = rootState?.controllerById(id);
    return con ??= super.controllerById(id);
  }

  /// May be set false to prevent unnecessary 'rebuilds'.
  static bool _setStateAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _setStateRequested = false;

  /// This is the 'latest' State being viewed by the App.
  bool get isLastState => this == lastState;

  /// Asynchronous operations must complete successfully.
  @override
  @mustCallSuper
  Future<bool> initAsync() async {
    // Always return true. It's got to continue for now.
    const init = true;

    // No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    int cnt = 0;
    StateXController con;

    // While loop the active list itself so to allow for additional controllers to be added in a previous initAsync()
    while (cnt < controllerList.length) {
      con = controllerList[cnt];
      try {
        final init = await con.initAsync();
        if (!init) {
          // Note the failure but ignore it
          final e = Exception('${con.runtimeType}.initAsync() returned false!');
          _initAsyncError(e, con);
        }
      } catch (e) {
        // Pass the error to the controller to handle
        _initAsyncError(e, con);
        // Have it handled by an error handler.
        rethrow;
      }
      cnt++;
    }
    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;

    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: initAsync() in $this');
      }
      return true;
    }());

    return init;
  }

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  @mustCallSuper
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
    super.initState();

    /// If 'AppState' is not used
    if (rootState == null) {
      /// Registers the given object as a binding observer. Binding
      /// observers are notified when various application events occur,
      /// for example when the system locale changes. Generally, one
      /// widget in the widget tree registers itself as a binding
      /// observer, and converts the system state into inherited widgets.
      WidgetsBinding.instance.addObserver(this);
    }

    /// Become aware of Route changes
    RouteObserverStates.subscribeRoutes(this);

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    int cnt = 0;
    StateXController con;

    // While loop the active list itself the so additional controllers can be added in a previous initState()
    while (cnt < controllerList.length) {
      con = controllerList[cnt];
      // Add this to the _StateSets Map
      con._addStateToSetter(this);
      con.initState();
      cnt++;
    }

    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;

    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: initState() in $this');
      }
      return true;
    }());
  }

  // /// Notify all the [Listenable] objects that are the State object's controllers.
  // void notifyListeners() {
  //
  //   /// No 'setState()' functions are allowed to fully function at this point.
  //   _setStateAllowed = false;
  //
  //   for (final con in controllerList) {
  //     con.notifyListeners();
  //   }
  //
  //   _setStateAllowed = true;
  //
  //   // The InheritedWidget will dictate if widgets are rebuilt.
  //   _setStateRequested = false;
  //
  //   assert(() {
  //     if (_printEvents) {
  //       debugPrint('============ Event: notifyListeners() in $this');
  //     }
  //     return true;
  //   }());
  // }


  /// This method is also called immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  /// When a InheritedWidget's build() function is called
  /// the dependent widget's build() function is also called but not before
  /// their didChangeDependencies() function. Subclasses rarely use this method.
  @override
  @mustCallSuper
  void didChangeDependencies() {
    // Important to 'markNeedsBuild()' first
    super.didChangeDependencies();

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangeDependencies();
    }

    _setStateAllowed = true;

    // The InheritedWidget will dictate if widgets are rebuilt.
    _setStateRequested = false;

    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didChangeDependencies() in $this');
      }
      return true;
    }());
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  @mustCallSuper
  void activate() {
    /// In most cases, after a [State] object has been deactivated, it is _not_
    /// reinserted into the tree, and its [dispose] method will be called to
    /// signal that it is ready to be garbage collected.
    ///
    /// In some cases, however, after a [State] object has been deactivated, the
    /// framework will reinsert it into another part of the tree (e.g., if the
    /// subtree containing this [State] object is grafted from one location in
    /// the tree to another due to the use of a [GlobalKey]).

    // Likely was deactivated.
    _deactivated = false;

    // Add to the list of StateX objects present in the app!
    _addToMapOfStates(this);

    // No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      // Supply the State object first
      con._pushStateToSetter(this);

      con.activate();
    }

    // Must call the 'super' routine as well.
    super.activate();

    /// Become aware of Route changes
    RouteObserverStates.subscribeRoutes(this);

    /// If 'AppState' is not used
    if (rootState == null) {
      // Registers the given object as a binding observer.
      WidgetsBinding.instance.addObserver(this);
    }

    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;

    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: activate() in $this');
      }
      return true;
    }());
  }

  /// Let the StateX simply be re-created
//   StateX? _oldStateX;
//
//   //
//   void _copyOverState() {
//     // Nothing to copy over
//     if (_oldStateX == null) {
//       return;
//     }
//     // Local variable
//     final oldStateX = _oldStateX!;
//
//     // If the previous State was 'resumed'. May want to recover further??
//     if (oldStateX._hadSystemEvent) {
//       // Reset so not to cause any side-affects.
//       oldStateX._hadSystemEvent = false;
//       // If a different object and the same type. (Thought because it was being recreated, but not the case. gp)
// //      if (this != oldStateX && runtimeType == oldStateX.runtimeType) {
//
//       var copyOver = this != oldStateX;
//
//       if (copyOver && controller != null && oldStateX.controller != null) {
//         copyOver = controller!.identifier == oldStateX.controller!.identifier;
//       }
//
//       if (copyOver) {
//         copyOver = controller.runtimeType == oldStateX.runtimeType;
//       }
//
//       if (copyOver) {
//         // Copy over certain properties
//         _copyOverStateFuture(oldStateX);
//         _copyOverStateControllers(oldStateX);
//         _copyOverStateException(oldStateX);
//         _copyOverStateDependencies(oldStateX);
//         updateNewStateX(oldStateX);
//
//         assert(() {
//           if (kDebugMode) {
//             debugPrint('============ _copyOverState(): $this copied $oldStateX');
//           }
//           return true;
//         }());
//
//         // Testing Flutter lifecycle operation
//         assert(() {
//           if (oldStateX.resumedAppLifecycle || oldStateX.deactivated) {
//             if (kDebugMode) {
//               print(
//                   '============ _copyOverState(): resumed: ${oldStateX.resumedAppLifecycle} deactivated: ${oldStateX.deactivated}');
//             }
//           }
//           return true;
//         }());
//       }
//     }
//     // cleanup
//     _oldStateX = null;
//   }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @override
  @mustCallSuper
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree.

    /// Users may have explicitly call this.
    if (_deactivated) {
      return;
    }

    // Indicate this State object is deactivated.
    _deactivated = true;

    /// Ignore Route changes
    RouteObserverStates.unsubscribeRoutes(this);

    /// If 'AppState' is not used
    if (rootState == null) {
      // Unregisters the given observer.
      WidgetsBinding.instance.removeObserver(this);
    }

    // No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      //
      con.deactivate();
      // Pop the State object from the controller
      con._popStateFromSetter(this);
    }

    super.deactivate();

    // Remove from the list of StateX objects present in the app!
    // I know! I know! It may be premature but Controllers still have access.
    _removeFromMapOfStates(this);

    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;

    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: deactivate() in $this');
      }
      return true;
    }());
  }

  /// State object's deactivated() was called.
  bool get deactivated => _deactivated;
  bool _deactivated = false;

  /// The framework calls this method when this [StateX] object will never
  /// build again and will be disposed of with garbage collection.
  @override
  @mustCallSuper
  void dispose() {
    /// The State object's lifecycle is terminated.
    /// **IMPORTANT** You will not know when this will run
    /// It's to the Flutter engines discretion. deactivate() is more reliable.
    /// Subclasses should override deactivate() method instead
    /// to release any resources  (e.g., stop any active animations).

    /// Users may have explicitly call this.
    if (_disposed || !_deactivated) {
      assert(() {
        debugPrint('StateX: dispose() already called in $this');
        return true;
      }());
      return;
    }

    /// Indicate this State object is terminated.
    _disposed = true;

    // No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    /// Call its controllers' dispose() functions
    for (final con in controllerList) {
      con.dispose();
    }

    // Remove any 'StateXController' reference
    _controller = null;

    // In some cases, the setState() will be called again! gp
    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;

    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: dispose() in $this');
      }
      return true;
    }());

    // Special case: Test if already disposed
    // _element is assigned null AFTER a dispose() call;
    if (mounted) {
      super.dispose();
    } else {
      assert(() {
        debugPrint('StateX: Not mounted so dispose() not called in $this');
        return true;
      }());
    }
  }

  /// Flag indicating this State object is disposed.
  /// Will be garbage collected.
  /// property, mounted, is then set to false.
  bool get disposed => _disposed;
  bool _disposed = false;

  /// Override this method to respond when its [StatefulWidget] is re-created.
  /// The framework always calls [build] after calling [didUpdateWidget], which
  /// means any calls to [setState] in [didUpdateWidget] are redundant.
  @override
  @mustCallSuper
  void didUpdateWidget(covariant T oldWidget) {
    /// No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didUpdateWidget(oldWidget);
    }

    super.didUpdateWidget(oldWidget);

    /// Re-enable setState() function
    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didUpdateWidget() in $this');
      }
      return true;
    }());
  }

  /// Called when the system puts the app in the background
  /// or returns the app to the foreground.
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    /// First, process the State object's own event functions.
    switch (state) {
      case AppLifecycleState.inactive:
        _inactiveAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        inactiveAppLifecycleState();
        _hiddenAppLifecycle = false;
        break;
      case AppLifecycleState.hidden:
        _hiddenAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        hiddenAppLifecycleState();
        _pausedAppLifecycle = false;
        break;
      case AppLifecycleState.paused:
        _pausedAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        pausedAppLifecycleState();
        _detachedAppLifecycle = false;
        _resumedAppLifecycle = false;
        break;
      case AppLifecycleState.detached:
        _detachedAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        detachedAppLifecycleState();
        break;
      case AppLifecycleState.resumed:
        _resumedAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        resumedAppLifecycleState();
        _inactiveAppLifecycle = false;
        break;
      default:
      // WARNING: Missing case clause
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        //ignore: avoid_print
        print(
            '============ Event: didChangeAppLifecycleState($state) in $this');
      }
      return true;
    }());
  }

  /// Loop through the StateX's controllers if any
  void _didChangeAppLifecycleStateXControllers(AppLifecycleState state) {
    //
    for (final con in controllerList) {
      con.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.inactive:
          con.inactiveAppLifecycleState();
          break;
        case AppLifecycleState.hidden:
          con.hiddenAppLifecycleState();
          break;
        case AppLifecycleState.paused:
          con.pausedAppLifecycleState();
          break;
        case AppLifecycleState.detached:
          con.detachedAppLifecycleState();
          break;
        case AppLifecycleState.resumed:
          con.resumedAppLifecycleState();
          break;
        default:
        // WARNING: Missing case clause
      }
    }
  }

  /// Apps in this state should assume that they may be [pausedAppLifecycleState] at any time.
  @override
  void inactiveAppLifecycleState() {}

  /// State object was in 'inactive' state
  bool get inactiveAppLifecycle => _inactiveAppLifecycle;
  bool _inactiveAppLifecycle = false;

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  @override
  void hiddenAppLifecycleState() {}

  /// State object was in a 'hidden' state
  bool get hiddenAppLifecycle => _hiddenAppLifecycle;
  bool _hiddenAppLifecycle = false;

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedAppLifecycleState() {}

  /// State object was in 'paused' state
  bool get pausedAppLifecycle => _pausedAppLifecycle;
  bool _pausedAppLifecycle = false;

  /// Either be in the progress of attaching when the  engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedAppLifecycleState() {}

  /// State object was in 'paused' state
  bool get detachedAppLifecycle => _detachedAppLifecycle;
  bool _detachedAppLifecycle = false;

  /// The application is visible and responding to user input.
  @override
  void resumedAppLifecycleState() {}

  /// State object was in 'resumed' state
  bool get resumedAppLifecycle => _resumedAppLifecycle;
  bool _resumedAppLifecycle = false;

  /// Called when a request is received from the system to exit the application.
  @override
  @mustCallSuper
  Future<AppExitResponse> didRequestAppExit() async {
    /// Exiting the application can proceed.
    var appResponse = AppExitResponse.exit;

    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return appResponse;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    // All must allow an exit or it's cancelled.
    for (final con in controllerList) {
      //
      final response = await con.didRequestAppExit();

      /// Cancel and do not exit the application.
      if (response == AppExitResponse.cancel) {
        // Record the 'cancel' response
        appResponse = response;
      }
    }

    _setStateAllowed = true;

    // If staying with the app and a setState() was requested.
    if (_setStateRequested && appResponse == AppExitResponse.cancel) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didRequestAppExit() in $this');
      }
      return true;
    }());

    return appResponse;
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  ///
  @override
  @mustCallSuper
  Future<bool> didPopRoute() async {
    /// Observers are expected to return true if they were able to
    /// handle the notification, for example by closing an active dialog
    /// box, and false otherwise. The [WidgetsApp] widget uses this
    /// mechanism to notify the [Navigator] widget that it should pop
    /// its current route if possible.
    ///
    /// This method exposes the `popRoute` notification from
    /// [SystemChannels.navigation].

    /// Set if a StateXController successfully 'handles' the notification.
    bool handled = false;

    // Don't if the State object is defunct.
    if (!mounted) {
      return handled;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      final didPop = await con.didPopRoute();
      if (didPop) {
        handled = true;
      }
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didPopRoute() in $this');
      }
      return true;
    }());

    // Return false to pop out
    return handled;
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification. Observers are notified in registration
  /// order until one returns true.
  ///
  /// This method exposes the `pushRouteInformation` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  ///
  @override
  @mustCallSuper
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    // Don't if the State object is defunct.
    if (!mounted) {
      return false;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      await con.didPushRouteInformation(routeInformation);
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didPushRouteInformation() in $this');
      }
      return true;
    }());

    return super.didPushRouteInformation(routeInformation);
  }

  /// The top route has been popped off, and this route shows up.
  @override
  @mustCallSuper
  void didPopNext() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didPopNext();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didPopNext() in $this');
      }
      return true;
    }());
  }

  /// Called when this route has been pushed.
  @override
  @mustCallSuper
  void didPush() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didPush();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didPush() in $this');
      }
      return true;
    }());
  }

  /// Called when this route has been popped off.
  @override
  @mustCallSuper
  void didPop() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didPop();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didPop() in $this');
      }
      return true;
    }());
  }

  /// New route has been pushed, and this route is no longer visible.
  @override
  @mustCallSuper
  void didPushNext() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didPushNext();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didPushNext() in $this');
      }
      return true;
    }());
  }

  /// State object experienced a system event
  bool get hadSystemEvent => _hadSystemEvent;
  // Reset in _pushStateToSetter()
  bool _hadSystemEvent = false;

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  @mustCallSuper
  void didChangeMetrics() {
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

    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangeMetrics();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didChangeMetrics() in $this');
      }
      return true;
    }());
  }

  /// Called when the platform's text scale factor changes.
  @override
  @mustCallSuper
  void didChangeTextScaleFactor() {
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

    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangeTextScaleFactor();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didChangeTextScaleFactor() in $this');
      }
      return true;
    }());
  }

  /// Called when the platform brightness changes.
  @override
  @mustCallSuper
  void didChangePlatformBrightness() {
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangePlatformBrightness();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '============ Event: didChangePlatformBrightness() in $this');
      }
      return true;
    }());
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    ///
    /// This method exposes notifications from [Window.onLocaleChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangeLocales(locales);
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didChangeLocales() in $this');
      }
      return true;
    }());
  }

  /// Called when the system is running low on memory.
  @override
  @mustCallSuper
  void didHaveMemoryPressure() {
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didHaveMemoryPressure();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: didHaveMemoryPressure() in $this');
      }
      return true;
    }());
  }

  /// Called when the system changes the set of currently active accessibility features.
  @override
  @mustCallSuper
  void didChangeAccessibilityFeatures() {
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangeAccessibilityFeatures();
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint(
            '============ Event: didChangeAccessibilityFeatures() in $this');
      }
      return true;
    }());
  }

  /// During development, if a hot reload occurs, the reassemble method is called.
  /// This provides an opportunity to reinitialize any data that was prepared
  /// in the initState method.
  @override
  @mustCallSuper
  void reassemble() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      //
      con.reassemble();
    }

    super.reassemble();

    _setStateAllowed = true;

    /// No 'setState()' function is necessary
    /// The framework always calls build with a hot reload.
    _setStateRequested = false;

    // Record the triggered event
    assert(() {
      if (_printEvents) {
        debugPrint('============ Event: reassemble() in $this');
      }
      return true;
    }());
  }

  /// Allows 'external' routines to  call this function.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  @override
  void setState(VoidCallback fn) {
    //
    if (_setStateAllowed) {
      //
      _setStateAllowed = false;

      // Don't bother if the State object is disposed of.
      if (mounted) {
        /// Refresh the interface by 'rebuilding' the Widget Tree
        /// Call the State object's setState() function.
        super.setState(fn);
        // /// Call any [Listenable] objects.
        // notifyListeners();
      }
      _setStateAllowed = true;
    } else {
      /// Can't rebuild at this moment but at least make the request.
      _setStateRequested = true;
    }
  }
}
