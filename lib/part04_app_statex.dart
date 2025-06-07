// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// The StateX object at the 'app level.' Used to effect the whole app by
/// being the 'root' of first State object instantiated.
///
/// dartdoc:
/// {@category Get started}
/// {@category StateX class}
/// {@category AppStateX class}
abstract class AppStateX<T extends StatefulWidget> extends StateX<T>
    with _ControllersById {
  ///
  AppStateX({
    super.controller,
    /// Optionally supply as many State Controllers as you like to work with this App.
    List<StateXController>? controllers,
    /// Optionally supply a 'data object' to to be accessible to the App's InheritedWidget.
    Object? object,
    @Deprecated('notifyClientsInBuild no longer necessary')
    bool? notifyClientsInBuild,
    @Deprecated('Use debugPrintEvents instead') bool? printEvents,
    super.debugPrintEvents,
    // Save the current error handler
  })  : _prevErrorFunc = FlutterError.onError,
        super(useInherited: true) {
    // Introduce its own error handler
    FlutterError.onError = _errorHandler;

    // Assign this property
    _appStateX = this;

    AppStateX._instance = this;

    _dataObj = object;
    addList(controllers?.toList());
  }
  // Save the current Error Handler.
  final FlutterExceptionHandler? _prevErrorFunc;

  // The 'data object' available to the framework.
  Object? _dataObj;

  static AppStateX? _instance;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    // Register this as a binding observer. Binding
    WidgetsBinding.instance.addObserver(this);
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree. In many cases, it is about to be 'disposed of'.
  @override
  void deactivate() {
    super.deactivate();
    // Return the original error handler
    FlutterError.onError = _prevErrorFunc;
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    // Introduce its own error handler
    FlutterError.onError = _errorHandler;
    super.activate();
  }

  /// Reference the State object returning the variable, _child
  State? _builderState;

  /// Reference the State object containing the app's InheritedWidget
  _InheritedWidgetState? _inheritedState;

  @override
  Widget buildF(BuildContext context) {
    _buildFOverridden = false;
    _inheritedState?.setState(() {}); // calls App's InheritedWidget
    _builderState?.setState(() {}); // calls builder()
    return _InheritedWidgetStatefulWidget(this);
  }

  /// Clean up memory
  /// Called when garbage collecting
  @override
  @protected
  @mustCallSuper
  void dispose() {
    _builderState = null;
    _inheritedState = null;
    _MapOfStates._states.clear();
    super.dispose();
  }

  /// Called when the system tells the app to pop the current route, such as
  /// after a system back button press or back gesture.
  @override
  @mustCallSuper
  Future<bool> didPopRoute() async {
    final pop = super.didPopRoute();
    // Loop through all the StateX objects
    final list = statesList(reversed: true, remove: this);
    for (final StateX state in list) {
      await state.didPopRoute();
    }
    return pop;
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  ///
  @override
  @mustCallSuper
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    //
    final handled = super.didPushRouteInformation(routeInformation);
    // Loop through all the StateX objects
    final list = statesList(reversed: true, remove: this);
    for (final StateX state in list) {
      await state.didPushRouteInformation(routeInformation);
    }
    return handled;
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  @mustCallSuper
  void didChangeMetrics() {
    super.didChangeMetrics();
    //
    forEachState((state) {
      state.didChangeMetrics();
    }, reversed: true, remove: this);
  }

  /// Called when the platform's text scale factor changes.
  @override
  @mustCallSuper
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    //
    forEachState((state) {
      state.didChangeTextScaleFactor();
    }, reversed: true, remove: this);
  }

  /// Called when the platform brightness changes.
  @override
  @mustCallSuper
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    //
    forEachState((state) {
      state.didChangePlatformBrightness();
    }, reversed: true, remove: this);
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  @override
  @mustCallSuper
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    //
    forEachState((state) {
      state.didChangeLocales(locales);
    }, reversed: true, remove: this);
  }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  /// AppLifecycleState.inactive:
  /// AppLifecycleState.hidden:
  /// AppLifecycleState.paused:
  /// AppLifecycleState.resumed:
  /// AppLifecycleState.detached:
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    super.didChangeAppLifecycleState(lifecycleState);
    //
    forEachState((state) {
      state.didChangeAppLifecycleState(lifecycleState);
    }, reversed: true, remove: this);
  }

  /// Called when a request is received from the system to exit the application.
  @override
  @mustCallSuper
  Future<AppExitResponse> didRequestAppExit() async {
    //
    var appResponse = await super.didRequestAppExit();
    //
    if (appResponse == AppExitResponse.exit) {
      final list = statesList(reversed: true, remove: this);
      // Loop through all the StateX objects
      for (final StateX state in list) {
        try {
          if (state.mounted && !state._deactivated) {
            final response = await state.didRequestAppExit();
            if (response == AppExitResponse.cancel) {
              // Cancel and do not exit the application.
              appResponse == response;
              break;
            }
          }
        } catch (e, stack) {
          // Record the error
          recordErrorInHandler(e, stack);
        }
      }
    }
    return appResponse;
  }

  /// Called when the system is running low on memory.
  @override
  @mustCallSuper
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    //
    forEachState((state) {
      state.didHaveMemoryPressure();
    }, reversed: true, remove: this);
  }

  /// Called when the system changes the set of currently active accessibility features.
  @override
  @mustCallSuper
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    //
    forEachState((state) {
      state.didChangeAccessibilityFeatures();
    }, reversed: true, remove: this);
  }

  /// In the SetState class?
  bool _inSetStateBuilder = false;

  /// Calls the State object's setState() function if not
  ///  (see class SetState).
  @override
  void setState(VoidCallback fn) {
    // Don't if already in the SetState.builder() function
    if (!_inSetStateBuilder) {
      super.setState(fn);
    }
  }

  /// Notify the InheritedWidget's dependencies
  @override
  bool notifyClients() {
    // Don't if already in the SetState.builder() function
    var notify = !_inSetStateBuilder;
    if (notify) {
      try {
        // Call the InheritedWidget again
        _inheritedState?.setState(() {});
        // catch any errors if called inappropriately
      } catch (e, stack) {
        // Throw in DebugMode.
        if (kDebugMode) {
          rethrow;
        } else {
          final details = FlutterErrorDetails(
            exception: e,
            stack: stack,
            library: 'state_extended.dart',
            context: ErrorDescription('notifyClient() error in $this'),
          );
          // Record the error
          logErrorDetails(details);
        }
      }
    }
    return notify;
  }

  /// Called when the State's InheritedWidget is called again
  /// This 'widget function' will be called again.
  @override
  // ignore: deprecated_member_use_from_same_package
  Widget setBuilder(WidgetBuilder? builder) => stateSet(builder);

  /// Called when the State's InheritedWidget is called again
  /// This 'widget function' will be called again.
  @override
  @Deprecated('Use setBuilder() instead.')
  Widget stateSet(WidgetBuilder? builder) {
    builder ??=
        (_) => const SizedBox.shrink(); // Display 'nothing' if not provided
    return StateDependentWidget(stateMixin: this, builder: builder);
  }

  /// Catch any errors in the App
  /// Free for you to override
  @override
  void onError(FlutterErrorDetails details) {
    _onErrorOverridden = false;
  }

  // onError() not called directly or was overwritten
  bool _onErrorOverridden = true;

  /// Catch and explicitly handle the error.
  void catchError(
    Exception? ex, {
    StackTrace? stack,
    String? library,
    DiagnosticsNode? context,
    IterableFilter<String>? stackFilter,
    InformationCollector? informationCollector,
    bool? silent,
  }) {
    if (ex == null) {
      return;
    }

    /// If a tester is running. Don't handle the error.
    if (inWidgetsFlutterBinding) {
      // (WidgetsBinding.instance is WidgetsFlutterBinding) {
      //
      FlutterError.onError!(FlutterErrorDetails(
        exception: ex,
        stack: stack,
        library: library ?? '',
        context: context,
        stackFilter: stackFilter,
        informationCollector: informationCollector,
        silent: silent ?? false,
      ));
    }
  }

  /// Handle any errors in this State object.
  void _errorHandler(FlutterErrorDetails details) {
    //
    try {
      //
      _onError(details);
    } catch (e, stack) {
      // Throw in DebugMode.
      if (kDebugMode) {
        // Set the original error routine. Allows the handler to throw errors.
        FlutterError.onError = _prevErrorFunc;
        // Rethrow to be handled by the original routine.
        rethrow;
      } else {
        // Record the error
        recordErrorInHandler(e, stack);

        // Record error in device's log
        _logPackageError(
          e,
          library: 'part04_app_statex.dart',
          description: 'Error in AppStateX Error Handler',
        );
      }
    }
  }

  /// Catch any errors in the App
  void _onError(FlutterErrorDetails details) {
    // Don't call this routine within itself.
    if (_inErrorRoutine) {
      return;
    }

    _inErrorRoutine = true;

    // Assign the error to a variable
    lastFlutterError(details);

    // Call the latest SateX object's error routine
    // Possibly the error occurred there.
    onStateError(details);

    // Log the error
    logErrorDetails(details);

    // Always test if there was an error in the error handler
    // Include it in the error reporting as well.
    if (hasErrorInErrorHandler) {
      _onErrorInHandler();
    }

    // The App's error handler
    if (_onErrorOverridden) {
      onError(details);
      // If in testing, after the supplied handler, call Flutter Testing Error handler
      if (!inWidgetsFlutterBinding) {
        //(WidgetsBinding.instance is! WidgetsFlutterBinding) {
        // An `Error` is a failure that the programmer should have avoided.
        if (details.exception is TestFailure || details.exception is Error) {
          // Allow an error to be ignored. Once!
          if (ignoreErrorInTesting) {
            _ignoreErrorInTesting = false;
          } else {
            _prevErrorFunc?.call(details);
          }
        }
      }
    } else {
      //  If no App Error Handler, run its own Error handler
      _prevErrorFunc?.call(details);
    }

    // Now out of the error handler
    _inErrorRoutine = false;
  }

  /// A flag testing the Error routine *INSIDE* the testing
  /// It's set and reset *ONLY* when testing.
  /// Allows a one-time even to ignore an error during testing.
  bool get ignoreErrorInTesting => _ignoreErrorInTesting ?? false;

  // Only set to true once and only in testing
  set ignoreErrorInTesting(bool? ignore) {
    // Assigns a value only in testing.
    if (ignore != null && !inWidgetsFlutterBinding) {
      //WidgetsBinding.instance is! WidgetsFlutterBinding) {
      // if (_ignoreErrorInTesting == null) {
      _ignoreErrorInTesting = ignore;
      // } else {
      //   // Once set false, it can't be changed again
      //   if (_ignoreErrorInTesting!) {
      //     _ignoreErrorInTesting = ignore;
      //   }
      // }
    }
  }

  //
  bool? _ignoreErrorInTesting;

  /// A flag indicating we're running in the error routine.
  /// Set to avoid infinite loop if in errors in the error routine.
  bool get inErrorRoutine => _inErrorRoutine;
  bool _inErrorRoutine = false;

  /// Supply the last Flutter Error Details if any.
  FlutterErrorDetails? get lastFlutterErrorDetails => _lastFlutterErrorDetails;

  /// Record and return details of the 'last' handled error
  /// Not, simply retrieving the last error will 'clear' the storage.
  FlutterErrorDetails? lastFlutterError([FlutterErrorDetails? details]) {
    FlutterErrorDetails? lastErrorDetails;
    if (details == null) {
      lastErrorDetails = _lastFlutterErrorDetails;
      _lastFlutterErrorDetails = null; // Clear the storage for next time.
    } else {
      _lastFlutterErrorDetails = details;
      lastErrorDetails = details;
    }
    return lastErrorDetails;
  }

  // Record the details of the last error if any
  FlutterErrorDetails? _lastFlutterErrorDetails;

  /// Return the message of th 'last' Flutter Error if any.
  String get lastFlutterErrorMessage {
    String message;
    final details = _lastFlutterErrorDetails;
    if (details == null) {
      message = '';
    } else {
      message = details.exceptionAsString();
    }
    if (message.contains('<no message available>')) {
      message = '';
    }
    return message;
  }

  /// Call the latest SateX object's error routine
  /// Possibly the error occurred there.
  bool onStateError(FlutterErrorDetails details) {
    //
    final state = lastState;

    // If it's this object, it will call its own later
    bool caught = state != null && state != this;

    if (caught) {
      //
      try {
        //
        final stack = details.stack?.toString();

        caught = stack != null;

        if (caught) {
          // That State object's build() function was called.
          var name = state.toString();
          name = name.substring(0, name.indexOf('#'));
          caught = stack.contains('$name.build');

          if (!caught) {
            // If it involves particular libraries
            final library = details.library;
            caught = library != null &&
                (library.contains('gesture') || library.contains('widgets'));
          }

          // Call the StateX's onError() function
          if (caught) {
            _errorStateName = name;
            onControllerError(state, details);
            state.onError(details);
          } else {
            _errorStateName = null;
          }

          // // Always test if there was an error in the error handler
          // // Include it in the error reporting as well.
          // if (hasError) {
          //   _onErrorInHandler();
          // }
        }
      } catch (e, stack) {
        // This is a public function. ALWAYS catch any error or exception
        // Throw in DebugMode.
        if (kDebugMode) {
          // Set the original error routine. Allows the handler to throw errors.
          FlutterError.onError = _prevErrorFunc;
          // Rethrow to be handled by the original routine.
          rethrow;
        } else {
          // Record the error
          recordErrorInHandler(e, stack);

          // Record error in device's log
          _logPackageError(
            e,
            library: 'part04_app_statex.dart',
            description: 'Error in onStateError()',
          );
        }
      }
    }
    return caught;
  }

  /// The name of the State object experiencing an error
  String get errorStateName => _errorStateName ?? '';
  String? _errorStateName;

  /// Step through its Controllers
  void onControllerError(StateX state, FlutterErrorDetails details) {
    /// You have the option to implement an error handler to individual controllers
    for (final con in state.controllerList) {
      try {
        con.onError(details);
      } catch (e, stack) {
        // Throw in DebugMode.
        if (kDebugMode) {
          // Set the original error routine. Allows the handler to throw errors.
          FlutterError.onError = _prevErrorFunc;
          // Rethrow to be handled by the original routine.
          rethrow;
        } else {
          // Record the error
          recordErrorInHandler(e, stack);

          // Record error in device's log
          _logPackageError(
            e,
            library: 'part04_app_statex.dart',
            description:
                'Error in onControllerError() for ${_consoleNameOfClass(con)}',
          );
        }
      }
    }
  }

  // Notify the developer there's an error in the error handler.
  void _onErrorInHandler() {
    // Always test first that indeed an exception had occurred.
    if (hasErrorInErrorHandler) {
      // Important to get the Stack Trace before it's cleared by recordException()
      final stack = recStackTrace;
      final exception = recordErrorInHandler();
      if (exception != null) {
        final details = FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'state_extended.dart',
          context: ErrorDescription('inside the Error Handler itself!'),
        );
        try {
          // Record the error
          logErrorDetails(details);
        } catch (e, stack) {
          // Error in the final error handler? That's a pickle.
          recordErrorInHandler(e, stack);
        }
      }
    }
  }
}

