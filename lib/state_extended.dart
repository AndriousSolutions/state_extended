library state_extended;

// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async' show Future;

import 'dart:math' show Random;

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;

/// Replace 'dart:io' for Web applications
import 'package:universal_platform/universal_platform.dart';

/// The extension of the State class.
/// Uses the mixins: WidgetsBindingObserver, _ControllerList, _StateListeners
abstract class StateX<T extends StatefulWidget> extends State<StatefulWidget>
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver,
        _ControllerListing,
        StateListeners,
        RootState,
        AsyncOps,
        FutureBuilderStateMixin
    implements
        StateListener {
  //
  /// With an optional StateXController parameter, this constructor imposes its own Error Handler.
  StateX([this._controller]) : currentErrorFunc = FlutterError.onError {
    /// If a tester is running. Don't switch out its error handler.
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
      FlutterError.onError = onError;
    } else {
      _inTester = WidgetsBinding.instance is TestWidgetsFlutterBinding;
    }

    /// IMPORTANT! Assign itself to _stateX before adding any StateXController. -gp
    _stateX = this;

    /// Collect all the StateX objects to the 'root' State object;
    rootState?._addStateX(this);

    /// Any subsequent calls to add() will be assigned to stateX.
    add(_controller);
  }
  StateXController? _controller;

  /// Implement this function instead of the build() function
  /// to utilize a built-in FutureBuilder Widget and InheritedWidget.
  @override
  Widget buildWidget(BuildContext context) => super.buildWidget(context);

  /// Implement the build() function.
  @override
  Widget build(BuildContext context);

  /// Save the current Error Handler.
  final FlutterExceptionHandler? currentErrorFunc;

  /// You need to be able access the widget.
  @override
  // ignore: avoid_as
  T get widget => super.widget as T;

  /// Provide the 'main' controller to this 'State View.'
  /// If _controller == null, get the 'first assigned' controller if any.
  StateXController? get controller => _controller ??= rootCon;

  /// Retrieve a StateXController by its a unique String identifier.
  StateXController? controllerById(String? keyId) => super._con(keyId);

  /// Add a specific StateXController to this View.
  /// Returns the StateXController's unique String identifier.
  @override
  String add(StateXController? controller) {
    if (controller != null) {
      /// It may have been a listener. Can't be both.
      removeListener(controller);

      /// Collect all the Controllers to the 'root' State object;
      rootState?._controllers.add(controller);
    }
    return super.add(controller);
  }

  /// Remove a specific StateXController to this View.
  /// Returns the StateXController's unique String identifier.
  @override
  String remove(StateXController? controller) {
    if (controller != null) {
      /// It may have been a listener. Can't be both.
      removeListener(controller);

      /// Collect all the Controllers to the 'root' State object;
      rootState?._controllers.remove(controller);
    }
    return super.remove(controller);
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

  /// Retrieve a StateXController in the  framework by type.
  U? controllerByType<U extends StateXController>() {
    // Look in this State objects list of Controllers.  Maybe not?

    U? con = _cons[_type<U>()] as U?;

    if (con == null) {
      final controllers = rootState?._controllers.toList();
      if (controllers != null) {
        for (final cont in controllers) {
          if (cont.runtimeType == _type<U>()) {
            con = cont as U?;
            break;
          }
        }
      }
    }
    return con;
  }

  /// May be set false to prevent unnecessary 'rebuilds'.
  static bool _rebuildAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _rebuildRequested = false;

  /// Running in a tester instead of production.
  bool _inTester = false;

  /// Asynchronous operations must complete successfully.
  @override
  @mustCallSuper
  Future<bool> initAsync() async {
    bool init = true;
    // No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    for (final con in _controllerList) {
      //
      try {
        init = await con.initAsync();
      } catch (e) {
        //
        final details = FlutterErrorDetails(
          exception: e,
          stack: e is Error ? e.stackTrace : null,
          library: 'state_extended.dart',
          context: ErrorDescription('${con.runtimeType}.initAsync'),
        );
        // To cleanup and recover resources.
        init = con.onAsyncError(details);

        if (!init) {
          // If the error is not handled here. To be handled above.
          rethrow;
        }
      }
    }
    _rebuildAllowed = true;

    /// No 'setState()' functions are necessary
    _rebuildRequested = false;
    return init;
  }

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @protected
  @override
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
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.initState();
    }
    int cnt = 0;
    StateXController con;
    // While loop so additional controllers can be added in a previous initState()
    final list = _controllerList.length;
    while (cnt < list) {
      con = _controllerList[cnt];
      // Add this to the _StateSets Map
      con._addState(this);
      con.initState();
      cnt++;
    }
    for (final listener in _afterList) {
      listener.initState();
    }
    _rebuildAllowed = true;
  }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @protected
  @override
  @mustCallSuper
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.deactivate();
    }
    for (final con in _controllerList) {
      // Don't call its deactivate if it's in other State objects.
      if (con._stateXSet.isEmpty) {
        con.deactivate();
      }
    }
    for (final listener in _beforeList) {
      listener.deactivate();
    }
    super.deactivate();
    _rebuildAllowed = true;

    /// In some cases, if then reinserted back in another part of the tree
    /// the build is called, and so setState() is not necessary.
    _rebuildRequested = false;

    _deactivated = true;
  }

  /// Readily determine if the State object is possibly to be disposed of.
  bool get deactivated => _deactivated;
  // State object's deactivated() was called.
  bool _deactivated = false;

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

    _deactivated = false;

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.activate();
    }
    for (final con in _controllerList) {
      // Don't call its activate if it's in other State objects.
      if (con._stateXSet.isEmpty) {
        con.activate();
      }
    }
    for (final listener in _afterList) {
      listener.activate();
    }

    /// Must call the 'super' routine as well.
    super.activate();
    _rebuildAllowed = true;

    /// In some cases, if then reinserted back in another part of the tree
    /// the build is called, and so setState() is not necessary.
    _rebuildRequested = false;
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again and will be disposed of.
  @protected
  @override
  @mustCallSuper
  void dispose() {
    /// The State object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).

    // No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    for (final listener in _beforeList) {
      listener.dispose();
    }
    for (final con in _controllerList) {
      // This state's association is severed.
      con._popState(this);

      // Don't call its dispose if it's in other State objects.
      if (con._stateXSet.isEmpty) {
        con.dispose();
      }
    }
    _disposeControllerListing();
    for (final listener in _afterList) {
      listener.dispose();
    }
    _disposeStateEventList();

    // *In some cases, the setState() will be called again! gp
    _rebuildAllowed = true;

    // Unregisters the given observer.
    WidgetsBinding.instance.removeObserver(this);

    // Remove any 'StateXController' reference
    _controller = null;

    // Clear the list of Controllers.
    _cons.clear();

    // Return the original error routine.
    FlutterError.onError = currentErrorFunc;

    // Remove the State object from a collection.
    rootState?._removeStateX(this);

    super.dispose();
  }

  /// Override this method to respond when its [StatefulWidget] is re-created.
  /// The framework always calls [build] after calling [didUpdateWidget], which
  /// means any calls to [setState] in [didUpdateWidget] are redundant.
  @protected
  @override
  @mustCallSuper
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// No 'setState()' functions are allowed
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didUpdateWidget(oldWidget);
    }
    for (final con in _controllerList) {
      con.didUpdateWidget(oldWidget);
    }
    for (final listener in _afterList) {
      listener.didUpdateWidget(oldWidget);
    }
    super.didUpdateWidget(oldWidget);
    _rebuildAllowed = true;

    /// No 'setState()' functions are necessary
    _rebuildRequested = false;
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @protected
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    /// First, process the State object's own event functions.
    switch (state) {
      case AppLifecycleState.inactive:
        inactiveLifecycleState();
        break;
      case AppLifecycleState.paused:
        pausedLifecycleState();
        break;
      case AppLifecycleState.detached:
        detachedLifecycleState();
        break;
      case AppLifecycleState.resumed:
        resumedLifecycleState();
        break;
    }

    for (final listener in _beforeList) {
      listener.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.inactive:
          listener.inactiveLifecycleState();
          break;
        case AppLifecycleState.paused:
          listener.pausedLifecycleState();
          break;
        case AppLifecycleState.detached:
          listener.detachedLifecycleState();
          break;
        case AppLifecycleState.resumed:
          listener.resumedLifecycleState();
          break;
      }
    }
    for (final con in _controllerList) {
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
      }
    }
    for (final listener in _afterList) {
      listener.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.inactive:
          listener.inactiveLifecycleState();
          break;
        case AppLifecycleState.paused:
          listener.pausedLifecycleState();
          break;
        case AppLifecycleState.detached:
          listener.detachedLifecycleState();
          break;
        case AppLifecycleState.resumed:
          listener.resumedLifecycleState();
          break;
      }
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
  }

  /// Apps in this state should assume that they may be [pausedLifecycleState] at any time.
  @override
  void inactiveLifecycleState() {}

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {}

  /// Either be in the progress of attaching when the  engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {}

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {}

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  ///
  @protected
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
    ///
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    /// Set if a StateXController successfully 'handles' the notification.
    bool handled = false;

    for (final listener in _beforeList) {
      await listener.didPopRoute();
    }
    for (final con in _controllerList) {
      final didPop = await con.didPopRoute();
      if (didPop) {
        handled = true;
      }
    }
    for (final listener in _afterList) {
      await listener.didPopRoute();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
    // Return false to pop out
    return handled;
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  ///
  @protected
  @override
  @mustCallSuper
  Future<bool> didPushRoute(String route) async {
    /// Observers are expected to return true if they were able to
    /// handle the notification. Observers are notified in registration
    /// order until one returns true.
    ///
    /// This method exposes the `pushRoute` notification from

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    /// Set if a StateXController successfully 'handles' the notification.
    bool handled = false;

    for (final listener in _beforeList) {
      await listener.didPushRoute(route);
    }
    for (final con in _controllerList) {
      final didPush = await con.didPushRoute(route);
      if (didPush) {
        handled = true;
      }
    }
    for (final listener in _afterList) {
      await listener.didPushRoute(route);
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
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
  /// [RouteInformation.location].
  @protected
  @override
  @mustCallSuper
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    /// Set if a StateXController successfully 'handles' the notification.
    bool handled = false;

    for (final listener in _beforeList) {
      await listener.didPushRouteInformation(routeInformation);
    }
    for (final con in _controllerList) {
      final didPush = await con.didPushRouteInformation(routeInformation);
      if (didPush) {
        handled = true;
      }
    }
    for (final listener in _afterList) {
      await listener.didPushRouteInformation(routeInformation);
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
    return handled;
  }

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

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeMetrics();
    }
    for (final con in _controllerList) {
      con.didChangeMetrics();
    }
    for (final listener in _afterList) {
      listener.didChangeMetrics();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
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

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeTextScaleFactor();
    }
    for (final con in _controllerList) {
      con.didChangeTextScaleFactor();
    }
    for (final listener in _afterList) {
      listener.didChangeTextScaleFactor();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
  }

  /// Called when the platform brightness changes.
  @protected
  @override
  @mustCallSuper
  void didChangePlatformBrightness() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangePlatformBrightness();
    }
    for (final con in _controllerList) {
      con.didChangePlatformBrightness();
    }
    for (final listener in _afterList) {
      listener.didChangePlatformBrightness();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  @protected
  @mustCallSuper
  @override
  void didChangeLocale(Locale locale) {
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeLocale(locale);
    }
    for (final con in _controllerList) {
      con.didChangeLocale(locale);
    }
    for (final listener in _afterList) {
      listener.didChangeLocale(locale);
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
  }

  /// Called when the system is running low on memory.
  @protected
  @override
  @mustCallSuper
  void didHaveMemoryPressure() {
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didHaveMemoryPressure();
    }
    for (final con in _controllerList) {
      con.didHaveMemoryPressure();
    }
    for (final listener in _afterList) {
      listener.didHaveMemoryPressure();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
  }

  /// Called when the system changes the set of currently active accessibility
  /// features.
  @protected
  @override
  @mustCallSuper
  void didChangeAccessibilityFeatures() {
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    for (final listener in _beforeList) {
      listener.didChangeAccessibilityFeatures();
    }
    for (final con in _controllerList) {
      con.didChangeAccessibilityFeatures();
    }
    for (final listener in _afterList) {
      listener.didChangeAccessibilityFeatures();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }
  }

  /// A flag indicating this is the very first build.
  bool _firstBuild = true;

  /// This method is also called immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  /// When a InheritedWidget's build() function is called
  /// it's dependencies' build() function are also called but not before
  /// their didChangeDependencies() function. Subclasses rarely use this method.
  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    // Important to 'markNeedsBuild()' first
    super.didChangeDependencies();

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeDependencies();
    }
    for (final con in _controllerList) {
      con.didChangeDependencies();
    }
    for (final listener in _afterList) {
      listener.didChangeDependencies();
    }
    super.didChangeDependencies();
    _rebuildAllowed = true;
    if (_rebuildRequested && !_firstBuild) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      setState(() {});
    }

    /// Not the first build now.
    _firstBuild = false;
  }

  /// During development, if a hot reload occurs, the reassemble method is called.
  /// This provides an opportunity to reinitialize any data that was prepared
  /// in the initState method.
  @protected
  @override
  @mustCallSuper
  void reassemble() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.reassemble();
    }
    for (final con in _controllerList) {
      // This state's association is severed.
//      con._popState(this);

      con.reassemble();
    }
    for (final listener in _afterList) {
      listener.reassemble();
    }
    super.reassemble();
    _rebuildAllowed = true;

    /// No 'setState()' function is necessary
    /// The framework always calls build with a hot reload.
    _rebuildRequested = false;
  }

  /// Allows 'external' routines can call this function.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  @override
  void setState(VoidCallback fn) {
    if (_rebuildAllowed) {
      _rebuildAllowed = false;

      // Don't bother if the State object is disposed of.
      if (mounted) {
        /// Refresh the interface by 'rebuilding' the Widget Tree
        /// Call the State object's setState() function.
        super.setState(fn);
      }
      _rebuildAllowed = true;
    } else {
      /// Can't rebuild at this moment but at least make the request.
      _rebuildRequested = true;
    }
  }

  // /// Allows the user to call setState() within the StateXController.
  // void refresh() => setState(() {});

  /// Link a widget to the InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) {
    var inherit = context != null;
    if (inherit) {
      final InheritedStateX? state =
          context.findAncestorStateOfType<InheritedStateX>();
      inherit = state != null;
      if (inherit) {
        final element = state.inheritedElement(context);
        inherit = element != null;
        if (inherit) {
          context.dependOnInheritedElement(element);
        }
      }
    }
    return inherit;
  }

  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  @Deprecated('Replaced by the recognized function, notifyClients')
  void buildInherited() {
    final state = context.findAncestorStateOfType<InheritedStateX>();
    state?.setState(() {});
  }

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  void notifyClients() {
    final state = context.findAncestorStateOfType<InheritedStateX>();
    state?.setState(() {});
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each StateX object.
  // details.exception, details.stack
  @protected
  void onError(FlutterErrorDetails details) => currentErrorFunc!(details);
}

