// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// An extension of Flutter's State class.
///
/// dartdoc:
/// {@category Testing}
/// {@category Get started}
/// {@category StateX class}
/// {@category Error handling}
/// {@category Event handling}
/// {@category Using FutureBuilder}
/// {@category Using InheritedWidget}
class StateX<T extends StatefulWidget> extends State<StatefulWidget>
    with
        WidgetsBindingObserver,
        WidgetsBindingInstanceMixin,
        StateXControllersByTypeMixin,
        AppStateMixin,
        FutureBuilderStateMixin,
        AsyncOps,
        StateXEventHandlers,
        StateXonErrorMixin,
        InheritedWidgetStateMixin,
        ErrorInErrorHandlerMixin,
        MapOfStateXsMixin
    implements StateXEventHandlers {
  //
  /// With an optional StateXController parameter.
  /// Two indicators to use built-in FutureBuilder & InheritedWidget.
  /// printEvents deprecated. Use debugPrintEvents instead.
  /// debugPrintEvents will print events to console.
  StateX({
    StateXController? controller,
    bool? runAsync,
    bool? useInherited,
    bool? printEvents,
    bool? debugPrintEvents,
  }) {
    // Add to the list of StateX objects present in the app!
    _addToMapOfStates(this);
    _consoleLeadingLine = '===========';

    // A flag whether the built-in FutureBuilder always runs.
    _runAsync = runAsync ?? false;
    // A flag determining whether the built-in InheritedWidget is used or not.
    _useInherited = useInherited ?? false;
    // Show the 'event handler' functions
    _debugPrintEvents = debugPrintEvents ?? printEvents ?? false;
    // Associate the controller to this State object
    _controller = controller;
    // If State prints events, so does its Controllers
    if (_debugPrintEvents) {
      _controller?._debugPrintEvents = _debugPrintEvents;
    }
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

  // Current controller
  StateXController? _controller;

  /// Access the StatefulWidget widget.
  @override
  T get widget => super.widget as T;

  /// Provide the 'main' controller to this State object.
  /// If _controller == null, get the 'first assigned' controller if any.
  StateXController? get controller => _controller ??= firstCon;

  /// The App's State object
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

  // May have to assign directly
  set appStateX(AppStateX? appState) {
    if (_appStateX == null) {
      if (appState != null) {
        _appStateX = appState;
      }
    }
  }

  /// Add a specific StateXController to this State object.
  /// Returns the StateXController's unique String identifier.
  @override
  String add(StateXController? controller) {
    // Supply a reference to the App State object if any
    controller?._appStateX = appStateX;

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
        if (controller._pushStateToSetter(this)) {
          // If just added, assign as the 'current' state object.
          controller._state = this;
        }
      }
    }
    return id;
  }

  /// Remove a specific StateXController to this State object.
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

  @override
  @Deprecated('Use addAll() instead.')
  List<String> addList(List<StateXController>? list) => addAll(list);

  /// Add a list of 'Controllers' to be associated with this StatX object.
  @override
  List<String> addAll(List<StateXController>? list) {
    if (list == null) {
      return <String>[];
    }
    // Associate a list of 'Controllers' to this StateX object at one time.
    return super.addAll(list);
  }

  /// The unique identifier for this State object.
  @override
  String get identifier => _id;

  /// Retrieve a StateXController by type.
  @override
  U? controllerByType<U extends StateXController>() {
    // Look in this State object's list of Controllers.
    U? con = super.controllerByType<U>();

    // Check the 'App State' by type  if not yet found
    return con ??= appStateX?.controllerByType<U>();
  }

  /// Retrieve a StateXController by its a unique String identifier.
  @override
  StateXController? controllerById(String? id) {
    // It's by id, look in the 'App State' first
    StateXController? con = appStateX?.controllerById(id);
    return con ??= super.controllerById(id);
  }

  /// May be set false to prevent unnecessary 'rebuilds'.
  static bool _setStateAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _setStateRequested = false;

  /// This is the 'latest' State being viewed by the App.
  bool get isLastState => this == lastState;

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
        // Refresh the interface by 'rebuilding' the Widget Tree
        // Call the State object's setState() function.
        super.setState(fn);
        assert(() {
          if (_debugPrintEvents) {
            debugPrint('$_consoleLeadingLine setState() in $this');
          }
          return true;
        }());
      }
      _setStateAllowed = true;
    } else {
      // Can't rebuild at this moment but at least make the request.
      _setStateRequested = true;
    }
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
    // Optionally call super for debugPrint()
    super.initState();

    /// If 'AppState' is not used
    if (appStateX == null) {
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
    //_setStateAllowed = false;

    int cnt = 0;
    StateXController con;

    // While loop the active list itself the so additional controllers can be added in a previous initState()
    while (cnt < controllerList.length) {
      con = controllerList[cnt];
      // Add this to the _StateSets Map
      con._addStateToSetter(this);
      if (!con.initStateCalled) {
        con._initStateCalled = true;
        con.initState();
      }
      con.stateInit(this);
      cnt++;
    }

    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;
  }

  /// Asynchronous operations must complete successfully.
  @override
  @mustCallSuper
  Future<bool> initAsync() async {
    // Optionally call super for debugPrint()
    super.initAsync();

    // Always return true. It's got to continue for now.
    const init = true;

    // No 'setState()' functions are allowed to fully function at this point.
    // _setStateAllowed = false;

    int cnt = 0;
    StateXController con;

    // While loop the active list itself so to allow for additional controllers to be added in a previous initAsync()
    while (cnt < controllerList.length) {
      con = controllerList[cnt];
      try {
        bool init = true;
        if (_runAsync || !con.initAsyncCalled) {
          init = await con.initAsync();
        }
        if (init) {
          init = await con.initAsyncState(this);
        }
        if (!init) {
          // Note the failure but ignore it
          final e = Exception('${con.runtimeType}.initAsync() returned false!');
          _initAsyncError(e, con);
        }
      } catch (e, stack) {
        // Pass the error to the controller to handle
        _initAsyncError(e, con, stack: stack);
        // Have it handled by an error handler.
        rethrow;
      }
      cnt++;
    }
    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;
    return init;
  }

  /// Calls initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @override
  bool runInitAsync() {
    // Optionally call super for debugPrint()
    bool runInit = super.runInitAsync();
    // If any Controller says 'no', then there's no run.
    for (final con in controllerList) {
      runInit = con.runInitAsync();
      if (!runInit) {
        break;
      }
    }
    return runInit;
  }

  /// Called with every [StateX] associated with this Controller
  /// Initialize any 'time-consuming' operations at the beginning.
  /// Implement any asynchronous operations needed done at start up.
  // Save on function calls
  // @override
  // Future<bool> initAsyncState(covariant State state) async {
  //   // Optionally call super for debugPrint()
  //   super.initAsyncState(state);
  //   return true;
  // }

  /// initAsync() has failed and a 'error' widget instead will be displayed.
  /// This takes in the snapshot.error details.
  // Save on function calls
  // @override
  // void onAsyncError(FlutterErrorDetails details) {
  //   // Optionally call super for debugPrint()
  //   super.onAsyncError(details);
  // }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @override
  @mustCallSuper
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree.
    //
    if (!_deactivated) {
      try {
        // runZonedGuarded<void>(() {
        // scheduleMicrotask(() {

        // Ignore Route changes
        RouteObserverStates.unsubscribeRoutes(this);

        // Users may have explicitly call this.
        if (_deactivated) {
          return;
        }

        // Indicate this State object is deactivated.
        _deactivated = true;

        // No 'setState()' functions are allowed to fully function at this point.
//    _setStateAllowed = false;

        for (final con in controllerList) {
          con.deactivateState(this);
          // Pop the State object from the controller
          con._popStateFromSetter(this);
          if (con.lastState == null) {
            con.deactivate();
          }
        }

        _setStateAllowed = true;

        // In some cases, if then reinserted back in another part of the tree
        // the build is called, and so setState() is not necessary.
        _setStateRequested = false;

        super.deactivate();
        // });
      } catch (e) {
        // }, (error, stackTrace) {
        // Record error in device's log
        _logPackageError(
          e,
          library: 'part01_statex.dart',
          description: 'Error in deactivate()',
        );
        // });
      }
    }
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

    /// Become aware of Route changes
    RouteObserverStates.subscribeRoutes(this);

    // No 'setState()' functions are allowed to fully function at this point.
    //   _setStateAllowed = false;

    for (final con in controllerList) {
      if (con.lastState == null) {
        con.activate();
      }
      con._pushStateToSetter(this);
      con.activateState(this);
    }

    // Add to the list of StateX objects present in the app!
    _addToMapOfStates(this);

    // Optionally call super for debugPrint()
    super.activate();

    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;
  }

  /// State object's deactivated() was called.
  bool get deactivated => _deactivated;
  bool _deactivated = false;

  /// The framework calls this method when this [StateX] object will never
  /// build again and will be disposed of with garbage collection.
  @override
  @mustCallSuper
  void dispose() {
    // **IMPORTANT** Call super.dispose() below instead
    /// The State object's lifecycle is terminated.
    /// **IMPORTANT** You will not know when this will run
    /// It's to the Flutter engines discretion. deactivate() is more reliable.
    /// Subclasses should override deactivate() method instead
    /// to release any resources  (e.g., stop any active animations).
    try {
      // runZonedGuarded<void>(() {
      // scheduleMicrotask(() {
      // Remove from the list of StateX objects present in the app!
      // It may be premature but Controllers still have access.
      _removeFromMapOfStates(this);

      // If 'AppState' is not used
      if (appStateX == null) {
        // Unregisters the given observer.
        WidgetsBinding.instance.removeObserver(this);
      }

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
        con.disposeState(this);
        if (con.lastState == null) {
          con.dispose();
        }
      }

      // Remove any 'StateXController' reference
      _controller = null;

      // Remove App State object
      _appStateX = null;

      // In some cases, the setState() will be called again! gp
      _setStateAllowed = true;

      // In some cases, if then reinserted back in another part of the tree
      // the build is called, and so setState() is not necessary.
      _setStateRequested = false; // Special case: Test if already disposed

      if (mounted) {
        super.dispose();
        assert(() {
          if (_debugPrintEvents) {
            debugPrint('$_consoleLeadingLine dispose() in $this');
          }
          return true;
        }());
      } else {
        assert(() {
          debugPrint('StateX: Not mounted so dispose() not called in $this');
          return true;
        }());
      }
      // });
      // }, (error, stackTrace) {
    } catch (e) {
      _logPackageError(
        e,
        library: 'part01_statex.dart',
        description: 'Error in dispose()',
      );
      // });
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
//    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didUpdateWidget(oldWidget);
    }

    super.didUpdateWidget(oldWidget);

    /// Re-enable setState() function
    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;
  }

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

    if (_firstBuild == null) {
      _firstBuild = true;
    } else {
      _firstBuild = false;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.didChangeDependencies();
    }

    _setStateAllowed = true;

    // The InheritedWidget will dictate if widgets are rebuilt.
    _setStateRequested = false;
  }

  /// State object's first build or will be its first build
  bool get firstBuild => _firstBuild ?? true;
  bool? _firstBuild;

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  @mustCallSuper
  void didChangeMetrics() {
    super.didChangeMetrics();

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
//    _setStateAllowed = false;

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
  }

  /// Called when the platform's text scale factor changes.
  @override
  @mustCallSuper
  void didChangeTextScaleFactor() {
    // Optionally call the debugPrint() function
    super.didChangeTextScaleFactor();

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
//    _setStateAllowed = false;

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
  }

  /// Called when the platform brightness changes.
  @override
  @mustCallSuper
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
//    _setStateAllowed = false;

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
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    ///
    /// This method exposes notifications from [Window.onLocaleChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
