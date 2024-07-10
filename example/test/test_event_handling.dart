import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_event_handling.dart';

/// Simulate some App 'life cycle' events.
Future<void> testEventHandling(WidgetTester tester) async {
  // Simulate a 'release focus' then refocus event
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

  // Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 5));

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

  // didChangeTextScaleFactor event handler function is called
  tester.binding.platformDispatcher.textScaleFactorTestValue = 4;

  // Clear scale factor after testing is over
  addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);

  /// Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));

  // Remove the indicated controller
  expect(state.removeByKey(id), isTrue, reason: _location);
}

///
Future<void> testDidChangeMetrics(WidgetTester tester) async {
  // didChangeMetrics
  /// Done near the end of testing as it's a very disruptive test
  tester.view.physicalSize = const Size(42, 42);

  addTearDown(tester.view.resetPhysicalSize);

  // pumpAndSettle() waits for all animations to complete.
  await tester.pumpAndSettle(const Duration(seconds: 1));
}