/// Add, List, and Remove Listeners.
mixin StateListeners {
  List<StateListener> get _beforeList => _listenersBefore.toList();

  /// Returns a List of 'before' listeners by matching key identifiers.
  List<StateListener> beforeList(List<String> keys) {
    return _getList(keys, _listenersBefore);
  }

  final Set<StateListener> _listenersBefore = {};

  List<StateListener> get _afterList => _listenersAfter.toList();

  /// Returns the list of 'after' listeners by matching key identifiers.
  List<StateListener> afterList(List<String> keys) {
    return _getList(keys, _listenersAfter);
  }

  List<StateListener> _getList(List<String>? keys, Set<StateListener> set) {
    final List<StateListener> list = [];
    if (keys == null || keys.isEmpty) {
      return list;
    }
    for (final listener in set) {
      for (final key in keys) {
        if (listener._id == key) {
          list.add(listener);
          keys.remove(key);
          break;
        }
      }
    }
    return list;
  }

  final Set<StateListener> _listenersAfter = {};

  /// Add a listener fired 'before' the main controller runs.
  bool addBeforeListener(StateListener listener) =>
      _listenersBefore.add(listener);

  /// Add a listener fired 'after' the main controller runs.
  bool addAfterListener(StateListener listener) =>
      _listenersAfter.add(listener);

  /// Add a listener fired 'after' the main controller runs.
  bool addListener(StateListener listener) => addAfterListener(listener);

  /// Removes the specified listener.
  bool removeListener(StateListener listener) {
    bool removed = _listenersBefore.remove(listener);
    if (_listenersAfter.remove(listener)) {
      removed = true;
    }
    return removed;
  }

  /// Returns true of the listener specified is already added.
  bool beforeContains(StateListener listener) =>
      _listenersBefore.contains(listener);

  /// Returns true of the listener specified is already added.
  bool afterContains(StateListener listener) =>
      _listenersAfter.contains(listener);

  /// Returns the specified 'before' listener.
  StateListener? beforeListener(String key) =>
      _getStateEvents(key, _listenersBefore);

  /// Returns the specified 'after' listener.
  StateListener? afterListener(String key) =>
      _getStateEvents(key, _listenersAfter);

  StateListener? _getStateEvents(String? key, Set<StateListener> set) {
    StateListener? se;
    if (key == null || key.isEmpty) {
      return se;
    }
    for (final listener in set) {
      if (listener._id == key) {
        se = listener;
        break;
      }
    }
    return se;
  }

  void _disposeStateEventList() {
    _listenersBefore.clear();
    _listenersAfter.clear();
  }
}

