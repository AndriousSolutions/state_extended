/// The extension of the State class.
///
/// dartdoc:
/// {@category Get started}
library state_extended;

// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async' show Future;

import 'dart:math' show Random;

import 'dart:ui' show AppExitResponse;

import 'package:flutter/cupertino.dart'
    show
        CupertinoLocalizations,
        CupertinoUserInterfaceLevel,
        DefaultCupertinoLocalizations;

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

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
        // ignore: prefer_mixin
        WidgetsBindingObserver,
        _ControllersByType,
        RootState,
        AsyncOps,
        FutureBuilderStateMixin,
        InheritedWidgetStateMixin,
        StateXonErrorMixin,
        RecordExceptionMixin,
        _MapOfStates
    implements
        StateListener {
  //
  /// With an optional StateXController parameter and built-in InheritedWidget use
  StateX({StateXController? controller, bool? useInherited}) {
    // Add to the list of StateX objects present in the app!
    _addToMapOfStates(this);
    // A flag determining whether the built-in InheritedWidget is used or not.
    _useInherited = useInherited ?? false;
    // Associate the controller to this State object
    _controller = controller;
    // Any subsequent calls to add() will be assigned to stateX.
    add(_controller);
  }

  StateXController? _controller;

  /// Use this function instead of build() to use the built-in InheritedWidget.
  @override
  @protected
  Widget buildIn(BuildContext context) => const SizedBox();

  /// Implement this function instead of the build() function
  /// so to utilize a built-in FutureBuilder Widget and not the InheritedWidget.
  // @override
  // @protected
  // Widget buildF(BuildContext context) => super.buildF(context);

  /// Implement the build() function if you wish
  /// to not use the mixin, FutureBuilderStateMixin
  // @override
  // @protected
  // Widget build(BuildContext context) => super.build(context);

  /// You need to be able access the widget.
  @override
  // ignore: avoid_as
  T get widget => super.widget as T;

  /// A flag determining whether the built-in InheritedWidget is used or not.
  bool get useInherited => _useInherited;

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
  bool get isEndState => this == endState;

  /// Asynchronous operations must complete successfully.
  @override
  @protected
  @mustCallSuper
  Future<bool> initAsync() async {
    // Always return true. It's got to continue for now.
    const init = true;

    // No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      //
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
    }
    _setStateAllowed = true;

    /// No 'setState()' functions are necessary
    _setStateRequested = false;

    return init;
  }

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  @protected
  @mustCallSuper
  void initState() {
    assert(mounted, '${toString()} is not instantiated properly.');

    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
    super.initState();

    /// Registers the given object as a binding observer. Binding
    /// observers are notified when various application events occur,
    /// for example when the system locale changes. Generally, one
    /// widget in the widget tree registers itself as a binding
    /// observer, and converts the system state into inherited widgets.
    WidgetsBinding.instance.addObserver(this);

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    int cnt = 0;
    StateXController con;

    // While loop so additional controllers can be added in a previous initState()
    final list = controllerList.length;

    while (cnt < list) {
      con = controllerList[cnt];
      // Add this to the _StateSets Map
      con._addStateToSetter(this);
      con.initState();
      cnt++;
    }

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
  @protected
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
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  @protected
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
    deactivated = false;

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

    // Registers the given object as a binding observer.
    WidgetsBinding.instance.addObserver(this);

    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;
  }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @override
  @protected
  @mustCallSuper
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree.

    // Indicate this State object is deactivated.
    deactivated = true;

    // Unregisters the given observer.
    WidgetsBinding.instance.removeObserver(this);

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
    _removeFromMapOfStates(this);

    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;
  }

  /// State object's deactivated() was called.
  bool deactivated = false;

  /// The framework calls this method when this [StateX] object will never
  /// build again and will be disposed of with garbage collection.
  @override
  @protected
  @mustCallSuper
  void dispose() {
    /// The State object's lifecycle is terminated.
    /// **IMPORTANT** You will not know when this will run
    /// It's to the Flutter engines discretion. deactivate() is more reliable.
    /// Subclasses should override deactivate() method instead
    /// to release any resources  (e.g., stop any active animations).

    /// Indicate this State object is terminated.
    disposed = true;

    // No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.dispose();
    }

    // Remove any 'StateXController' reference
    _controller = null;

    // Clear the list of Controllers.
    _mapControllerByType.clear();

    // // In some cases, the setState() will be called again! gp
    _setStateAllowed = true;

    // In some cases, if then reinserted back in another part of the tree
    // the build is called, and so setState() is not necessary.
    _setStateRequested = false;

    super.dispose();
  }

  /// Flag indicating this State object is disposed.
  /// Will be garbage collected.
  /// property, mounted, is then set to false.
  bool disposed = false;

  /// Update the 'new' StateX object from the 'old' StateX object.
  /// Returning to this app from another app will re-create the State object
  /// You 'update' the current State object using this function.
  @override
  @protected
  @mustCallSuper
  void updateNewStateX(covariant StateX oldState) {
    /// No 'setState()' functions are allowed
    _setStateAllowed = false;

    for (final con in controllerList) {
      con.updateNewStateX(oldState);
    }

    /// Re-enable setState() function
    _setStateAllowed = true;
  }

  /// Override this method to respond when its [StatefulWidget] is re-created.
  /// The framework always calls [build] after calling [didUpdateWidget], which
  /// means any calls to [setState] in [didUpdateWidget] are redundant.
  @override
  @protected
  @mustCallSuper
  void didUpdateWidget(StatefulWidget oldWidget) {
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
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @override
  @protected
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    /// First, process the State object's own event functions.
    switch (state) {
      case AppLifecycleState.inactive:
        inactive = true;
        inactiveLifecycleState();
        break;
      case AppLifecycleState.hidden:
        hidden = true;
        hiddenLifecycleState();
        break;
      case AppLifecycleState.paused:
        paused = true;
        pausedLifecycleState();
        break;
      case AppLifecycleState.detached:
        detached = true;
        detachedLifecycleState();
        break;
      case AppLifecycleState.resumed:
        resumed = true; // The StateX object now resumed will be re-created.
        resumedLifecycleState();
        break;
      default:
      // WARNING: Missing case clause for 'hidden'??
    }

    for (final con in controllerList) {
      con.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.inactive:
          con.inactiveLifecycleState();
          break;
        case AppLifecycleState.paused:
          con.pausedLifecycleState();
          break;
        case AppLifecycleState.detached:
          con.detachedLifecycleState();
          break;
        case AppLifecycleState.resumed:
          con.resumedLifecycleState();
          break;
        default:
        // WARNING: Missing case clause for 'hidden'??
      }
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Apps in this state should assume that they may be [pausedLifecycleState] at any time.
  @override
  @protected
  void inactiveLifecycleState() {}

  /// State object was in 'inactive' state
  bool inactive = false;

  @override
  @protected
  void hiddenLifecycleState() {}

  /// State object was in a 'hidden' state
  bool hidden = false;

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  @protected
  void pausedLifecycleState() {}

  /// State object was in 'paused' state
  bool paused = false;

  /// Either be in the progress of attaching when the  engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  @protected
  void detachedLifecycleState() {}

  /// State object was in 'paused' state
  bool detached = false;

  /// The application is visible and responding to user input.
  @override
  @protected
  void resumedLifecycleState() {}

  /// State object was in 'resumed' state
  bool resumed = false;

  /// Called when a request is received from the system to exit the application.
  @override
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    return appResponse;
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  ///
  @override
  @protected
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
      if (isEndState) {
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
  @override
  @protected
  @mustCallSuper
  Future<bool> didPushRoute(String route) async {
    /// Observers are expected to return true if they were able to
    /// handle the notification. Observers are notified in registration
    /// order until one returns true.
    ///
    /// This method exposes the `pushRoute` notification from

    // Don't if the State object is defunct.
    if (!mounted) {
      return true;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    /// Set if a StateXController successfully 'handles' the notification.
    bool handled = false;

    for (final con in controllerList) {
      final didPush = await con.didPushRoute(route);
      if (didPush) {
        handled = true;
      }
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

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
  /// The default implementation is to call the [didPushRoute] directly with the
  /// [RouteInformation.uri].
  @override
  @protected
  @mustCallSuper
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    // Don't if the State object is defunct.
    if (!mounted) {
      return true;
    }

    /// No 'setState()' functions are allowed to fully function at this point.
    _setStateAllowed = false;

    /// Set if a StateXController successfully 'handles' the notification.
    bool handled = false;

    for (final con in controllerList) {
      final didPush = await con.didPushRouteInformation(routeInformation);
      if (didPush) {
        handled = true;
      }
    }

    _setStateAllowed = true;

    if (_setStateRequested) {
      _setStateRequested = false;
      // Only the latest State is rebuilt
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }

    return handled;
  }

  /// The top route has been popped off, and this route shows up.
  @override
  @protected
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
      if (isEndState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when this route has been pushed.
  @override
  @protected
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
      if (isEndState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when this route has been popped off.
  @override
  @protected
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
      if (isEndState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// New route has been pushed, and this route is no longer visible.
  @override
  @protected
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
      if (isEndState) {
        // Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// State object experienced a system event
  bool get hadSystemEvent => _hadSystemEvent;
  // Reset in _pushStateToSetter()
  bool _hadSystemEvent = false;

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when the platform's text scale factor changes.
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when the platform brightness changes.
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when the system is running low on memory.
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// Called when the system changes the set of currently active accessibility features.
  @protected
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
      if (isEndState) {
        /// Perform a 'rebuild' if requested.
        setState(() {});
      }
    }
  }

  /// During development, if a hot reload occurs, the reassemble method is called.
  /// This provides an opportunity to reinitialize any data that was prepared
  /// in the initState method.
  @protected
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
  }

  /// Allows 'external' routines can call this function.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  @override
  void setState(VoidCallback fn) {
    //
    if (_setStateAllowed) {
      _setStateAllowed = false;

      // Don't bother if the State object is disposed of.
      if (mounted) {
        /// Refresh the interface by 'rebuilding' the Widget Tree
        /// Call the State object's setState() function.
        super.setState(fn);
      }
      _setStateAllowed = true;
    } else {
      /// Can't rebuild at this moment but at least make the request.
      _setStateRequested = true;
    }
  }

  /// Copy particular properties from another StateX
  @mustCallSuper
  void copy([StateX? state]) {
    //
    if (state == null) {
      return;
    }
    // Copy over certain properties
    _recException = state._recException;
    _ranAsync = state._ranAsync;
  }
}

/// A State object that explicitly implements a built-in InheritedWidget
///
/// dartdoc:
/// {@category StateX class}
abstract class StateIn<T extends StatefulWidget> extends StateX<T> {
  ///
  StateIn({StateXController? controller})
      : super(controller: controller, useInherited: true);
}

/// Collects Controllers of various types.
/// A State object, by definition, then can't have multiple instances of the same type.
///
/// dartdoc:
/// {@category StateX class}
mixin _ControllersByType on State {
  /// A collection of Controllers identified by type.
  /// <type, controller>
  final Map<Type, StateXController> _mapControllerByType = {};

  /// Returns true if found.
  bool contains(StateXController con) =>
      _mapControllerByType.containsValue(con);

  /// Returns true if found
  bool containsType<T>() => _mapControllerByType.containsKey(T);

  /// List the controllers.
  List<StateXController> get controllerList =>
      _mapControllerByType.values.toList(growable: false);

  /// Add a list of 'Controllers'.
  List<String> addList(List<StateXController> list) {
    final List<String> keyIds = [];
    for (final con in list) {
      if (!_mapControllerByType.containsKey(con.runtimeType)) {
        keyIds.add(add(con));
      }
    }
    return keyIds;
  }

  /// Add a 'StateXController'
  /// Returns the StateXController's unique identifier.
  String add(StateXController? con) {
    String id;
    if (con == null) {
      id = '';
    } else {
      id = con.identifier;
      final type = con.runtimeType;
      if (_mapControllerByType.containsKey(type)) {
        // Indicate is was not added.
        id = '';
      } else {
        _mapControllerByType.addAll({type: con});
      }
    }
    return id;
  }

  /// Remove a 'StateXController'
  bool remove(StateXController? con) {
    bool removed = con != null;
    if (removed) {
      removed = _mapControllerByType.remove(con.runtimeType) != null;
    }
    return removed;
  }

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  bool removeByKey(String? id) {
    bool removed = id != null;
    if (removed) {
      final con = controllerById(id);
      removed = con != null;
      if (removed) {
        removed = remove(con);
      }
    }
    return removed;
  }

  /// Retrieve a StateXController by type.
  U? controllerByType<U extends StateXController>() =>
      _mapControllerByType[_type<U>()] as U?;

  /// Retrieve a controller by it's unique identifier.
  StateXController? controllerById(String? id) {
    StateXController? con;
    if (id != null && id.isNotEmpty) {
      for (final controller in controllerList) {
        if (controller.identifier == id) {
          con = controller;
          break;
        }
      }
    }
    return con;
  }

  /// Returns the list of 'Controllers' but you must know their keys.
  List<StateXController?> listControllers(List<String?>? ids) {
    final List<StateXController?> controllers = [];
    if (ids != null) {
      for (final id in ids) {
        if (id != null && id.isNotEmpty) {
          for (final controller in controllerList) {
            if (controller.identifier == id) {
              controllers.add(controller);
              break;
            }
          }
        }
      }
    }
    return controllers;
  }

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get firstCon {
    final list = controllerList;
    return list.isEmpty ? null : list.first;
  }

  /// Returns 'the last' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get lastCon {
    final list = controllerList;
    return list.isEmpty ? null : list.last;
  }

  /// To externally 'process' through the controllers.
  /// Invokes [func] on each StateXController possessed by this StateX object.
  /// With an option to process in reversed chronological order
  bool forEach(void Function(StateXController con) func, {bool? reversed}) {
    bool each = true;
    Iterable<StateXController> list;
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = controllerList.reversed;
    } else {
      list = controllerList;
    }
    for (final StateXController con in list) {
      try {
        func(con);
      } catch (e, stack) {
        each = false;
        if (this is StateX) {
          (this as StateX).recordException(e, stack);
        }
      }
    }
    return each;
  }

  @override
  void dispose() {
    // Clear the its list of Controllers
    _mapControllerByType.clear();
    super.dispose();
  }
}

/// Works with the collection of State objects in the App.
///
/// dartdoc:
/// {@category StateX class}
mixin _MapOfStates on State {
  /// All the State objects in this app.
  static final Map<String, StateX> _states = {};

  /// Retrieve the State object by type
  /// Returns null if not found
  T? stateByType<T extends StateX>() {
    StateX? state;
    try {
      for (final item in _MapOfStates._states.values) {
        if (item is T) {
          state = item;
          break;
        }
      }
    } catch (_) {
      state = null;
    }
    return state == null ? null : state as T;
  }

  /// Returns a StateView object using a unique String identifier.
  StateX? stateById(String? id) => _MapOfStates._states[id];

  /// Returns a Map of StateView objects using unique String identifiers.
  Map<String, StateX> statesById(List<String> ids) {
    final Map<String, StateX> map = {};
    for (final id in ids) {
      final state = stateById(id);
      if (state != null) {
        map[id] = state;
      }
    }
    return map;
  }

  /// Returns a List of StateX objects using unique String identifiers.
  List<StateX> listStates(List<String> keys) {
    return statesById(keys).values.toList();
  }

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get rootCon {
    StateXController? controller;
    final state = startState;
    if (state != null) {
      controller = (state as StateX).controller;
    }
    return controller;
  }

  /// Return the first State object
  // Bit of overkill, but some programmers don't appreciate Polymorphism.
  State? get startState => _nextStateX();

  /// Return the 'latest' State object
  // Bit of overkill, but some programmers don't appreciate Polymorphism.
  State? get endState => _nextStateX(reversed: true);

  /// Loop through the list and return the next available State object
  StateX? _nextStateX({bool? reversed}) {
    reversed = reversed != null && reversed;
    StateX? nextState;
    Iterable<StateX> list;
    if (reversed) {
      list = _MapOfStates._states.values.toList(growable: false).reversed;
    } else {
      list = _MapOfStates._states.values.toList(growable: false);
    }
    for (final StateX state in list) {
      if (state.mounted && !state.deactivated) {
        nextState = state;
        break;
      }
    }
    return nextState;
  }

  /// To externally 'process' through the State objects.
  /// Invokes [func] on each StateX possessed by this StateX object.
  /// With an option to process in reversed chronological order
  bool forEachState(void Function(StateX state) func, {bool? reversed}) {
    bool each = true;
    Iterable<StateX> list;
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = _MapOfStates._states.values.toList(growable: false).reversed;
    } else {
      list = _MapOfStates._states.values.toList(growable: false);
    }
    for (final StateX state in list) {
      try {
        if (state.mounted && !state.deactivated) {
          func(state);
        }
      } catch (e, stack) {
        each = false;
        // Record the error
        if (this is StateX) {
          (this as StateX).recordException(e, stack);
        }
      }
    }
    return each;
  }

  /// This is 'privatized' function as it is an critical method and not for public access.
  /// This contains the 'main list' of StateX objects present in the app!
  bool _addToMapOfStates(StateX? state) {
    final add = state != null;
    if (add) {
      _MapOfStates._states[state._id] = state;
    }
    //   }
    return add;
  }

  /// Remove the specified State object from static Set object.
  bool _removeFromMapOfStates(StateX? state) {
    var removed = state != null;
    if (removed) {
      final int length = _MapOfStates._states.length;
      _MapOfStates._states.removeWhere((key, value) => state._id == key);
      removed = _MapOfStates._states.length < length;
    }
    return removed;
  }
}

/// Your 'working' class most concerned with the app's functionality.
/// Add it to a 'StateX' object to associate it with that State object.
///
/// dartdoc:
/// {@category Testing}
/// {@category Get started}
/// {@category Event handling}
/// {@category State Object Controller}
class StateXController with SetStateMixin, StateListener, RootState, AsyncOps {
  /// Optionally supply a State object to 'link' to this object.
  /// Thus, assigned as 'current' StateX for this object
  StateXController([StateX? state]) {
    addState(state);
  }

  /// Associate this StateXController to the specified State object
  /// to use that State object's functions and features.
  /// Returns that State object's unique identifier.
  String addState(StateX? state) {
    if (state == null) {
      return '';
    }
    if (state.add(this).isNotEmpty) {
      return state.identifier;
    } else {
      return '';
    }
  }

  /// The current StateX object.
  StateX? get state => _stateX;

  /// Link a widget to a InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) =>
      _stateX?.dependOnInheritedWidget(context) ?? false;

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  bool notifyClients() => _stateX?.notifyClients() ?? false;
}

/// Used by StateXController
/// Allows you to call 'setState' from the 'current' the State object.
///
/// dartdoc:
/// {@category State Object Controller}
mixin SetStateMixin {
  /// Provide the setState() function to external actors
  void setState(VoidCallback fn) => _stateX?.setState(fn);

  /// Retrieve the State object by its StatefulWidget. Returns null if not found.
  StateX? stateOf<T extends StatefulWidget>() =>
      _stateWidgetMap.isEmpty ? null : _stateWidgetMap[_type<T>()];

  StateX? _stateX;
  StateX? _oldStateX;
  final Set<StateX> _stateXSet = {};
  final Map<Type, StateX> _stateWidgetMap = {};
  bool _statePushed = false;

  /// Add the provided State object to the Map object if
  /// it's the 'current' StateX object in _stateX.
  void _addStateToSetter(StateX state) {
    if (_statePushed && _stateX != null && _stateX == state) {
      _stateWidgetMap.addAll({state.widget.runtimeType: state});
    }
  }

  /// Add to a Set object and assigned to as the 'current' StateX
  /// However, if was already previously added, it's not added
  /// again to a Set object and certainly not set the 'current' StateX.
  bool _pushStateToSetter(StateX? state) {
    //
    if (state == null) {
      return false;
    }

    // It's been opened before
    if (_oldStateX != null) {
      // If the previous State was 'resumed'. May want to recover further??
      if (_oldStateX!._hadSystemEvent) {
        // Reset so not to cause any side-affects.
        _oldStateX!._hadSystemEvent = false;
        // If a different object and the same type. (Thought because it was being recreated, but not the case. gp)
        if (state != _oldStateX &&
            state.runtimeType == _oldStateX.runtimeType) {
          // Copy over certain properties
          state.copy(_oldStateX);
          state.updateNewStateX(_oldStateX!);
          assert(() {
            if (kDebugMode) {
              //ignore: avoid_print
              print(
                  '############ _pushStateToSetter(): $state copied $_oldStateX');
            }
            return true;
          }());

          // Testing Flutter lifecycle operation
          assert(() {
            if (_oldStateX!.resumed || _oldStateX!.deactivated) {
              if (kDebugMode) {
                print(
                    '############ _pushStateToSetter(): resumed: ${_oldStateX!.resumed} deactivated: ${_oldStateX!.deactivated}');
              }
            }
            return true;
          }());
        }
      }

      // cleanup
      _oldStateX = null;
    }

    _statePushed = _stateXSet.add(state);
    // If added, assign as the 'current' state object.
    if (_statePushed) {
      _stateX = state;
    }
    return _statePushed;
  }

  /// This removes the most recent StateX object added
  /// to the Set of StateX state objects.
  /// Primarily internal use only: This disconnects the StateXController from that StateX object.
  bool _popStateFromSetter([StateX? state]) {
    // Return false if null
    if (state == null) {
      return false;
    }

    // Remove from the Map and Set object.
    _stateWidgetMap.removeWhere((key, value) => value == state);

    final pop = _stateXSet.remove(state);

    // Was the 'popped' state the 'current' state?
    if (state == _stateX) {
      //
      _statePushed = false;

      // **IMPORTANT** In certain instances it's destroyed and another created
      // Retain a copy to update the new StateX object!
      _oldStateX = _stateX;

      if (_stateXSet.isEmpty) {
        _stateX = null;
      } else {
        _stateX = _stateXSet.last;
      }
    }
    return pop;
  }

  /// Retrieve the StateX object by type
  /// Returns null if not found
  T? ofState<T extends StateX>() {
    StateX? state;
    if (_stateXSet.isEmpty) {
      state = null;
    } else {
      final stateList = _stateXSet.toList(growable: false);
      try {
        for (final item in stateList) {
          if (item is T) {
            state = item;
            break;
          }
        }
      } catch (_) {
        state = null;
      }
    }
    return state == null ? null : state as T;
  }

  // /// Return a 'copy' of the Set of State objects.
  // Set<StateX> get states => Set.from(_stateXSet.whereType<StateX>());

  /// The Set of State objects.
  Set<StateX> get states => _stateXSet;
}

/// Used to explicitly return the 'type' indicated.
Type _type<U>() => U;

/// Responsible for the event handling in all the Controllers and State objects.
///
/// dartdoc:
/// {@category StateX class}
/// {@category Event handling}
/// {@category State Object Controller}
mixin StateListener implements RouteAware {
  /// A unique key is assigned to all State Controllers, State objects
  /// Used in large projects to separate objects into teams.
  String get identifier => _id;
  final String _id = Uuid().generateV4();

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @mustCallSuper
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
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
  }

  /// A State object may be unexpectedly re-created by a UniqueKey() in a parent for example.
  /// You have to 'update' the properties of the new StateX object using the
  /// old StateX object because it's going to be disposed of.
  void updateNewStateX(covariant StateX oldState) {
    /// When a State object is destroyed and a new one is re-created!
    /// Use the old one to update properties in the new StateX object.
  }

  /// Override this method to respond when the [StatefulWidget] is recreated.
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// The framework always calls build() after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
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
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  void reassemble() {
    /// Called whenever the application is reassembled during debugging, for
    /// example during hot reload.
    ///
    /// This method should rerun any initialization logic that depends on global
    /// state, for example, image loading from asset bundles (since the asset
    /// bundle may have changed).
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
  Future<bool> didPopRoute() async => false;

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification. Observers are notified in registration
  /// order until one returns true.
  ///
  /// This method exposes the `pushRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  Future<bool> didPushRoute(String route) async => false;

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification. Observers are notified in registration
  /// order until one returns true.
  ///
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  ///
  /// The default implementation is to call the [didPushRoute] directly with the
  /// [RouteInformation.uri].
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    final Uri uri = routeInformation.uri;
    return didPushRoute(
      Uri.decodeComponent(
        Uri(
          path: uri.path.isEmpty ? '/' : uri.path,
          queryParameters:
              uri.queryParametersAll.isEmpty ? null : uri.queryParametersAll,
          fragment: uri.fragment.isEmpty ? null : uri.fragment,
        ).toString(),
      ),
    );
  }

  /// The top route has been popped off, and this route shows up.
  @override
  void didPopNext() {}

  /// Called when this route has been pushed.
  @override
  void didPush() {}

  /// Called when this route has been popped off.
  @override
  void didPop() {}

  /// New route has been pushed, and this route is no longer visible.
  @override
  void didPushNext() {}

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
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
  }

  /// Called when the platform's text scale factor changes.
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
  }

  /// Brightness changed.
  void didChangePlatformBrightness() {}

  /// Called when the system tells the app that the user's locale has changed.
  void didChangeLocales(List<Locale>? locales) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.detached
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.hidden
    /// AppLifecycleState.paused (may enter the suspending state at any time)
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  void detachedLifecycleState() {}

  /// The application is visible and responding to user input.
  void resumedLifecycleState() {}

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
  void inactiveLifecycleState() {}

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  void hiddenLifecycleState() {}

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void pausedLifecycleState() {}

  /// Called when the system is running low on memory.
  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
  }

  /// Called when a request is received from the system to exit the application.
  /// Exiting the application can proceed with
  ///    AppExitResponse.exit;
  /// Cancel and do not exit the application with
  ///    AppExitResponse.cancel;
  Future<AppExitResponse> didRequestAppExit() async => AppExitResponse.exit;

  /// Called when the system changes the set of active accessibility features.
  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
  }
}

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
    // Don't run runAsync() function if _ranAsync is true.
    if (!_ranAsync || _future == null) {
      _future = runAsync();
    }
    return FutureBuilder<bool>(
      key: ValueKey<State>(this),
      future: _future,
      initialData: false,
      builder: _futureBuilder,
    );
  }

  /// Clean up
  @override
  void dispose() {
    _future = null;
    super.dispose();
  }

  /// Don't call runAsync() and initAsync() ever again once this is true.
  bool _ranAsync = false;

  /// IMPORTANT
  /// The _future must be created first. If the _future is created at the same
  /// time as the FutureBuilder, then every time the FutureBuilder's parent is
  /// rebuilt, the asynchronous task will be performed again.
  Future<bool>? _future;

  /// Run the StateX object's initAsync() function
  /// Override this function to repeatedly run initAsync()
  Future<bool> runAsync() {
    // Once true, initAsync() function is never run again
    // unless the runAsync() function is overridden.
    _ranAsync = true;
    return initAsync();
  }

  /// You're to override this function and initialize any asynchronous operations
  Future<bool> initAsync() async => true;

  /// Supply the AsyncSnapshot
  AsyncSnapshot<bool>? get snapshot => _snapshot;
  AsyncSnapshot<bool>? _snapshot;

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
        // && snapshot.data!) {
        //
        /// IMPORTANT: Must supply the State object's context: this.context
        widget = buildF(this.context);
        //
      } else if (snapshot.hasError) {
        //
        final exception = snapshot.error!;

        errorDetails = FlutterErrorDetails(
          exception: exception,
          stack: exception is Error ? exception.stackTrace : null,
          library: 'state_extended.dart',
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
              //
              errorDetails = FlutterErrorDetails(
                exception: e,
                stack: e is Error ? e.stackTrace : null,
                library: 'state_extended.dart',
                context: ErrorDescription('Error in Splash Screen'),
              );

              // Resets the count of errors to show a complete error message not an abbreviated one.
              FlutterError.resetErrorCount();

              // Log errors
              FlutterError.presentError(errorDetails);
            }
          }
        }

        // Still no widget
        //  CupertinoActivityIndicator used if TargetPlatform.iOS or TargetPlatform.macOS
        widget ??= const Center(child: CircularProgressIndicator());

        // There was an error instead.
      } else {
        // Resets the count of errors to show a complete error message not an abbreviated one.
        FlutterError.resetErrorCount();

        // Log the error
        FlutterError.presentError(errorDetails);

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
            //
            errorDetails = FlutterErrorDetails(
              exception: e,
              stack: e is Error ? e.stackTrace : null,
              library: 'state_extended.dart',
              context: ErrorDescription('Error in FutureBuilder error routine'),
            );

            // Resets the count of errors to show a complete error message not an abbreviated one.
            FlutterError.resetErrorCount();

            // Log errors
            FlutterError.presentError(errorDetails);
          }
        }
      }
      // Likely needs Localization
      widget = _localizeWidget(this.context, widget);
    }
    return widget;
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding runAsync() or initAsync() routine.
  void onAsyncError(FlutterErrorDetails details) {}

  /// Is the CupertinoApp being used?
  bool get usingCupertino =>
      context.getElementForInheritedWidgetOfExactType<
          CupertinoUserInterfaceLevel>() !=
      null;

  /// Supply Localizations before displaying the widget
  Widget _localizeWidget(BuildContext context, Widget child) {
    Widget widget;
    Object? material, cupertino;
    material =
        Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
    cupertino = Localizations.of<CupertinoLocalizations>(
        context, CupertinoLocalizations);
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

/// Supplies an InheritedWidget to a State class
///
/// dartdoc:
/// {@category StateX class}
/// {@category Using InheritedWidget}
mixin InheritedWidgetStateMixin on State {
  // A flag determining whether the built-in InheritedWidget is used or not.
  late bool _useInherited;

  // Collect any 'widgets' depending on this State's InheritedWidget.
  final Set<BuildContext> _dependencies = {};

  InheritedElement? _inheritedElement;

  // Widget passed to the InheritedWidget.
  Widget? _child;

  @override
  void initState() {
    super.initState();
    if (_useInherited) {
      // Supply an identifier to the InheritedWidget
      _key = ValueKey<StateX>(this as StateX);
    }
  }

  Key? _key;

  /// dartdoc:
  /// {@category StateX class}
  Widget buildF(BuildContext context) => _useInherited
      ? _StateXInheritedWidget(
          key: _key,
          state: this as StateX,
          child: _child ??= buildIn(context),
        )
      : buildIn(context);

  /// Compiled once and passed to an InheritedWidget.
  ///
  /// Supply the appropriate interface depending on the platform.
  ///
  /// dartdoc:
  /// {@category StateX class}
  Widget buildIn(BuildContext context);

  /// Determine if the dependencies should be updated.
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  ///
  ///  Set the specified widget (through its context) as a dependent of the InheritedWidget
  ///
  ///  Return false if not configured to use the InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) {
    final depend = _useInherited && context != null;
    if (depend) {
      if (_inheritedElement == null) {
        _dependencies.add(context);
      } else {
        context.dependOnInheritedElement(_inheritedElement!);
      }
    }
    return depend;
  }

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  bool notifyClients() {
    if (_useInherited) {
      try {
        setState(() {});
        // catch any errors if called inappropriately
      } catch (e, stack) {
        // Throw in DebugMode.
        if (kDebugMode) {
          rethrow;
        } else {
          //
          final details = FlutterErrorDetails(
            exception: e,
            stack: stack,
            library: 'state_extended.dart',
            context: ErrorDescription('notifyClient() error in $this'),
          );
          // Resets the count of errors to show a complete error message not an abbreviated one.
          FlutterError.resetErrorCount();
          // https://docs.flutter.dev/testing/errors#errors-caught-by-flutter
          // Log the error.
          FlutterError.presentError(details);
        }
      }
    }
    return _useInherited;
  }

  /// Called when the State's InheritedWidget is called again
  /// This 'widget function' will be called again.
  Widget state(WidgetBuilder? widgetFunc) {
    widgetFunc ??= (_) => const SizedBox();
    return _useInherited && this is StateX
        ? _SetStateWidget(stateX: this as StateX, widgetFunc: widgetFunc)
        : widgetFunc(context);
  }

  @override
  void dispose() {
    _key = null;
    _child = null;
    _inheritedElement = null;
    _dependencies.clear();
    super.dispose();
  }
}

