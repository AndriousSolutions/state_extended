import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '../test/_test_imports.dart';

const _location = '========================== test_event_handling.dart';

/// Simulate some App 'life cycle' events.
Future<void> testEventHandling(WidgetTester tester) async {
  //
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
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

  await tester.pump();

  // didChangeMetrics
  tester.binding.window.physicalSizeTestValue = const Size(42, 42);
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

  await tester.pump();

  // Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

Future<void> testScaleFactor(WidgetTester tester) async {
  //
  // A Singleton pattern allows for unit testing.
  final con = Controller();

  // You can retrieve a State object the Controller has collected so far.
  final state = con.stateOf<Page1>()!;

  final testController = TestStateController();

  final id = state.add(testController);

  expect(id, isNotEmpty, reason: _location);

  final listener = TesterStateListener();

  // Testing Listeners during the event
  state.addBeforeListener(listener);

  state.addListener(listener);

// didChangeTextScaleFactor
  tester.binding.platformDispatcher.textScaleFactorTestValue = 4;
  addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);

  /// Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));

  // Remove the indicated controller
  expect(state.removeByKey(id), isTrue, reason: _location);

  // Testing Listeners during the event
  state.removeListener(listener);
}