/// Manages the number of 'Controllers' associated with this
/// StateX object at any one time during the App's lifecycle.
mixin _ControllerListing {
  StateX? _stateX;

  // Keep it private to allow subclasses to use 'con.'
  StateXController? _con(String? keyId) {
    if (keyId == null || keyId.isEmpty) {
      return null;
    }
    return _mapControllers[keyId];
  }

  /// Associate a list of 'Controllers' to this StateX object at one time.
  List<String> addList(List<StateXController> list) {
    //list.forEach(add);
    final List<String> keyIds = [];
    for (final con in list) {
      keyIds.add(add(con));
    }
    return keyIds;
  }

  /// Returns the list of 'Controllers' associated with this StateX object.
  List<StateXController?> listControllers(List<String> keys) =>
      _controllersMap(keys).values.toList();

  /// Never supply a public list of Controllers. User must know the key identifier(s).
  List<StateXController> get _controllerList => _asList; //_controllers.asList;

  /// Returns a specific 'StateXController' by looking up its unique 'key' identifier.
  Map<String, StateXController?> _controllersMap(List<String> keys) {
    final Map<String, StateXController?> controllers = {};

    for (final key in keys) {
      controllers[key] = map[key];
    }
    return controllers;
  }

  final Map<String, StateXController> _mapControllers = {};

  /// Returns a Map containing all the 'Controllers' associated with this
  /// StateX object each with their unique 'key' identifier.
  Map<String, StateXController> get map => _mapControllers;

  List<StateXController> get _asList => _mapControllers.values.toList();

  /// Add a 'StateXController' to then associate it to this
  /// particular StateX object. Returns the StateXController's
  /// unique 'key' identifier.
  String add(StateXController? con) {
    String id;

    if (con == null) {
      id = '';
    } else {
      /// This connects the StateXController to this State object!
      con._pushState(_stateX);

      /// It's already there?! Return its key.
      id = (contains(con)) ? con._id : addConId(con);

      if (!_cons.containsValue(con)) {
        _cons.addAll({con.runtimeType: con});
      }
    }
    return id;
  }

  /// Remove a 'StateXController' to then associate it to this
  /// particular StateX object. Returns the StateXController's
  /// unique 'key' identifier.
  String remove(StateXController? con) {
    String id;

    if (con == null) {
      id = '';
    } else {
      id = con.identifier;
      removeByKey(id);
      _cons.remove(con);
    }
    return id;
  }

  /// Remove a specific associated 'StateXController' from this StateX object
  /// by using its unique 'key' identifier.
  bool removeByKey(String keyId) {
    final con = _mapControllers[keyId];
    final there = con != null;
    if (there) {
      con._popState(_stateX);
      _mapControllers.remove(keyId);
    }
    return there;
  }

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get rootCon => _asList.isEmpty ? null : _asList.first;

  /// Returns true if the specified 'StateXController' is associated with this StateX object.
  bool contains(StateXController con) => _mapControllers.containsValue(con);

  void _disposeControllerListing() => _mapControllers.clear();

  /// Adds a 'StateXController' to be associated with this StateX object
  /// and returns StateXController's the unique 'key' identifier assigned to it.
  String addConId(StateXController con) {
    final keyId = con.identifier;
    _mapControllers[keyId] = con;
    return keyId;
  }

  final Map<Type, StateXController> _cons = {};
}

