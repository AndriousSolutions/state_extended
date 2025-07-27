// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// import 'dart:io' show exit;

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart'
    show InMemorySharedPreferencesAsync;

import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart'
    show SharedPreferencesAsyncPlatform;

import '../test/_test_imports.dart';

const _location = '========================== widget_test.dart';

void main() => testExampleApp();

/// Call a group of tests.
void testExampleApp() {
  //
  group('Test state_extended', testStateExtended);
}

late IntegrationTestsBinder _integrationTest;

/// Also called in package's own testing file, test/widget_test.dart
void testStateExtended() {
  //
  // Call this function instead of using the 'default' TestWidgetsFlutterBinding
  // Allows one or two errors to be ignored. The error handling is also tested.
  _integrationTest =
      IntegrationTestsBinder(); //   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Set up anything necessary before testing begins.
  /// Runs once before ALL tests or groups
  setUpAll(() {
    // Must supply 'an instance' when testing SharedPreferencesAsync()
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    // Turn off the Example app's error triggers for now during testing
    _setupErrorsInTesting();
  });

  /// Be sure the close the app after all the testing.
  /// Runs once after ALL tests or groups
  tearDownAll(() {});

  /// Runs before EACH test or group  No!?
  setUp(() {
// // (TODO: Tip # 4) Consider configuring your default screen size here.
// // You can reset it to something else within a test
// binding.window.physicalSizeTestValue = _deskTopSize;
  });

  testWidgets(
    "Error in App's initAsync()",
    (WidgetTester tester) async {
      // Tells the tester to build a UI based on the widget tree passed to it
      // Loads the widget tree very similar to how runApp() works
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // Flutter won’t automatically rebuild your widget in the test environment.
      // Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // The App's Controller
      final appController = ExampleAppController();

      final appState = appController.appStateX;

      final errorInError = appState?.hasErrorInErrorHandler;

      expect(errorInError, isFalse, reason: _location);

      final details = appState?.lastFlutterErrorDetails;

      expect(details, isNotNull, reason: _location);

      final message = appState?.lastFlutterErrorMessage;

      expect(message?.contains("Error in App's initAsync()!"), isTrue,
          reason: _location);

      appController.initAppAsyncError = false;
    },
    variant: SetupTestEnvironment(),
  );

  testWidgets(
    'StateX & StateXController',
    (WidgetTester tester) async {
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 2));

      /// Preform integration tests
      await integrationTesting(tester);

      /// Now allow for errors to occur even during the testing
      _integrationTest.allowErrors = true;

      /// Unit testing the StateX and StateXController
      await unitTesting(tester);

      // Go to Page 2
      await tester.tap(find.byKey(const Key('Page 2')));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Go to Page 1
      await tester.tap(find.byKey(const Key('Page 1')));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      /// Simulate changing the text size.
      /// Done near the end of testing as it's a very disruptive test
      await testScaleFactor(tester);

      /// Simulate changing the screen size
      /// Done near the end of testing as it's a very disruptive test
      await testDidChangeMetrics(tester);

      /// Simulate some events (eg. paused and resumed the app)
      await testEventHandling(tester);
    },
    variant: SetupTestEnvironment(),
  );

  testWidgets(
    'debugPrint() in Event Handlers',
    (WidgetTester tester) async {
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      /// Flutter won’t automatically rebuild your widget in the test environment.
      /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
      /// pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // The App's Controller
      final appController = ExampleAppController();

      /// Now print to console every event handler call
      appController.debugPrintEvents = true;

      /// Reset the counter to zero on Page 1
      await resetPage1Count(tester);

      /// Now print to console every event handler call
      appController.debugPrintEvents = false;

      // hot reload
      await tester.binding.reassembleApplication();

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));
    },
    variant: SetupTestEnvironment(),
  );

  testWidgets(
    'Error in Builder()',
    (WidgetTester tester) async {
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      // The App's Controller
      final appController = ExampleAppController();

      // Now trip an error going to Page 2
      appController.errorInBuilder = true;

      // Go to Page 2
      await tester.tap(find.byKey(const Key('Page 2')));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final appState = appController.appStateX;

      final errorInError = appState?.hasErrorInErrorHandler;

      expect(errorInError, isFalse, reason: _location);

      final details = appState?.lastFlutterErrorDetails;

      expect(details, isNotNull, reason: _location);

      final message = appState?.lastFlutterErrorMessage;

      expect(message?.contains('Error in builder()!'), isTrue,
          reason: _location);

      final inError = appState?.inErrorRoutine;

      expect(inError, isFalse, reason: _location);

      // final name = appState?.errorStateName;
      //
      // expect(name?.contains('Page2State'), isTrue, reason: _location);

      // Turn off the error
      appController.errorInBuilder = false;
    },
    variant: SetupTestEnvironment(),
  );

  testWidgets(
    'initAsyncError() in AnotherController',
    (WidgetTester tester) async {
      //
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      AnotherController().anotherInitAsyncError = true;

      // Waits for all animations to complete.
      await tester.pumpAndSettle();

      // Go to Page 2
      await tester.tap(find.byKey(const Key('Page 2')));

      // Waits for all animations to complete.
      await tester.pumpAndSettle();

      AnotherController().anotherInitAsyncError = false;
    },
    variant: SetupTestEnvironment(),
  );

  //
  testWidgets(
    'catchAsyncError',
    (WidgetTester tester) async {
      //
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // Invoke an error in initAsyncError()
      AnotherController().anotherInitAsyncError = true;

      // Now have that error in initAsyncError() be unrecoverable
      ExampleAppController().errorCatchAsyncError = true;

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      ExampleAppController().errorCatchAsyncError = false;

      AnotherController().anotherInitAsyncError = false;
    },
    variant: SetupTestEnvironment(),
  );
}

