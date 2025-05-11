// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// import 'dart:io' show exit;

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

import '../test/_test_imports.dart';

void main() => testExampleApp();

/// Call a group of tests.
void testExampleApp() => group('Test state_extended', testStateExtended);

late IntegrationTestsBinder _integrationTest;

/// Also called in package's own testing file, test/widget_test.dart
void testStateExtended() {
  //
  /// Set up anything necessary before testing begins.
  /// Runs once before ALL tests or groups
  setUpAll(() async {});

  /// Be sure the close the app after all the testing.
  /// Runs once after ALL tests or groups
  tearDownAll(() {});

  /// Runs before EACH test or group
  setUp(() async {
    // // (TODO: Tip # 4) Consider configuring your default screen size here.
    // // You can reset it to something else within a test
    // binding.window.physicalSizeTestValue = _deskTopSize;
  });

  /// Runs after EACH test or group
  tearDown(() async {
    // Code that clears caches can go here
//    exit(0);  // Closes the whole thing!
  });

  // Call this function instead of using the 'default' TestWidgetsFlutterBinding
  // Allows one or two errors to be ignored. The error handling is also tested.
  _integrationTest =
      IntegrationTestsBinder(); //   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets calls TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'StateX & StateXController',
    (WidgetTester tester) async {
      //
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      /// Flutter won’t automatically rebuild your widget in the test environment.
      /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.
      /// pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

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
    },
  );

  testWidgets('Error in Builder', (WidgetTester tester) async {
    //
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(MyApp(key: UniqueKey()));

    // pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();

    // Now trip an error right at start up.
    ExampleAppController().errorInBuilder = true;

    // hot reload
    await tester.binding.reassembleApplication();

    // pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets(
    'initAsyncError',
    (WidgetTester tester) async {
      //
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(MyApp(key: UniqueKey()));

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      AnotherController().initAsyncError = true;

      // hot reload
      await tester.binding.reassembleApplication();

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));
    },
  );

  //
  testWidgets('catchAsyncError', (WidgetTester tester) async {
    //
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(MyApp(key: UniqueKey()));

    // pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();

    AnotherController().initAsyncError = true;

    // Now trip an error right at start up.
    ExampleAppController().errorCatchAsyncError = true;

    // hot reload
    await tester.binding.reassembleApplication();

    // pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
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
