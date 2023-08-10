// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

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

  /// The flag indicating if an InheritedWidget is to used.
  bool useInherited = false;

  /// Page1 count is saved periodically
  int page1Count = 0;

  /// Increment and then call the State object's setState() function to reflect the change.
  void onPressed() => incrementCounter();

  /// The Controller knows how to 'talk to' the Model and to the interface.
  void incrementCounter() {
    //
    _model.incrementCounter();

    /// Retrieve a particular State object. The rest is ignore if not at 'HomePage'
    final homeState = stateOf<HomePage>();

    // If we're not currently working with this particular State object
    if (homeState == null) {
      // Update the interface with the latest change.
      setState(() {});
    } else {
      /// If count is divisible by 5
      if (_model.counter % 5 == 0) {
        // Assigning a value will cause 'rootState?.notifyClients()'
        // Update the interface with the latest change.
        dataObject = _model.sayHello();
      } else {
        // Call those widget's 'dependent' on the App's InheritedWidget.
        // Update the interface with the latest change.
        rootState!.notifyClients();
      }
    }
  }

  /// **************  Life cycle events ****************
  ///
  ///

  @override
  Future<bool> initAsync() async {
    // Return false to test such a circumstance
    return !ExampleAppController().allowErrors;
  }

  /// The framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  void initState() {
    super.initState();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: initState in $state');
    }
  }

  /// The framework calls this method when the [StateX] object removed from widget tree.
  /// i.e. The screen is closed.
  @override
  void deactivate() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: deactivate in Controller for $state');
    }
  }

  /// Called when this State object was removed from widget tree for some reason
  /// Undo what was done when [deactivate] was called.
  @override
  void activate() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: activate in Controller for $state');
    }
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: YOU DON'T KNOW WHEN THIS WILL RUN in the Framework.
  /// PERFORM ANY TIME-CRITICAL OPERATION IN deactivate() INSTEAD!
  @override
  void dispose() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ now disposed.');
    }
    super.dispose();
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: pausedLifecycleState in Controller for $state');
    }
  }

  /// Called when app returns from the background
  @override
  void resumedLifecycleState() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: resumedLifecycleState in Controller for $state');
    }
  }

  /// If a State object is unexpectedly re-created
  /// You have to 'update' the properties of the new StateX object using the
  /// old StateX object because it's going to be disposed of.
  @override
  void updateNewStateX(oldState) {
    /// When a State object destroyed and a new one is re-created!
    /// This new StateX object may need to be updated with the old State object
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: updateNewStateX in Controller for $state');
    }
  }

  /// The application is in an inactive state and is not receiving user input.
  @override
  void inactiveLifecycleState() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: inactiveLifecycleState in Controller for $state');
    }
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: detachedLifecycleState in Controller for $state');
    }
  }

  /// Override this method to respond when the [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didUpdateWidget in Controller for $state');
    }
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  @override
  void didChangeDependencies() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeDependencies in Controller for $state');
    }
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: reassemble in Controller for $state');
    }
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPopRoute in Controller for $state');
    }
    return super.didPopRoute();
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  @override
  Future<bool> didPushRoute(String route) async {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPushRoute in Controller for $state');
    }
    return super.didPushRoute(route);
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didPushRouteInformation in Controller for $state');
    }
    return super.didPushRouteInformation(routeInformation);
  }

  /// The top route has been popped off, and this route shows up.
  @override
  void didPopNext() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPopNext in Controller for $state');
    }
    setState(() {});
  }

  /// Called when this route has been pushed.
  @override
  void didPush() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPush in Controller for $state');
    }
    setState(() {});
  }

  /// Called when this route has been popped off.
  @override
  void didPop() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPop in Controller for $state');
    }
    setState(() {});
  }

  /// New route has been pushed, and this route is no longer visible.
  @override
  void didPushNext() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPushNext in Controller for $state');
    }
    setState(() {});
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeMetrics in Controller for $state');
    }
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeTextScaleFactor in Controller for $state');
    }
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangePlatformBrightness in Controller for $state');
    }
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeLocale in Controller for $state');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resume
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeAppLifecycleState in Controller for ${this.state}');
    }
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didHaveMemoryPressure in Controller for $state');
    }
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    // inDebugger is deprecated but still tested here. Use inDebugMode instead.
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeAccessibilityFeatures in Controller for $state');
    }
  }
}