/// The InheritedWidget used by StateX
class _StateXInheritedWidget extends InheritedWidget {
  const _StateXInheritedWidget({
    super.key,
    required this.state,
    required super.child,
  });

  final StateX state;

  @override
  InheritedElement createElement() {
    //
    final element = InheritedElement(this);
    state._inheritedElement = element;
    // Associate any dependencies widgets to this InheritedWidget
    // toList(growable: false) prevent concurrent error
    for (final context in state._dependencies.toList(growable: false)) {
      context.dependOnInheritedElement(element);
      state._dependencies.remove(context);
    }
    return element;
  }

  /// Use the StateX's updateShouldNotify() function
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      state.updateShouldNotify(oldWidget);
}

/// Supply a widget to depend upon a StateX's InheritedWidget
class _SetStateWidget extends StatelessWidget {
  const _SetStateWidget({
    Key? key,
    required this.stateX,
    required this.widgetFunc,
  }) : super(key: key);
  final StateX stateX;
  final WidgetBuilder widgetFunc;
  @override
  Widget build(BuildContext context) {
//    context.dependOnInheritedElement(stateX._inheritedElement!);
    stateX.dependOnInheritedWidget(context);
    return widgetFunc(context);
  }
}

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
    StateXController? controller,
    List<StateXController>? controllers,
    Object? object,
    // Save the current error handler
  })  : _currentErrorFunc = FlutterError.onError,
        super(controller: controller) {
    //Record this as the 'root' State object.
    setRootStateX(this);
    _dataObj = object;
    addList(controllers?.toList());
    // If a tester is running, for example, don't switch out its error handler.
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      // Introduce its own error handler
      FlutterError.onError = _errorHandler;
    }
  }

  /// The 'data object' available to the framework.
  Object? _dataObj;

  /// Save the current Error Handler.
  final FlutterExceptionHandler? _currentErrorFunc;

  @override
  void initState() {
    super.initState();
    _inheritedState = _InheritedState(this);
    // Supply an identifier to the InheritedWidget
    _key = ValueKey<State>(_inheritedState!);
  }

  // Contains the app's InheritedWidget
  State<StatefulWidget>? _inheritedState;
  // Contains the app's buildIn() function
  State<StatefulWidget>? _buildInState;

  /// A separate State object containing the app's InheritedWidget
  /// and a separate State object containing the app's buildIn() function
  @override
  @protected
  Widget buildF(BuildContext context) {
    _buildInState?.setState(() {}); // Calls the buildIn() function
    return _StateStatefulWidget(key: _key, state: _inheritedState!);
  }

  /// Implement this function to compose the App's View.
  /// Returns the 'child' Widget is then passed to an InheritedWidget
  @override
  @protected
  Widget buildIn(BuildContext context);

  /// Clean up memory
  /// Called when garbage collecting
  @override
  @protected
  @mustCallSuper
  void dispose() {
    _MapOfStates._states.clear();
    _clearRootStateX();
    _key = null;
    _inheritedState = null;
    // Return the original error handler
    FlutterError.onError = _currentErrorFunc;
    super.dispose();
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
    // Doesn't test for _useInherited
    // Don't if already in the SetState.builder() function
    final notify = !_inSetStateBuilder;
    if (notify) {
      try {
        // Calls the app's InheritedWidget again
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
          _logError(details);
        }
      }
    }
    return notify;
  }

  /// Called when the State's InheritedWidget is called again
  /// This 'widget function' will be called again.
  @override
  Widget state(WidgetBuilder? widgetFunc) {
    widgetFunc ??= (_) => const SizedBox(); // Display 'nothing' if not provided
    return _SetStateWidget(stateX: this, widgetFunc: widgetFunc);
  }

  /// Catch any errors in the App
  /// Free to override if you like
  @override
  void onError(FlutterErrorDetails details) {
    // Don't call this routine within itself.
    if (_inErrorRoutine) {
      return;
    }
    _inErrorRoutine = true;

    // call the latest SateX object's error routine
    // Possibly the error occurred there.
    final state = endState;

    if (state != null && state is StateX) {
      try {
        //
        bool caught = false;

        final stack = details.stack?.toString();
        //
        if (stack != null) {
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
            state.onError(details);
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
    // Record to logs
    _logError(details);

    // Always test if there was an error in the error handler
    // Include it in the error reporting as well.
    if (hasError) {
      _onErrorInHandler();
    }

    // Now out of the error handler
    _inErrorRoutine = false;
  }

  /// A flag indicating we're running in the error routine.
  /// Set to avoid infinite loop if in errors in the error routine.
  bool _inErrorRoutine = false;

  /// Catch and explicitly handle the error.
  void catchError(Exception? ex) {
    if (ex == null) {
      return;
    }

    /// If a tester is running. Don't handle the error.
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      FlutterError.onError!(FlutterErrorDetails(exception: ex));
    }
  }

  // Handle any errors in this State object.
  void _errorHandler(FlutterErrorDetails details) {
    // Set the original error routine. Allows the handler to throw errors.
    FlutterError.onError = _currentErrorFunc;
    try {
      onError(details);
    } catch (e) {
      // Throw in DebugMode.
      if (kDebugMode) {
        // If the handler also errors, it's throw to be handled
        // by the original routine.
        rethrow;
      } else {
        //
        final errorDetails = FlutterErrorDetails(
          exception: e,
          stack: e is Error ? e.stackTrace : null,
          library: 'state_extended.dart',
          context: ErrorDescription('Error in AppStateX Error Handler'),
        );

        // Resets the count of errors to show a complete error message not an abbreviated one.
        FlutterError.resetErrorCount();

        // Log errors
        FlutterError.presentError(errorDetails);
      }
    }
    // If handled, return to this State object's error handler.
    FlutterError.onError = _errorHandler;
  }

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
          _logError(details);
        } catch (e, stack) {
          // Error in the final error handler? That's a pickle.
          recordException(e, stack);
        }
      }
    }
  }
}

