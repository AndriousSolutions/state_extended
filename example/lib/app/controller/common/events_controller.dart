// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show AppExitResponse, Locale;

import 'package:flutter/foundation.dart';

import '/src/controller.dart';

///
mixin EventsControllerMixin on StateXController {
  ///
  String get className {
    if (_className == null) {
      final name = '$this';
      final hash = name.indexOf('#');
      if (hash > 0) {
        _className = name.substring(0, hash);
      } else {
        final parts = name.split(' ');
        _className = parts.last;
      }
    }
    return _className!;
  }

  set className(String? name) =>
      _className ??= name?.isEmpty ?? true ? null : name;

  String? _className;

  @override
  void initState() {
    super.initState();
    assert(() {
      if (kDebugMode) {
        debugPrint('########### initState() in $className');
      }
      return true;
    }());
  }

  /// Whenever it removes
  @override
  void deactivate() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### deactivate() in $className');
      }
      return true;
    }());
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### activate() in $className');
      }
      return true;
    }());
  }

  /// The framework calls this method when this StateX object will never
  /// build again.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
    assert(() {
      if (kDebugMode) {
        debugPrint('########### dispose() in $className');
      }
      return true;
    }());
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding runAsync() routine.
  @override
  void onAsyncError(FlutterErrorDetails details) {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### onAsyncError() in $className');
      }
      return true;
    }());
  }

  /// Error Handler
  void onError(FlutterErrorDetails details) {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### onError() in $className');
      }
      return true;
    }());
  }

    /// Called when this State is *first* added to as a Route observer?!
  @override
  void didPush() {
    super.didPush();
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didPush() in $className');
      }
      return true;
    }());
  }

  /// New route has been pushed, and this State object's route is no longer current.
  @override
  void didPushNext() {
    super.didPushNext();
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didPushNext() in $className');
      }
      return true;
    }());
  }

  /// Called when this State is popped off a route.
  @override
  void didPop() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didPop() in $className');
      }
      return true;
    }());
    super.didPop();
  }

  /// The top route has been popped off, and this route shows up.
  @override
  void didPopNext() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didPopNext() in $className');
      }
      return true;
    }());
    super.didPopNext();
  }

  /// This method is also called immediately after [initState].
  /// Otherwise called only if this State object's Widget
  /// is a 'dependency' of InheritedWidget.
  /// When a InheritedWidget's build() function is called
  /// the dependent widget's build() function is also called but not before
  /// their didChangeDependencies() function.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didChangeDependencies() in $className');
      }
      return true;
    }());
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didChangeMetrics() in $className');
      }
      return true;
    }());
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didChangeTextScaleFactor() in $className');
      }
      return true;
    }());
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didChangePlatformBrightness() in $className');
      }
      return true;
    }());
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didChangeLocales() in $className');
      }
      return true;
    }());
  }

  /// The application is in an inactive state and is not receiving user input.
  /// Apps in this state should assume that they may be [pausedAppLifecycleState] at any time.
  @override
  void inactiveAppLifecycleState() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### inactiveAppLifecycleState() in $className');
      }
      return true;
    }());
  }

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  @override
  void hiddenAppLifecycleState() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### hiddenAppLifecycleState() in $className');
      }
      return true;
    }());
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedAppLifecycleState() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### pausedAppLifecycleState() in $className');
      }
      return true;
    }());
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedAppLifecycleState() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### detachedAppLifecycleState() in $className');
      }
      return true;
    }());
  }

  /// The application is visible and responding to user input.
  @override
  void resumedAppLifecycleState() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### resumedAppLifecycleState() in $className');
      }
      return true;
    }());
  }

  /// Called when there's a memory constraint.
  @override
  void didHaveMemoryPressure() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didHaveMemoryPressure() in $className');
      }
      return true;
    }());
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    assert(() {
      if (kDebugMode) {
        debugPrint(
            '########### didChangeAccessibilityFeatures() in $className');
      }
      return true;
    }());
  }

  /// Called when a request is received from the system to exit the application.
  @override
  Future<AppExitResponse> didRequestAppExit() {
    assert(() {
      if (kDebugMode) {
        debugPrint('########### didRequestAppExit() in $className');
      }
      return true;
    }());
    return super.didRequestAppExit();
  }
}