/// Your 'working' class most concerned with the app's functionality.
/// Add it to a 'StateX' object to associate it with that State object.
class StateXController with StateSetter, StateListener, RootState, AsyncOps {
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

  /// Return a List of Controllers specified by key id.
  List<StateXController?> listControllers(List<String> keys) =>
      _stateX!.listControllers(keys);

  /// Retrieve the 'before' listener by its unique key.
  StateListener? beforeListener(String key) => _stateX?.beforeListener(key);

  /// Retrieve the 'after' listener by its unique key.
  StateListener? afterListener(String key) => _stateX?.afterListener(key);

  /// Link a widget to a InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) =>
      _stateX?.dependOnInheritedWidget(context) ?? false;

  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  @Deprecated('Replaced by the recognized function, notifyClients')
  void buildInherited() => _stateX?.notifyClients();

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  void notifyClients() => _stateX?.notifyClients();
}

/// Allows you to call 'setState' from the 'current' the State object.
mixin StateSetter {
  /// Provide the setState() function to external actors
  void setState(VoidCallback fn) => _stateX?.setState(fn);

  /// Retrieve the State object by its StatefulWidget. Returns null if not found.
  StateX? stateOf<T extends StatefulWidget>() =>
      _stateWidgetMap.isEmpty ? null : _stateWidgetMap[_type<T>()];

  StateX? _stateX;
  final Set<StateX> _stateXSet = {};
  final Map<Type, StateX> _stateWidgetMap = {};
  bool _statePushed = false;

  /// Add the provided State object to the Map object if
  /// it's the 'current' StateX object in _stateX.
  void _addState(StateX state) {
    if (_statePushed && _stateX != null && _stateX == state) {
      _stateWidgetMap.addAll({state.widget.runtimeType: state});
    }
  }

  /// Add to a Set object and assigned to as the 'current' StateX
  /// However, if was already previously added, it's not added
  /// again to a Set object and certainly not set the 'current' StateX.
  bool _pushState(StateX? state) {
    //
    if (state == null) {
      return false;
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
  bool _popState([StateX? state]) {
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

      // Remove all State objects that have been disposed of.
      _stateXSet.retainWhere((item) => item.mounted);
      _stateWidgetMap.removeWhere((key, value) => !value.mounted);

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
//        state = stateList.firstWhere((item) => item is T);
      } catch (_) {
        state = null;
      }
    }
    return state == null ? null : state as T;
  }

  /// Return a 'copy' of the Set of State objects.
  Set<StateX> get states => Set.from(_stateXSet.whereType<StateX>());
}