/// Pass a State object as a parameter to this StatefulWidget
class _StateStatefulWidget extends StatefulWidget {
  const _StateStatefulWidget({
    Key? key,
    required this.state,
  }) : super(key: key);
  final State<StatefulWidget> state;
  @override
  //ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => state;
}

/// Contains the app's InheritedWidget
/// Allows you to call only its dependencies to rebuild
/// by calling this State object's setState((){})
class _InheritedState extends State<_StateStatefulWidget> {
  _InheritedState(this.appState);
  final AppStateX appState;

  @override
  void initState() {
    super.initState();
    // Identifier for the app's InheritedWidget
    _key = ValueKey<StateX>(appState);
    // Contains the App State's buildIn() function
    _buildInState = _BuildInState(appState);
    // Record this State object so to call its setState((){}) function later.
    appState._buildInState = _buildInState;
    // The StatefulWidget containing the app's buildIn() function
    // Assigned to a property so not to call buildIn() in this State object
    _stateWidget = _StateStatefulWidget(
        key: ValueKey<State>(_buildInState!), state: _buildInState!);
  }

  // All nullable so to clear memory at dispose()
  Key? _key;
  State<StatefulWidget>? _buildInState;
  Widget? _stateWidget;

  @override
  Widget build(context) {
    // The app's InheritedWidget
    return _StateXInheritedWidget(
      key: _key,
      state: appState,
      child: _stateWidget!,
    );
  }