//    _setStateAllowed = false;

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
  }

  /// Called when the system changes the set of currently active accessibility features.
  @override
  @mustCallSuper
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    // A triggered system event
    _hadSystemEvent = true;

    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }

    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
//    _setStateAllowed = false;

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
  }

  /// Called when the system is running low on memory.
  @override
  @mustCallSuper
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
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
//    _setStateAllowed = false;

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
  }

  /// Determine if its dependencies should be updated.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    //
    // Don't if the State object is defunct.
    if (!mounted) {
      return false;
    }

    // Record the triggered event
    assert(() {
      if (_debugPrintEvents) {
        debugPrint(
            '$_consoleLeadingLine updateShouldNotify() in $_consoleClassName');
      }
      return true;
    }());

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    bool update = true;

    for (final con in controllerList) {
      update = con.updateShouldNotify(oldWidget);
      // If even one controller says 'no', there's no update.
      if (!update) {
        break;
      }
    }

    _setStateAllowed = true;

    /// No 'setState()' function is necessary
    /// The framework always calls build with a hot reload.
    _setStateRequested = false;

    return update;
  }

  /// Called when the system puts the app in the background
  /// or returns the app to the foreground.
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    /// No 'setState()' functions are allowed to fully function at this point.
    //   _setStateAllowed = false;

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
      case AppLifecycleState.resumed:
        _resumedAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        resumedAppLifecycleState();
        _inactiveAppLifecycle = false;
        break;
      case AppLifecycleState.detached:
        _detachedAppLifecycle = true;
        _didChangeAppLifecycleStateXControllers(state);
        detachedAppLifecycleState();
        break;
      //default:
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
        // default:
        // WARNING: Missing case clause
      }
    }
  }

  /// Apps in this state should assume that they may be [pausedAppLifecycleState] at any time.
  @override
  void inactiveAppLifecycleState() {
    // Don't call deactivate() if in testing
    if (inWidgetsFlutterBinding) {
      deactivate();
    }
    super.inactiveAppLifecycleState();
  }

  /// State object was in 'inactive' state
  bool get inactiveAppLifecycle => _inactiveAppLifecycle;
  bool _inactiveAppLifecycle = false;

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  // Save on function calls
  // @override
  // void hiddenAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.hiddenAppLifecycleState();
  // }

  /// State object was in a 'hidden' state
  bool get hiddenAppLifecycle => _hiddenAppLifecycle;
  bool _hiddenAppLifecycle = false;

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  /// (Called only in iOS, Android)
  // Save on function calls
  // @override
  // void pausedAppLifecycleState() {
  //   // Optionally call super for debugPrint()
  //   super.pausedAppLifecycleState();
  // }

  /// State object was in 'paused' state
  bool get pausedAppLifecycle => _pausedAppLifecycle;
  bool _pausedAppLifecycle = false;

  /// The application is visible and responding to user input.
  @override
  void resumedAppLifecycleState() {
    //
    try {
      // runZonedGuarded<void>(() {
      // Don't call activate() if in testing
      if (inWidgetsFlutterBinding) {
        if (_deactivated) {
          activate();
        }
      }
      super.resumedAppLifecycleState();
    } catch (e, stack) {
      // }, (error, stackTrace) {
      // An error in the error handler. Record the error
      recordErrorInHandler(e, stack);
      // Record error in device's log
      _logPackageError(
        e,
        library: 'part01_statex.dart',
        description: 'Error in resumedAppLifecycleState()',
      );
    }
    // });
  }

  /// State object was in 'resumed' state
  bool get resumedAppLifecycle => _resumedAppLifecycle;
  bool _resumedAppLifecycle = false;

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  /// The application is still hosted on a flutter engine but is detached from any host views.
  /// Its firing will depending on the hosting operating system:
  /// https://github.com/flutter/flutter/issues/124945#issuecomment-1514159238
  @override
  void detachedAppLifecycleState() {
    // Don't call dispose() if in testing
    if (inWidgetsFlutterBinding) {
      if (!_disposed) {
        dispose();
      }
      //
      try {
        // runZonedGuarded<void>(() {
        super.detachedAppLifecycleState();
      } catch (e) {
        // }, (error, stackTrace) {
        // Record error in device's log
        _logPackageError(
          e,
          library: 'part01_statex.dart',
          description: 'Error in detachedAppLifecycleState()',
        );
        // });
      }
    }
  }

  /// State object was in 'paused' state
  bool get detachedAppLifecycle => _detachedAppLifecycle;
  bool _detachedAppLifecycle = false;

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
      con.reassemble();
    }

    // Optionally call super for debugPrint()
    super.reassemble();

    _setStateAllowed = true;

    /// No 'setState()' function is necessary
    /// The framework always calls build with a hot reload.
    _setStateRequested = false;
  }

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

    if (appResponse == AppExitResponse.exit) {
      // Optionally call super for debugPrint()
      appResponse = await super.didRequestAppExit();
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
    return appResponse;
  }

  /// Called at the start of a predictive back gesture.
  /// If an observer returns true then that observer, and only that observer,
  /// will be notified of subsequent events in
  /// this same gesture (for example [handleUpdateBackGestureProgress], etc.).
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    //
    var handled = false;

    // Don't if the State object is defunct.
    if (!mounted) {
      return handled;
    }
    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      handled = con.handleStartBackGesture(backEvent);
      if (handled) {
        break;
      }
    }

    // Optionally call the debugPrint() function
    handled = super.handleStartBackGesture(backEvent);

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    return handled;
  }

  /// Called when a predictive back gesture moves.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }
    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.handleUpdateBackGestureProgress(backEvent);
    }

    // Optionally call the debugPrint() function
    super.handleUpdateBackGestureProgress(backEvent);

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when a predictive back gesture is finished successfully, indicating
  /// that the current route should be popped.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  @override
  void handleCommitBackGesture() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }
    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.handleCommitBackGesture();
    }

    // Optionally call the debugPrint() function
    super.handleCommitBackGesture();

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when a predictive back gesture is canceled, indicating that no
  /// navigation should occur.
  ///
  /// The observer which was notified of this gesture's [handleStartBackGesture]
  /// is the same observer notified for this.
  ///
  /// Currently, this is only used on Android devices that support the
  /// predictive back feature.
  @override
  void handleCancelBackGesture() {
    // Don't if the State object is defunct.
    if (!mounted) {
      return;
    }
    // No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.handleCancelBackGesture();
    }

    // Optionally call the debugPrint() function
    super.handleCancelBackGesture();

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
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
    //   _setStateAllowed = false;

    for (final con in controllerList) {
      final didPop = await con.didPopRoute();
      if (didPop) {
        handled = true;
      }
    }

    if (handled) {
      // Optionally call super for debugPrint()
      handled = await super.didPopRoute();
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
    // Return false to pop out
    return handled;
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
  @override
  @Deprecated('Use didPushRouteInformation instead. '
      'This feature was deprecated after v3.8.0-14.0.pre.')
  Future<bool> didPushRoute(String route) async {
    // Optionally call super for debugPrint()
    super.didPushRoute(route);
    // Return false to pop out
    return false;
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

    // Optionally call super for debugPrint()
    super.didPushRouteInformation(routeInformation);

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
    return super.didPushRouteInformation(routeInformation);
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

    // Optionally call debugPrint()
    super.didPush();

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
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

    // Optionally call super for debugPrint()
    super.didPushNext();

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
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
    //   _setStateAllowed = false;

    for (final con in controllerList) {
      con.didPop();
    }

    // Optionally call super for debugPrint()
    super.didPop();

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
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
    //   _setStateAllowed = false;

    for (final con in controllerList) {
      con.didPopNext();
    }

    // Optionally call super for debugPrint()
    super.didPopNext();

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isLastState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// State object experienced a system event
  bool get hadSystemEvent => _hadSystemEvent;

  // Reset in _pushStateToSetter()
  bool _hadSystemEvent = false;

  /// Offer an error handler
// // Overrides StateXonErrorMixin in part20_statex_error_mixin.dart
// @override
// void onError(FlutterErrorDetails details) {
//   // It is not mandatory to call this method
//   // No debugPrint() here in case it too will error
//   super.onError(details);
// }

  /// Logs 'every' error as the error count is reset.
// // Overrides StateXonErrorMixin in part20_statex_error_mixin.dart
// @override
// void logErrorDetails(FlutterErrorDetails details, {bool? force}) {
//   super.logErrorDetails(details, force: force);
// }
}
