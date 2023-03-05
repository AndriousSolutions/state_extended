import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

/// Simulate some App 'life cycle' events.
Future<void> testEventHandling(WidgetTester tester) async {
  //
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

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

  /// Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

/// Simulate some App 'life cycle' events.
Future<void> testWidgetsBindingObserver(WidgetTester tester) async {
  // locale
  await tester.binding.setLocale('zh', 'zh_CN');

  // didChangeTextScaleFactor
  tester.binding.platformDispatcher.textScaleFactorTestValue = 4;
  addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pump();

  /// Give the app time to recover and indeed resume testing.
  await tester.pumpAndSettle(const Duration(seconds: 1));
}