// /// Ensure there's no collision.
// class _PrivateGlobalKey<T extends State<StatefulWidget>>
//     extends GlobalObjectKey<T> {
//   const _PrivateGlobalKey(super.value);
// }

/// Supply a widget from a widget builder and possibly depend on InheritedWidget
class StateDependentWidget extends StatelessWidget {
  ///
  const StateDependentWidget({
    super.key,
    this.stateMixin,
    this.builder,
  });
  final InheritedWidgetStateMixin? stateMixin;
  final WidgetBuilder? builder;
  @override
  Widget build(BuildContext context) {
    stateMixin?.dependOnInheritedWidget(context);
    return builder?.call(context) ?? const SizedBox.shrink();
  }
}

/// Used in the package to present error to the console
void _logPackageError(
  Object? error, {
  String? library,
  String? description,
  DiagnosticsNode? context,
}) {
  // Must have an error
  if (error == null) {
    return;
  }

  if (library == null || library.isEmpty) {
    library = 'state_extended package';
  } else {
    library = library.trim();
  }

  if (context == null) {
    if (description != null && description.isNotEmpty) {
      context = ErrorDescription(description);
    }
  }

  final details = FlutterErrorDetails(
    exception: error,
    stack: error is Error ? error.stackTrace : null,
    library: library,
    context: context,
  );
  // Don't when in DebugMode.
  if (!kDebugMode) {
    // Resets the count of errors to show a complete error message not an abbreviated one.
    FlutterError.resetErrorCount();
  }
  // https://docs.flutter.dev/testing/errors#errors-caught-by-flutter
  // Log error
  FlutterError.presentError(details);
}