/// Used to explicitly return the 'type' indicated.
Type _type<U>() => U;

/// Responsible for the event handling in all the Controllers, Listeners and Views.
mixin StateListener {
  /// A unique key is assigned to all State Controllers, State objects,
  /// and listeners. Used in large projects to separate objects into teams.
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
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [StateX] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).
  }

  /// Override this method to respond when the [StatefulWidget] is recreated.
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// The framework always calls build() after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
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
  /// [RouteInformation.location].
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      didPushRoute(routeInformation.location!);

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  void didChangeMetrics() {
    /// Called when the application's dimensions change. For example,
    /// when a phone is rotated.
    ///
    /// In general, this is not overriden often as the layout system takes care of
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

  /// {@macro on_platform_brightness_change}
  void didChangePlatformBrightness() {
    /// Brightness changed.
  }

  /// Called when the system tells the app that the user's locale has changed.
  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resumed
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
  void inactiveLifecycleState() {}

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void pausedLifecycleState() {}

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  void detachedLifecycleState() {}

  /// The application is visible and responding to user input.
  void resumedLifecycleState() {}

  /// Called when the system is running low on memory.
  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
  }

  /// Called when the system changes the set of active accessibility features.
  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].
  }
}

/// Supply a FutureBuilder to a State object.
mixin FutureBuilderStateMixin<T extends StatefulWidget> on State<T> {
  /// Implement this function instead of the build() function
  /// to utilize a built-in FutureBuilder Widget.
  Widget buildWidget(BuildContext context) => const SizedBox();

  /// Run the CircularProgressIndicator() until asynchronous operations are
  /// completed before the app proceeds.
  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
      future: initAsync(), initialData: false, builder: _futureBuilder);

  /// Used to complete asynchronous operations
  Future<bool> initAsync() async => true;

  Widget _futureBuilder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    //
    Widget? widget;
    FlutterErrorDetails? errorDetails;

    if (snapshot.hasData && snapshot.data!) {
      // Pass in the StatefulElement
      widget = buildWidget(this.context);
      //
    } else if (snapshot.connectionState == ConnectionState.done) {
      //
      if (snapshot.hasError) {
        //
        final dynamic exception = snapshot.error;

        errorDetails = FlutterErrorDetails(
          exception: exception,
          stack: exception is Error ? exception.stackTrace : null,
          library: 'state_extended.dart',
          context: ErrorDescription('While getting ready in FutureBuilder'),
        );

        // Possibly recover resources and close services before continuing to exit in error.
        onAsyncError(errorDetails);
        //
      } else {
        //
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
        if (UniversalPlatform.isAndroid || UniversalPlatform.isWeb) {
          //
          widget = const Center(child: CircularProgressIndicator());
        } else {
          //
          widget = const Center(child: CupertinoActivityIndicator());
        }
        // There was an error instead.
      } else {
        //
        FlutterError.reportError(errorDetails);

        widget = ErrorWidget.builder(errorDetails);
      }
    }
    return widget;
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  bool onAsyncError(FlutterErrorDetails details) => false;
}

