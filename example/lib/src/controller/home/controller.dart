// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/model.dart';

import 'package:example/src/view.dart';

///
class Controller extends StateXController {
  /// It's a good practice and follow the Singleton pattern.
  /// There's on need for more than one instance of this particular class.
  factory Controller([StateX? state]) => _this ??= Controller._(state);
  Controller._(StateX? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  int get count => _model.counter;

  /// The Controller knows how to 'talk to' the Model and to the View (interface).
  void incrementCounter() {
    //
    _model.incrementCounter();

    /// Retrieve a particular State object. The rest is ignore if not at 'HomePage'
    final homeState = stateOf<HomePage>();

    /// If working with a particular State object and if divisible by 5
    if (homeState != null && _model.counter % 5 == 0) {
      //
      dataObject = _model.sayHello();
    }

    // /// Just rebuild an InheritedWidget's dependencies.
    buildInherited();
    // Same as the buildInherited() function.
    notifyClients();
  }

  /// Call the State object's setState() function to reflect the change.
  void onPressed() => incrementCounter();

  /// **************  Life cycle events ****************

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  void initState() {
    super.initState();
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: initState');
    }
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  @override
  void deactivate() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: deactivate');
    }
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: activate');
    }
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: dispose');
    }
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: pausedLifecycleState');
    }
  }

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: resumedLifecycleState');
    }
  }

  /// The application is in an inactive state and is not receiving user input.
  @override
  void inactiveLifecycleState() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: inactiveLifecycleState');
    }
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: detachedLifecycleState');
    }
  }

  /// Override this method to respond when the [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didUpdateWidget');
    }
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  @override
  void didChangeDependencies() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didChangeDependencies');
    }
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: reassemble');
    }
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didPopRoute');
    }
    return super.didPopRoute();
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  @override
  Future<bool> didPushRoute(String route) async {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didPushRoute');
    }
    return super.didPushRoute(route);
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didPushRouteInformation');
    }
    return super.didPushRouteInformation(routeInformation);
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didChangeMetrics');
    }
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didChangeTextScaleFactor');
    }
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didChangePlatformBrightness');
    }
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didChangeLocale');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (inDebugger) {
    //   //ignore: avoid_print
    //   print('############ Event: didChangeAppLifecycleState');
    // }

    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resumed
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didHaveMemoryPressure');
    }
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    if (inDebugger) {
      //ignore: avoid_print
      print('############ Event: didChangeAccessibilityFeatures');
    }
  }
}