  @override
  void dispose() {
    _stateWidget = null;
    _buildInState = null;
    _key = null;
    super.dispose();
  }
}

/// Contains the AppStateX's buildIn() function
/// Allows you to call only that buildIn() function
/// by calling this State object's setState((){})
class _BuildInState extends State<_StateStatefulWidget> {
  _BuildInState(this.appState);
  final AppStateX appState;
  @override
  void initState() {
    super.initState();
    // So to only call buildIn() function in the build() function below.
    builder = appState.buildIn;
  }

  late WidgetBuilder builder;

  @override
  Widget build(context) => builder(context);
}

/// Manages the 'Controllers' associated with this
/// StateX object at any one time by their unique identifier.
mixin _ControllersById<T extends StatefulWidget> on StateX<T> {
  /// Stores the Controller by its Id
  ///  <id, controller>
  final Map<String, StateXController> _mapControllerById = {};

  /// List the runtimeType of the stored controllers.
  ///  <id, type>
  final Map<String, Type> _mapControllerTypes = {};

  /// Supply a public list of all the Controllers.
  @override
  List<StateXController> get controllerList =>
      _mapControllerById.values.toList(growable: false);

  /// Collect a 'StateXController'
  /// Returns the StateXController's unique identifier.
  @override
  String add(StateXController? con) {
    String id;
    if (con == null) {
      id = '';
    } else {
      id = con.identifier;
      if (!containsId(id)) {
        _mapControllerById[id] = con;
        // Will need to retrieve controller by type at times.
        _mapControllerTypes[id] = con.runtimeType;

        /// This connects the StateXController to this State object!
        con._pushStateToSetter(this);
      }
    }
    return id;
  }

  /// Collect a list of 'Controllers'.
  @override
  List<String> addList(List<StateXController>? list) {
    //list.forEach(add);
    final List<String> keyIds = [];
    if (list != null) {
      for (final con in list) {
        keyIds.add(add(con));
      }
    }
    return keyIds;
  }

  /// Remove a 'StateXController'
  /// Returns boolean if successful.
  @override
  bool remove(StateXController? con) => removeByKey(con!.identifier);

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  @override
  bool removeByKey(String? id) {
    bool remove = id != null;
    if (remove) {
      remove = _mapControllerById.containsKey(id);
      if (remove) {
        _mapControllerById.remove(id);
        _mapControllerTypes.remove(id);
      }
    }
    return remove;
  }

  /// Retrieve a StateXController by type.
  @override
  U? controllerByType<U extends StateXController>() {
    U? controller;

    // Take a copy of the types
    final temp = Map.of(_mapControllerTypes);

    // and remove all not of the specified type
    temp.removeWhere((key, value) => value != U);

    // There can only be one instance of a particular type returned.
    if (temp.length == 1) {
      controller = _mapControllerById[temp.keys.first] as U?;
    }
    return controller;
  }

  // Retrieve a controller by it's unique identifier.
  @override
  StateXController? controllerById(String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    return _mapControllerById[id];
  }

  /// Returns true if found.
  @override
  bool contains(StateXController con) {
    bool contains = false;
    for (final controller in controllerList) {
      contains = controller == con;
      if (contains) {
        break;
      }
    }
    return contains;
  }

  /// Returns the list of 'Controllers' but you must know their keys.
  @override
  List<StateXController?> listControllers(List<String?>? keys) =>
      _controllersById(keys).values.toList();

  /// Returns a list of controllers by their unique identifiers.
  Map<String, StateXController?> _controllersById(List<String?>? ids) {
    final Map<String, StateXController?> controllers = {};
    if (ids != null) {
      for (final id in ids) {
        if (id != null && id.isNotEmpty) {
          if (_mapControllerById.containsKey(id)) {
            controllers[id] = _mapControllerById[id];
          }
        }
      }
    }
    return controllers;
  }

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  @override
  StateXController? get rootCon {
    final list = controllerList;
    return list.isEmpty ? null : list.first;
  }

  /// Returns true if the specified 'StateXController' is associated with this StateX object.
  bool containsId(String? id) => _mapControllerById.containsKey(id);

  /// To externally 'process' through the controllers.
  /// Invokes [func] on each StateXController possessed by this StateX object.
  /// With an option to process in reversed chronological order
  @override
  bool forEach(void Function(StateXController con) func, {bool? reversed}) {
    bool each = true;
    Iterable<StateXController> list;
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = controllerList.reversed;
    } else {
      list = controllerList;
    }
    for (final StateXController con in list) {
      try {
        func(con);
      } catch (e, stack) {
        each = false;
        recordException(e, stack);
      }
    }
    return each;
  }

  @override
  void dispose() {
    // Clear the its list of Controllers
    _mapControllerById.clear();
    _mapControllerTypes.clear();
    super.dispose();
  }
}

