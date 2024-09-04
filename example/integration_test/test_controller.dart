// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show AppExitResponse;

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

class TestStateController extends StateXController {
  factory TestStateController() => _this ??= TestStateController._();
  TestStateController._();
  static TestStateController? _this;

  @override
  void initState() {
    super.initState();
    assert(() {
      // ignore: avoid_print
      print('============ Event: initState() in $this');
      return true;
    }());
  }

  @override
  void deactivate() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: deactivate() in $this');
      return true;
    }());
  }

  @override
  void activate() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: activate() in $this');
      return true;
    }());
  }

  @override
  void dispose() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: activate() in $this');
      return true;
    }());
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didUpdateWidget() in $this');
      return true;
    }());
  }

  @override
  void didChangeDependencies() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangeDependencies() in $this');
      return true;
    }());
  }

  @override
  void reassemble() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: reassemble() in $this');
      return true;
    }());
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didPopRoute() in $this');
      return true;
    }());
    return super.didPopRoute();
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didPushRouteInformation() in $this');
      return true;
    }());
    return super.didPushRouteInformation(routeInformation);
  }

  @override
  void didPush() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didPush() in $this');
      return true;
    }());
  }

  @override
  void didPushNext() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didPushNext() in $this');
      return true;
    }());
  }

  @override
  void didPop() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didPop() in $this');
      return true;
    }());
  }

  @override
  void didPopNext() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didPopNext() in $this');
      return true;
    }());
  }

  @override
  void didChangeMetrics() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangeMetrics() in $this');
      return true;
    }());
  }

  @override
  void didChangeTextScaleFactor() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangeTextScaleFactor() in $this');
      return true;
    }());
  }

  @override
  void didChangePlatformBrightness() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangePlatformBrightness() in $this');
      return true;
    }());
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangeLocales() in $this');
      return true;
    }());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangeAppLifecycleState($state) in $this');
      return true;
    }());
  }

  @override
  void detachedAppLifecycleState() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: detachedAppLifecycleState() in $this');
      return true;
    }());
  }

  /// The application is visible and responding to user input.
  @override
  void resumedAppLifecycleState() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: resumedAppLifecycleState() in $this');
      return true;
    }());
  }

  @override
  void inactiveAppLifecycleState() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: inactiveAppLifecycleState() in $this');
      return true;
    }());
  }

  @override
  void hiddenAppLifecycleState() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: hiddenAppLifecycleState() in $this');
      return true;
    }());
  }

  @override
  void pausedAppLifecycleState() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: pausedAppLifecycleState() in $this');
      return true;
    }());
  }

  @override
  void didChangeAccessibilityFeatures() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didChangeAccessibilityFeatures() in $this');
      return true;
    }());
  }

  @override
  void didHaveMemoryPressure() {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didHaveMemoryPressure() in $this');
      return true;
    }());
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    assert(() {
      // ignore: avoid_print
      print('============ Event: didRequestAppExit() in $this');
      return true;
    }());
    return AppExitResponse.exit;
  }
}