// /// Main or first class to pass to the 'main.dart' file's runApp() function.
// abstract class AppStatefulWidget extends StatefulWidget {
//   /// Its sole purpose is to create the 'App State object', AppStateMVC.
//   const AppStatefulWidget({super.key});
//
//   /// You create the App's State object.
//   /// Return a type AppStateMVC that extends State<AppStatefulWidgetMVC>
//   @override
//   AppStateX createState();
// }

/// The StateX object at the 'app level.' Used to effect the whole app by
/// being the 'root' of first State object instantiated.
abstract class AppStateX<T extends StatefulWidget>
    extends InheritedStateX<T, _AppInheritedWidget> with _AppStates {
  /// Optionally supply as many State Controllers as you like to work with this App.
  /// Optionally supply a 'data object' to to be accessible to the App's InheritedWidget.
  AppStateX({
    StateXController? controller,
    List<StateXController>? controllers,
    Object? object,
  }) : super(
          inheritedBuilder: (child) => _AppInheritedWidget(
            child: child,
          ),
          controller: controller,
        ) {
    //Record this as the 'root' State object.
    setRootStateX(this);
    _dataObj = object;
    addList(controllers?.toList());
  }

  /// All the State Controllers in this app.
  final Set<StateXController> _controllers = {};

  bool _inSetStateBuilder = false;

  /// The 'data object' available to the framework.
  Object? _dataObj;

  /// Implement this function to compose the App's View.
  /// Return the 'child' Widget is then passed to an InheritedWidget
  @override
  Widget buildChild(BuildContext context);

  /// Use this build instead if you don't want to use the built-in InheritedWidget
  @override
  Widget buildWidget(BuildContext context) => super.buildWidget(context);

  /// Use the original build instead if you don't want to use the built-in FutureBuilder
  @override
  Widget build(BuildContext context) => super.build(context);

  /// Clean up memory
  /// Unlike dispose, this function is likely to always fire.
  @protected
  @mustCallSuper
  @override
  void dispose() {
    _controllers.clear();
    _states.clear();
    _clearRootStateX();
    super.dispose();
  }

  /// Call the build() functions of all the dependencies of the _InheritedWidget widget.
  void inheritedNeedsBuild([Object? object]) {
    if (object != null) {
      dataObject = object;
    }
    notifyClients();
  }

  /// Rebuild the InheritedWidget and its dependencies.
  @override
  @Deprecated('Replaced by the recognized function, notifyClients')
  void buildInherited() => super.setState(() {});

  /// In harmony with Flutter's own API
  @override
  void notifyClients() => super.setState(() {});

  /// Calls the State object's setState() function if not
  ///  (see class SetState below).
  @override
  void setState(VoidCallback fn) {
    // Don't if already in the SetState.builder() function
    if (!_inSetStateBuilder) {
      // If not called by the buildInherited() function
      if (mounted && !_buildInherited) {
        _inheritedStatefulWidget?.inheritedChildWidget = buildChild(context);
        super.setState(() {});
      }
    }
  }

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

  /// Return the latest StateX object currently being used if any.
  void refreshLastState() => _lastStateX()?.setState(() {});

  /// Returning the 'last' StateX.
  StateX? _lastStateX() {
    StateX? state;
    while (_states.isNotEmpty) {
      try {
        state = _states.values.last;
        // The state object is 'on the way out!'
        if (!state.mounted || state.deactivated) {
          // Remove state
          state = null;
          _states.remove(_states.keys.last);
          continue;
        }
        break;
      } catch (ex) {
        // Just get out and see if state is null.
        break;
      }
    }
    // Don't supply this State object if it's deactivated.
    if (state == null && mounted && !deactivated) {
      state = this;
    }
    return state;
  }
}

/// A InheritedWidget internally used by the 'App State' object
class _AppInheritedWidget extends InheritedWidget {
  ///
  _AppInheritedWidget({
    Key? key,
    required super.child,
  })  : dataObject = RootState._rootStateX?._dataObj,
        super(key: key);

  final Object? dataObject;

  @override
  InheritedElement createElement() => _AppInheritedElement(this);

  @override
  bool updateShouldNotify(_AppInheritedWidget oldWidget) {
    //
    bool notify = true;

    final rootState = RootState._rootStateX;

    if (rootState != null) {
      /// if StateSet objects were implemented and this wasn't called within one.
      notify = !rootState._inSetStateBuilder;

      if (!notify) {
        /// if the 'object' value has changed.
        notify = dataObject != oldWidget.dataObject;
      }
    }
    return notify;
  }
}