///  Used like the function, setState(), to 'spontaneously' call
///  build() functions here and there in your app. Much like the Scoped
///  Model's ScopedModelDescendant() class.
///  This class object will only rebuild if the App's InheritedWidget notifies it
///  as it is a dependency.
///
/// dartdoc:
/// {@category AppStateX class}
@protected
class SetState extends StatelessWidget {
  /// Supply a 'builder' passing in the App's 'data object' and latest BuildContext object.
  const SetState({Key? key, required this.builder}) : super(key: key);

  /// This is called with every rebuild of the App's inherited widget.
  final Widget Function(BuildContext context, Object? object) builder;

  /// Calls the required Function object:
  /// Function(BuildContext context, T? object)
  /// and passes along the app's custom 'object'
  @override
  Widget build(BuildContext context) {
    //
    final rootState = RootState._rootStateX;

    if (rootState != null) {
      /// Go up the widget tree and link to the App's inherited widget.
      rootState.dependOnInheritedWidget(context);
      rootState._inSetStateBuilder = true;
      StateX._setStateAllowed = false;
    }

    final Widget widget = builder(context, rootState?._dataObj);

    if (rootState != null) {
      StateX._setStateAllowed = true;
      rootState._inSetStateBuilder = false;
    }
    return widget;
  }
}

