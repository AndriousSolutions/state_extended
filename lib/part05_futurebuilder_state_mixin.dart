// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Supply a FutureBuilder to a State object.
///
/// dartdoc:
/// {@category StateX class}
/// {@category Using FutureBuilder}
mixin FutureBuilderStateMixin on State {
  /// Implement this function instead of the build() function
  /// to utilize a built-in FutureBuilder Widget.
  Widget buildF(BuildContext context) => const SizedBox();

  /// Supply a 'splash screen' while the FutureBuilder is processing.
  Widget? onSplashScreen(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    // A little trick to determine if the user has overridden this function.
    _buildOverridden = false;
    // Generate the Future evey time or just once
    if ((_runAsync && runInitAsync()) || _future == null) {
      _future = initAsync();
      _future?.catchError(
        (Object e) async {
          try {
            _caughtAsyncError = await catchAsyncError(e);
          } catch (e) {
            _caughtAsyncError = false;
            // Record error in log
            _logPackageError(
              e,
              library: 'part05_futurebuilder_state_mixin.dart',
              description: 'Exception in catchAsyncError()',
            );
          }
          // May possibly recover from the error or exception
          return _caughtAsyncError;
        },
        // It's got to be handled, and so it's always true to call catchError()
        test: (_) => true,
      );
    }
    return FutureBuilder<bool>(
      key: ValueKey<State>(this),
      future: _future,
      initialData: false,
      builder: (context, snapshot) {
        // We're ignoring an error or exception.
        // Hope you know what you're doing!
        if (_caughtAsyncError) {
          snapshot =
              AsyncSnapshot<bool>.withData(snapshot.connectionState, true);
        }
        return _futureBuilder(context, snapshot);
      },
    );
  }

  /// A flag noting if the build() function was overridden or not.
  bool get buildOverridden => _buildOverridden;
  bool _buildOverridden = true;

  /// A flag noting an Async error was caught or not
  bool get caughtAsyncError => _caughtAsyncError;
  bool _caughtAsyncError = false;

  /// Clean up
  @override
  void dispose() {
    _future = null;
    super.dispose();
  }

  // Call initAsync() all the time if set true.
  bool _runAsync = false;

  /// Call initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @protected
  bool runInitAsync() => true;

  /// IMPORTANT
  /// The _future must be created first. If the _future is created at the same
  /// time as the FutureBuilder, then every time the FutureBuilder's parent is
  /// rebuilt, the asynchronous task will be performed again.
  Future<bool>? _future;

  /// You're to override this function and initialize any asynchronous operations
  Future<bool> initAsync() async => true;

  /// Supply the AsyncSnapshot
  AsyncSnapshot<bool>? get snapshot => _snapshot;
  AsyncSnapshot<bool>? _snapshot;

  /// initAsync() has failed and a 'error' widget instead will be displayed.
  /// This takes in the snapshot.error details.
  void onAsyncError(FlutterErrorDetails details) {}

  /// Catch it if the initAsync() throws an error
  /// WITH GREAT POWER COMES GREAT RESPONSIBILITY
  /// Return true to ignore the error, false to continue the error handling
  Future<bool> catchAsyncError(Object error) async => false;

  /// Record any splash screen
  Widget? _splashScreen;

  /// Returns the appropriate widget when the Future is completed.
  Widget _futureBuilder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    //
    _snapshot = snapshot;

    Widget? widget;
    FlutterErrorDetails? errorDetails;

    if (snapshot.connectionState == ConnectionState.done) {
      // Release any splash screen
      _splashScreen = null;

      if (snapshot.hasData) {
        // IMPORTANT: Must supply the State object's context: this.context
        widget = buildF(this.context);
      } else if (snapshot.hasError) {
        //
        errorDetails = FlutterErrorDetails(
          exception: snapshot.error!,
          stack: snapshot.stackTrace,
          library: 'part05_futurebuilder_state_mixin.dart',
          context: ErrorDescription('Error in FutureBuilder'),
        );

        // Possibly recover resources and close services before continuing to exit in error.
        onAsyncError(errorDetails);
        //
      } else {
        // Since commented out '// && snapshot.data!) {' this bit of code should never run.
        errorDetails = FlutterErrorDetails(
          exception: Exception('App failed to initialize'),
          library: 'state_extended.dart',
          context: ErrorDescription('Please, notify Admin.'),
        );
      }
    }

    // A Widget must be supplied.
    if (widget == null) {
      // Keep trying until there's an error.
      if (errorDetails == null) {
        //
        // A splash screen may have been supplied
        if (_splashScreen != null) {
          widget = _splashScreen;
        } else {
          try {
            // Display the splash screen
            // IMPORTANT: Supply the State object's context: this.context
            _splashScreen = onSplashScreen(this.context);

            widget = _splashScreen;
          } catch (e) {
            // Don't run the splashScreen ever again. It's in error.
            _splashScreen = const SizedBox();

            // Throw in DebugMode.
            if (kDebugMode) {
              rethrow;
            } else {
              // Record error in log
              _logPackageError(
                e,
                library: 'state_extended.dart',
                description: 'Error in Splash Screen',
              );
            }
          }
        }

        // Still no widget
        if (widget == null) {
          if (usingCupertino) {
            //
            widget = const Center(child: CupertinoActivityIndicator());
          } else {
            //
            widget = const Center(child: CircularProgressIndicator());
          }
        }
        // There was an error instead.
      } else {
        // // Resets the count of errors to show a complete error message not an abbreviated one.
        // FlutterError.resetErrorCount();
        // // Log the error
        // FlutterError.presentError(errorDetails);
        // Release any splash screen
        _splashScreen = null;

        try {
          widget = ErrorWidget.builder(errorDetails);
        } catch (e) {
          // Must provide something. Blank then
          widget = const SizedBox();

          // Throw in DebugMode.
          if (kDebugMode) {
            rethrow;
          } else {
            // Record error in log
            _logPackageError(
              e,
              library: 'state_extended.dart',
              description: 'Error in FutureBuilder error routine',
            );
          }
        }
      }
      // Likely needs Localization
      widget = _localizeWidget(this.context, widget);
    }
    return widget;
  }

  /// Is the CupertinoApp being used?
  bool get usingCupertino =>
      _usingCupertino ??= context.getElementForInheritedWidgetOfExactType<
              CupertinoUserInterfaceLevel>() !=
          null;
  bool? _usingCupertino;

  /// Copy particular properties from the 'previous' StateX
  // ignore: unused_element
  // void _copyOverStateFuture([StateX? oldState]) {
  //   //
  //   if (oldState == null) {
  //     return;
  //   }
  //   _future = oldState._future;
  // }

  /// Supply Localizations before displaying the widget
  Widget _localizeWidget(BuildContext context, Widget child) {
    Widget widget;
    Object? material, cupertino;
    //
    StateX state;
    bool disposed = false;
    if (this is StateX) {
      disposed = (this as StateX).disposed;
    }
    if (context.mounted && !disposed) {
      material = Localizations.of<MaterialLocalizations>(
          context, MaterialLocalizations);
      cupertino = Localizations.of<CupertinoLocalizations>(
          context, CupertinoLocalizations);
    }
    if (material != null || cupertino != null) {
      widget = child;
    } else {
      widget = Localizations(
        locale: const Locale('en', 'US'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        child: child,
      );
    }
    return widget;
  }
}
