import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_event_handling.dart';

/// Simulate some App 'life cycle' events.
Future<void> testEventHandling(WidgetTester tester) async {
  //
  // A Singleton pattern allows for unit testing.
  final con = Controller();

  final state = con.state!;

  // Simulate a 'release focus' then refocus event
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);

  var event = state.inactiveAppLifecycle;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);

  event = state.hiddenAppLifecycle;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

  event = state.pausedAppLifecycle;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);

  event = state.detachedAppLifecycle;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

  event = state.resumedAppLifecycle;

  if (event) {
    expect(event, isTrue, reason: _location);
  }

  // Give the app time to recover and resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 2));

  // locale
  await tester.binding.setLocale('zh', 'zh_CN');

  // didChangePlatformBrightness
  tester.binding.platformDispatcher.platformBrightnessTestValue =
      Brightness.dark;
  addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue);

  await tester.pump();

  // didChangeAccessibilityFeatures
  tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures.allOn;
  addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue);

  // Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 5));

  final systemEvent = state.hadSystemEvent;

  if (systemEvent) {
    /// The app has had some System events occurring.
    expect(systemEvent, isTrue, reason: _location);
  }

  if (!state.hiddenAppLifecycle) {
    // Should not happen, but don't trip it here regardless! gp
    expect(state.hiddenAppLifecycle, isFalse, reason: _location);
  }
}

///
Future<void> testScaleFactor(WidgetTester tester) async {
  //
  // A Singleton pattern allows for unit testing.
  final con = Controller();

  // You can retrieve a State object the Controller has collected so far.
  final state = con.stateOf<Page1>()!;

  final testController = TestStateController();

  final id = state.add(testController);

  expect(id, isNotEmpty, reason: _location);

  // Don't report the error to the Tester
  con.appStateX?.ignoreErrorInTesting = true;

  // Record the scale
  final textScale = tester.binding.platformDispatcher.textScaleFactor;

  // didChangeTextScaleFactor event handler function is called
  tester.binding.platformDispatcher.textScaleFactorTestValue = 4;

  // // Clear scale factor after testing is over
  // addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);

  /// Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));

  // Original scale
  tester.binding.platformDispatcher.textScaleFactorTestValue = textScale;

  /// Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));

  // Remove the indicated controller
  expect(state.removeByKey(id), isTrue, reason: _location);
}

///
Future<void> testDidChangeMetrics(WidgetTester tester) async {
  // Don't report the error to the Tester
  Controller().appStateX?.ignoreErrorInTesting = true;

  final physicalSize = tester.view.physicalSize;

  // didChangeMetrics
  /// Done near the end of testing as it's a very disruptive test
  tester.view.physicalSize = Size(physicalSize.width, physicalSize.height + 1);

  // pumpAndSettle() waits for all animations to complete.
  await tester.pumpAndSettle(const Duration(seconds: 1));

  // addTearDown(tester.view.resetPhysicalSize);

  tester.view.physicalSize = physicalSize;

  // pumpAndSettle() waits for all animations to complete.
  await tester.pumpAndSettle(const Duration(seconds: 1));
}