/// Supply access to the 'Root' State object.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin RootState {
  ///Important to record the 'root' StateX object. Its an InheritedWidget!
  bool setRootStateX(StateX state) {
    // This can only be called once successfully. Subsequent calls are ignored.
    // Important to prefix with the class name to 'share' this as a mixin.
    final set = RootState._rootStateX == null && state is AppStateX;
    if (set) {
      // Important to prefix with the class name to 'share' this as a mixin.
      RootState._rootStateX = state;
    }
    return set;
  }

  /// To supply the static value across all instances of
  /// StateX objects, ControllerMVC objects and Model objects
  /// reference it using the class prefix, RootState.
  static AppStateX? _rootStateX;

  /// Returns the 'first' StateX object in the App
  // Important to prefix with the class name to 'share' this as a mixin.
  AppStateX? get rootState => RootState._rootStateX;

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => rootState?.endState?.context;

  /// This is of type Object allowing you
  /// to propagate any class object you wish down the widget tree.
  Object? get dataObject => rootState?._dataObj;

  /// Assign an object to the property, dataObject.
  /// It will not assign null and if SetState objects are implemented,
  /// will call the App's InheritedWidget to be rebuilt and call its
  /// dependencies.
  set dataObject(Object? object) {
    // Never explicitly set to null
    if (object != null) {
      final state = rootState;
      final dataObject = state?._dataObj;
      // Notify dependencies only if their was a change.
      if (dataObject == null || dataObject != object) {
        state?._dataObj = object;
        // Call inherited widget to 'rebuild' any dependencies
        state?.notifyClients();
      }
    }
  }

  /// Clear the static reference.
  /// Important to prefix with the class name to 'share' this as a mixin.
  void _clearRootStateX() => RootState._rootStateX = null;

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  bool get inDebugMode {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

/// Supply an 'error handler' routine if something goes wrong.
/// It need not be implemented, but it's their for your consideration.
///
/// dartdoc:
/// {@category StateX class}
/// {@category Error handling}
mixin StateXonErrorMixin {
  /// Offer an error handler
  void onError(FlutterErrorDetails details) {}

  void _logError(FlutterErrorDetails details) {
    // Don't when in DebugMode.
    if (!kDebugMode) {
      // Resets the count of errors to show a complete error message not an abbreviated one.
      FlutterError.resetErrorCount();
    }
    // https://docs.flutter.dev/testing/errors#errors-caught-by-flutter
    // Log the error.
    FlutterError.presentError(details);
  }
}

/// Record an exception
///
/// dartdoc:
/// {@category StateX class}
/// {@category Error handling}
mixin RecordExceptionMixin {
  /// Return the 'last' error if any.
  Exception? recordException([Object? error, StackTrace? stack]) {
    // Retrieved the currently recorded exception
    var ex = _recException;
    if (error == null) {
      // Once retrieved, empty this of the exception.
      _recException = null;
      _stackTrace = null;
    } else {
      if (error is! Exception) {
        _recException = Exception(error.toString());
      } else {
        _recException = error;
      }
      // Return the current exception
      ex = _recException;
      _stackTrace = stack;
    }
    return ex;
  }

  // Store the current exception
  Exception? _recException;

  /// Simply display the exception.
  String get errorMsg {
    String message;
    if (_recException == null) {
      message = '';
    } else {
      message = _recException.toString();
      final colon = message.lastIndexOf(': ');
      if (colon > -1 && colon + 2 <= message.length) {
        message = message.substring(colon + 2);
      }
    }
    return message;
  }

  /// Indicate if an exception had occurred.
  bool get hasError => _recException != null;

  /// The StackTrace
  StackTrace? get stackTrace => _stackTrace;
  StackTrace? _stackTrace;
}

/// Supply the Async API
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin AsyncOps {
  /// Used to complete asynchronous operations
  Future<bool> initAsync() async => true;

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding runAsync() routine.
  void onAsyncError(FlutterErrorDetails details) {}

  ///
  void _initAsyncError(Object e, StateXController con) {
    //
    final details = FlutterErrorDetails(
      exception: e,
      stack: e is Error ? e.stackTrace : null,
      library: 'state_extended.dart',
      context: ErrorDescription('${con.runtimeType}.initAsync'),
    );
    // To cleanup and recover resources.
    con.onAsyncError(details);
  }
}

// Uuid
// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this Uuid function is governed by the M.I.T. license that can be found
// in the LICENSE file under Uuid.
//
/// A UUID generator, useful for generating unique IDs.
/// Shamelessly extracted from the author of Scoped Model plugin,
/// Who maybe took from the Flutter source code. I'm not telling!
///
/// This will generate unique IDs in the format:
///
///     f47ac10b-58cc-4372-a567-0e02b2c3d479
///
/// ### Example
///
///     final String id = Uuid().generateV4();
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
class Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