/// The InheritedElement used by the App's InheritedWidget
/// InheritedWidget's are used extensively in Flutter
/// Supply a separate InheritedElement allows for quick debugging
/// i.e Allow the developer to place breakpoints in this class
class _AppInheritedElement extends InheritedElement {
  _AppInheritedElement(super.widget);

  @override
  // ignore: unnecessary_overrides
  void setDependencies(Element dependent, Object? value) =>
      super.setDependencies(dependent, value);

  @override
  // ignore: unnecessary_overrides
  void notifyDependent(
          covariant InheritedWidget oldWidget, Element dependent) =>
      super.notifyDependent(oldWidget, dependent);
}

/// Works with the collection of State objects in the App.
mixin _AppStates {
  /// All the State objects in this app.
  final Map<String, StateX> _states = {};

  /// Retrieve the State object by type
  /// Returns null if not found
  T? stateByType<T extends StateX>() {
    StateX? state;
    try {
      for (final item in _states.values) {
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
  StateX? stateById(String? id) => _states[id];

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

  /// Returns a List of StateView objects using unique String identifiers.
  List<StateX> listStates(List<String> keys) {
    return statesById(keys).values.toList();
  }

  /// This is 'privatized' function as it is an critical method and not for public access.
  /// This contains the 'main list' of StateX objects present in the app!
  bool _addStateX(StateX? state) {
    bool add = state != null;
    if (add) {
      add = !_states.containsKey(state._id);
      if (add) {
        _states[state._id] = state;
      }
    }
    return add;
  }

  /// Remove the specified State object from static Set object.
  bool _removeStateX(StateX? state) {
    var removed = state != null;
    if (removed) {
      final int length = _states.length;
      _states.removeWhere((key, value) => state._id == key);
      removed = _states.length < length;
    }
    return removed;
  }
}

///  Used like the function, setState(), to 'spontaneously' call
///  build() functions here and there in your app. Much like the Scoped
///  Model's ScopedModelDescendant() class.
///  This class object will only rebuild if the App's InheritedWidget notifies it
///  as it is a dependency.
///  More information:
///  https://medium.com/flutter-community/shrine-in-mvc-7984e08d8e6b#488c
@protected
class SetState extends StatelessWidget {
  /// Supply a 'builder' passing in the App's 'data object' and latest BuildContext object.
  const SetState({Key? key, required this.builder}) : super(key: key);

  /// This is called with every rebuild of the App's inherited widget.
  final Widget Function(BuildContext context, Object? object) builder;

  /// Calls the required Function object:
  /// Function(BuildContext context, T? object)
  /// and passes along the InheritedWidget's custom 'object'
  ///
  @override
  Widget build(BuildContext context) {
    /// Go up the widget tree and link to the App's inherited widget.
    context.dependOnInheritedWidgetOfExactType<_AppInheritedWidget>();

    final rootState = RootState._rootStateX;

    if (rootState != null) {
      rootState._inSetStateBuilder = true;
      StateX._rebuildAllowed = false;
    }

    final Widget widget = builder(context, rootState?._dataObj);

    if (rootState != null) {
      StateX._rebuildAllowed = true;
      rootState._inSetStateBuilder = false;
    }
    return widget;
  }
}

/// Supply access to the 'Root' State object.
mixin RootState {
  ///Record the 'root' StateX object
  void setRootStateX(StateX state) {
    // This can only be called once successfully. Subsequent calls are ignored.
    // Important to prefix with the class name to 'share' this as a mixin.
    if (RootState._rootStateX == null && state is AppStateX) {
      // Important to prefix with the class name to 'share' this as a mixin.
      RootState._rootStateX = state;

      /// It must now add itself to the State objects list.
      state._addStateX(state);

      final controller = state.controller;

      if (controller != null) {
        /// Collect all the Controllers to the 'root' State object;
        state._controllers.add(controller);
      }
    }
  }

  /// To supply the static value across all instances of
  /// StateX objects, ControllerMVC objects and Model objects
  /// reference it using the class prefix, RootState.
  static AppStateX? _rootStateX;

  /// Returns the 'first' StateX object in the App
  // Important to prefix with the class name to 'share' this as a mixin.
  AppStateX? get rootState => RootState._rootStateX;

  // /// Return the 'latest' state object
  // StateX? get lastState => rootState?._lastStateX();

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => rootState?._lastStateX()?.context;

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
      state?._dataObj = object;
      // Call inherited widget to 'rebuild' any dependencies
      state?.notifyClients();
    }
  }

  /// Clear the static reference.
  /// Important to prefix with the class name to 'share' this as a mixin.
  void _clearRootStateX() => RootState._rootStateX = null;

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  bool get inDebugMode => inDebugger;

  ///
  //@Deprecated('Use inDebugMode. Need not be in a debugger.');
  bool get inDebugger {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

/// Supply the Async API
mixin AsyncOps {
  /// Used to complete asynchronous operations
  Future<bool> initAsync() async => true;

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  bool onAsyncError(FlutterErrorDetails details) => false;
}

/// A StateX object but inserts a InheritedWidget into the Widget tree.
abstract class InheritedStateX<T extends StatefulWidget,
    U extends InheritedWidget> extends StateX<T> {
  ///
  InheritedStateX({
    required this.inheritedBuilder,
    StateXController? controller,
  }) : super(controller);

  /// Return the 'type' of InheritedWidget
  Type get inheritedType => U;

  /// Supply a child Widget to the returning InheritedWidget's child parameter.
  final U Function(Widget child) inheritedBuilder;

  /// Build the 'child' Widget passed to the InheritedWidget.
  Widget buildChild(BuildContext context);

  /// Run the CircularProgressIndicator() until asynchronous operations are
  /// completed before the app proceeds.
  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
      future: initAsync(), initialData: false, builder: _futureBuilder);

  /// Implement this function instead of the build() function
  /// to utilize a built-in FutureBuilder.
  @override
  Widget buildWidget(BuildContext context) =>
      _inheritedStatefulWidget = initInheritedState<U>(inheritedBuilder);

  /// The Inherited StatefulWidget that contains the InheritedWidget.
  InheritedStatefulWidget? _inheritedStatefulWidget;

  /// Initialize the InheritedWidget State object
  InheritedStatefulWidget initInheritedState<V extends InheritedWidget>(
          V Function(Widget child) inheritedWidgetBuilder) =>
      // Create the StatefulWidget to contain the InheritedWidget
      // GlobalKey to 'keep' this StatefulWidget's state during it lifetime.
      InheritedStatefulWidget<V>(
          key: GlobalKey(),
          inheritedWidgetBuilder: inheritedWidgetBuilder,
          child: _BuildBuilder(key: GlobalKey(), builder: buildChild));

  /// Link a widget to a InheritedWidget of type U
  @override
  bool dependOnInheritedWidget(BuildContext? context) =>
      _inheritedStatefulWidget?.dependOnInheritedWidget(context) ?? false;

  ///
  InheritedElement? inheritedElement(BuildContext? context) =>
      _inheritedStatefulWidget?.inheritedElement(context);

  /// A flag to prevent infinite loops.
  bool _buildInherited = false;

  /// Don't rebuild this State object but the State object containing the InheritedWidget.
  /// Rebuild all the dependencies of the _InheritedWidget widget.
  @override
  void setState(VoidCallback fn) {
    _buildInherited = true;
    _inheritedStatefulWidget?.setState(fn);
    _buildInherited = false;
  }

  /// Provide a means to rebuild this State object anyway.
  void setSuperState(VoidCallback fn) => super.setState(fn);

  /// Rebuild the InheritedWidget and its dependencies.
  @override
  @Deprecated('Replaced by the recognized function, notifyClients')
  void buildInherited() => setState(() {});

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget and its dependencies.
  @override
  void notifyClients() => setState(() {});
}

/// Passes along a InheritedWidget to its State object.
class InheritedStatefulWidget<U extends InheritedWidget>
    extends StatefulWidget {
  /// No key so the state object is not rebuilt because it can't be.
  InheritedStatefulWidget({
    Key? key,
    required this.inheritedWidgetBuilder,
    required this.child,
  })  : state = _InheritedState(),
        super(key: key);

  /// Supply a child Widget to the returning InheritedWidget's child parameter.
  final U Function(Widget child) inheritedWidgetBuilder;

  /// The 'child' Widget eventually passed to the InheritedWidget.
  final Widget child;

  /// This StatefulWidget's State object.
  final _InheritedState state;

  @override
  //ignore: no_logic_in_create_state
  _InheritedState createState() => state;

  /// Link a widget to a InheritedWidget of type U
  bool dependOnInheritedWidget(BuildContext? context) {
    bool dependOn = context != null;
    if (dependOn) {
      final inheritedWidget = context.dependOnInheritedWidgetOfExactType<U>();
      dependOn = inheritedWidget != null;
    }
    return dependOn;
  }

  ///
  InheritedElement? inheritedElement(BuildContext? context) {
    InheritedElement? element;
    if (context != null) {
      element = context.getElementForInheritedWidgetOfExactType<U>();
    }
    return element;
  }

  /// The 'child' widget passed to the InheritedWidget
  Widget get inheritedChildWidget => state.child!;

  /// set the child widget.
  set inheritedChildWidget(Widget? child) => state.child = child;

  /// Call its State object's setState() function
  void setState(VoidCallback fn) => state._setState(fn);

  /// Rebuild the InheritedWidget and its dependencies.
  @Deprecated('Replaced by the recognized function, notifyClients')
  void buildInherited() => setState(() {});

  /// In harmony with Flutter's own API
  void notifyClients() => setState(() {});
}

class _InheritedState extends State<InheritedStatefulWidget> {
  //
  @override
  void initState() {
    super.initState();
    _widget = widget;
  }

  late InheritedStatefulWidget _widget;

  /// Supply an alternate 'child' Widget
  Widget? child;

  /// Called by the StatefulWidget
  void _setState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) =>
      _widget.inheritedWidgetBuilder(child ??= _widget.child);
}

/// Creates a Widget but supplying contents to its build() function
class _BuildBuilder extends StatelessWidget {
  const _BuildBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    late Widget widget;
    try {
      widget = builder(context);
    } catch (e) {
      //
      final errorDetails = FlutterErrorDetails(
        exception: e,
        stack: e is Error ? e.stackTrace : null,
        library: 'state_extended.dart',
        context:
            ErrorDescription("While building 'child' for InheritedWidget."),
      );

      FlutterError.reportError(errorDetails);

      widget = ErrorWidget.builder(errorDetails);
    }
    return widget;
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
