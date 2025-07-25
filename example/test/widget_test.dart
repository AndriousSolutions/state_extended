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
  });

  /// Be sure the close the app after all the testing.
  /// Runs once after ALL tests or groups
  tearDownAll(() {});

  /// Runs before EACH test or group
  setUp(() {
// // (TODO: Tip # 4) Consider configuring your default screen size here.
// // You can reset it to something else within a test
// binding.window.physicalSizeTestValue = _deskTopSize;
  });

  /// Runs after EACH test or group
  tearDown(() {
// Code that clears caches can go here
//    exit(0);  // Closes the whole thing!
  });

  testWidgets(
    'StateX & StateXController',
    (WidgetTester tester) async {
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // Invoke an error off the hop.
      ExampleAppController().initAppAsyncError = true;

      AnotherController().initAsyncFailed = true;

      /// Flutter won’t automatically rebuild your widget in the test environment.
      /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
      /// pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      AnotherController().initAsyncFailed = false;

      ExampleAppController().initAppAsyncError = false;

      /// Preform integration tests
      await integrationTesting(tester);

      /// Reset the counter to zero on Page 1
      await resetPage1Count(tester);

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

      /// Now print to console every event handler call
      ExampleAppController().debugPrintEvents = true;

      /// Flutter won’t automatically rebuild your widget in the test environment.
      /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
      /// pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      /// Reset the counter to zero on Page 1
      await resetPage1Count(tester);

      /// Now print to console every event handler call
      ExampleAppController().debugPrintEvents = false;

      // hot reload
      await tester.binding.reassembleApplication();

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));
    },
    variant: SetupTestEnvironment(),
  );

  testWidgets(
    'Error in Builder',
    (WidgetTester tester) async {
      //
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      // Now trip an error going to Page 2
      ExampleAppController().errorInBuilder = true;

      // Go to Page 2
      await tester.tap(find.byKey(const Key('Page 2')));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final appState = ExampleAppController().appStateX;

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
      ExampleAppController().errorInBuilder = false;
    },
    variant: SetupTestEnvironment(),
  );

  testWidgets(
    'initAsyncError',
    (WidgetTester tester) async {
      //
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      AnotherController().initAsyncError = true;

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      AnotherController().initAsyncError = false;
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
      AnotherController().initAsyncError = true;

      // Now have that error in initAsyncError() be unrecoverable
      ExampleAppController().errorCatchAsyncError = true;

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      ExampleAppController().errorCatchAsyncError = false;

      AnotherController().initAsyncError = false;
    },
    variant: SetupTestEnvironment(),
  );
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