/// Setup and teardown each test
class SetupTestEnvironment extends TestVariant<void> {
  // Record and restore the original Error Builder widget
  late ErrorWidgetBuilder _errorWidgetBuilder;

  @override
  Iterable<void> get values => const <void>[null];

  @override
  String describeValue(void value) => '';

  /// Runs before EACH test or group
  @override
  Future<void> setUp(void value) async {
// Record the original Error Builder widget
    _errorWidgetBuilder = ErrorWidget.builder;
  }

  /// Runs after EACH test or group
  @override
  Future<void> tearDown(void value, void memento) async {
    // Restore to original Error Builder widget
    ErrorWidget.builder = _errorWidgetBuilder;
  }
}

// Turn off the Example app's error triggers for now during testing
void _setupErrorsInTesting() {
  //
  final appSettings = AppSettingsController();

  // Allow for a delay in testing
  appSettings.initAsyncDelay = false;

  // Don't error when the counter button is pressed
  appSettings.errorButton = false;

  // Don't error in Page 2's build() function
  appSettings.errorInBuilder = false;

  // Don't supply a custom error screen just yet
  appSettings.customErrorScreen = false;

  // Error right at startup in the App's initAsync() function
  // appSettings.initAppAsyncError = false;
  appSettings.initAppAsyncError = true;

  // Catch the error in the App's initAsync() function
  appSettings.catchInitAppAsyncError = true;

  // Don't error in the AnotherController's initAsync() function
  appSettings.anotherInitAsyncError = false;

  // Catch the error in the AnotherController's initAsync() function
  appSettings.catchAnotherInitAsyncError = true;

  // Don't return false in the AnotherController's initAsync() function
  appSettings.initAsyncReturnsFalse = false;

  // Don't error in the very catchAsyncError() function
  appSettings.errorCatchAsyncError = false;

  // Catch the error in the very catchAsyncError() function
  appSettings.catchErrorCatchAsyncError = true;

  // Use a particular interface
  appSettings.useMaterial3 = true;

  // Save to Stored preferences
  appSettings.reassemble();
}

class IntegrationTestsBinder extends IntegrationTestWidgetsFlutterBinding {
  /// Set so to 'take Exceptions' and continue errors to occur during testing.
  bool allowErrors = false;

  @override
  void reportExceptionNoticed(FlutterErrorDetails exception) {
    //
    if (allowErrors) {
      // 'Remove' the error shortly after it occurs to allow for others.
      Future.delayed(const Duration(milliseconds: 3), () {
        // Only attempt the delay while still 'testing' or testing will fail.
        if (inTest) {
          // Take in the exception so to allow for further exceptions
          takeException();
        }
      });
    }
  }
}
