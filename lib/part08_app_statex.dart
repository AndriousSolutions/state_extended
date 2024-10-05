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
  /// Optionally supply as many State Controllers as you like to work with this App.
  /// Optionally supply a 'data object' to to be accessible to the App's InheritedWidget.
  AppStateX({
    super.controller,
    List<StateXController>? controllers,
    Object? object,
    super.printEvents,
    // Save the current error handler
  }) : _prevErrorFunc = FlutterError.onError {
    // Introduce its own error handler
    FlutterError.onError = _errorHandler;

    //Record this as the 'root' State object.
    setRootStateX(this);
    _dataObj = object;
    addList(controllers?.toList());
  }
  // Save the current Error Handler.
  final FlutterExceptionHandler? _prevErrorFunc;

  // The 'data object' available to the framework.
  Object? _dataObj;

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
    super.activate();
    // Introduce its own error handler
    FlutterError.onError = _errorHandler;
  }

  /// Reference the State object returning the variable, _child
  _BuilderState? _builderState;

  /// Reference the State object containing the app's InheritedWidget
  _InheritedWidgetState? _inheritedState;

  @override
  Widget buildF(BuildContext context) {
    _buildFOverridden = false;
    _builderState?.setState(() {}); // calls builder()
    return const _InheritedWidgetStatefulWidget();
  }

  /// Clean up memory
  /// Called when garbage collecting
  @override
  @protected
  @mustCallSuper
  void dispose() {
    _builderState = null;
    _inheritedState = null;
    _clearRootStateX();
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
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    super.didChangeAppLifecycleState(lifecycleState);
    //
    forEachState((state) {
      state.didChangeAppLifecycleState(lifecycleState);
    }, reversed: true, remove: this);
  }

  /// Calls the deactivate() and dispose() functions
  /// in all the app's StateX class objects
  /// It's success will depending on the hosting operating system:
  /// https://github.com/flutter/flutter/issues/124945#issuecomment-1514159238
  @override
  @protected
  @mustCallSuper
  void detachedAppLifecycleState() {
    //
    forEachState((state) {
      //
      try {
        state.deactivate();
      } catch (e, stack) {
        // An error in the error handler. Record the error
        recordException(e, stack);
        _onErrorInHandler();
      }

      try {
        if (!state._disposed) {
          state.dispose();
        }
      } catch (e, stack) {
        // An error in the error handler. Record the error
        recordException(e, stack);
        _onErrorInHandler();
      }
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
      //
      final list = statesList(reversed: true, remove: this);
      // Loop through all the StateX objects
      for (final StateX state in list) {
        //
        try {
          //
          if (state.mounted && !state._deactivated) {
            //
            final response = await state.didRequestAppExit();

            if (response == AppExitResponse.cancel) {
              // Cancel and do not exit the application.
              appResponse == response;
              break;
            }
          }
        } catch (e, stack) {
          // Record the error
          recordException(e, stack);
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

  ///
  ///  Set the specified widget (through its context) as a dependent of the InheritedWidget
  ///
  ///  Return false if not configured to use the InheritedWidget
  @override
  bool dependOnInheritedWidget(BuildContext? context) {
    final depend = context != null;
    if (depend) {
      if (_inheritedElement == null) {
        _dependencies.add(context);
      } else {
        context.dependOnInheritedElement(_inheritedElement!);
      }
    }
    return depend;
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
  Widget stateSet(WidgetBuilder? widgetFunc) {
    widgetFunc ??=
        (_) => const SizedBox.shrink(); // Display 'nothing' if not provided
    return _SetStateXWidget(stateX: this, widgetFunc: widgetFunc);
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
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
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
    } catch (e) {
      // Throw in DebugMode.
      if (kDebugMode) {
        // Set the original error routine. Allows the handler to throw errors.
        FlutterError.onError = _prevErrorFunc;
        // Rethrow to be handled by the original routine.
        rethrow;
      } else {
        // Record error in log
        _logPackageError(
          e,
          library: 'part08_app_statex.dart',
          description: 'Error in AppStateX Error Handler',
        );
      }
    }
  }

  /// Catch any errors in the App
  /// Free to override if you must
  void _onError(FlutterErrorDetails details) {
    // Don't call this routine within itself.
    if (_inErrorRoutine) {
      return;
    }

    _inErrorRoutine = true;

    // Call the latest SateX object's error routine
    // Possibly the error occurred there.
    onStateError(details);

    // Record to logs
    logErrorDetails(details);

    // Always test if there was an error in the error handler
    // Include it in the error reporting as well.
    if (hasError) {
      _onErrorInHandler();
    }

    // The App's error handler
    onError(details);

    //  its own Error handler
    if (!_onErrorOverridden && _prevErrorFunc != null) {
      _prevErrorFunc!.call(details);
    }

    // Now out of the error handler
    _inErrorRoutine = false;
  }

  /// Record and return details of the 'last' handled error
  FlutterErrorDetails? lastFlutterError([FlutterErrorDetails? details]) {
    FlutterErrorDetails? lastErrorDetails;
    if (details == null) {
      lastErrorDetails = _handledErrorDetails;
    } else {
      lastErrorDetails = _handledErrorDetails = details;
    }
    return lastErrorDetails;
  }

  // Record the details of the last error if any
  FlutterErrorDetails? _handledErrorDetails;

  /// A flag indicating we're running in the error routine.
  /// Set to avoid infinite loop if in errors in the error routine.
  bool _inErrorRoutine = false;

  /// Call the latest SateX object's error routine
  /// Possibly the error occurred there.
  bool onStateError(FlutterErrorDetails details) {
    //
    final state = lastState;

    bool caught = state != null;

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
          if (caught && state != this) {
            _errorStateName = name;
            state.onError(details);
          } else {
            _errorStateName = null;
          }
        }
      } catch (e, stack) {
        recordException(e, stack);
      }
      // Always test if there was an error in the error handler
      // Include it in the error reporting as well.
      if (hasError) {
        _onErrorInHandler();
      }
    }
    return caught;
  }

  /// The name of the State object experiencing an error
  String get errorStateName => _errorStateName ?? '';
  String? _errorStateName;

  // Notify the developer there's an error in the error handler.
  void _onErrorInHandler() {
    // Always test first that indeed an exception had occurred.
    if (hasError) {
      // Important to get the Stack Trace before it's cleared by recordException()
      final stack = stackTrace;
      final exception = recordException();
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
          recordException(e, stack);
        }
      }
    }
  }
}

/// Supply a widget to depend upon a StateX's InheritedWidget
class _SetStateXWidget extends StatelessWidget {
  ///
  const _SetStateXWidget({
    required this.stateX,
    required this.widgetFunc,
  });
  final StateX stateX;
  final WidgetBuilder widgetFunc;
  @override
  Widget build(BuildContext context) {
    stateX.dependOnInheritedWidget(context);
    return widgetFunc(context);
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
