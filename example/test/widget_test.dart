// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

import '../test/_test_imports.dart';

void main() => testMyApp();

late IntegrationTestsBinder _integrationTest;

/// Also called in package's own testing file, test/widget_test.dart
void testMyApp() {
  // Call this function instead of using the 'default' TestWidgetsFlutterBinding
  // Allows one or two errors to be ignored. The error handling is also tested.
  _integrationTest =
      IntegrationTestsBinder(); //   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets calls TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'test state_extended',
    (WidgetTester tester) async {
      //
      final app = MyApp(key: UniqueKey());

      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(app);

      /// Flutter won’t automatically rebuild your widget in the test environment.
      /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.

      /// pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle();

      /// Preform integration tests
      await integrationTesting(tester);

      /// Reset the counter to zero on Page 1
      await resetPage1Count(tester);

      /// Introduce State Listeners for the testing.
      await testsStateListener(tester);

      /// Testing the StateMVC, ControllerMVC, and ListenerMVC
      await unitTesting(tester);

      /// Now allow for errors to occur even during the testing
      _integrationTest.allowErrors = true;

      // Find its StatefulWidget first then the 'type' of State object.
      final appState = tester.firstState<AppStateX>(find.byType(MyApp));

      final appCon = appState.controller;

      if (appCon != null && appCon is AppController) {
        // Allow for errors to be thrown.
        appCon.allowErrors = true;
      }

      // hot reload
      await tester.binding.reassembleApplication();

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Go to Page 2
      await tester.tap(find.byKey(const Key('Page 2')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      AnotherController().tripError = true;

      // hot reload
      await tester.binding.reassembleApplication();

      // // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 2));

      /// Simulate Changing the text size.
      /// Done near the end of testing as it's a very disruptive test
      await testScaleFactor(tester);

      // Now trip an error right at start up.
      (appCon as AppController).errorAtStartup = true;

      // hot reload
      await tester.binding.reassembleApplication();

      // pumpAndSettle() waits for all animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));
    },
  );
}

class IntegrationTestsBinder extends IntegrationTestWidgetsFlutterBinding {
  /// Set so to 'take Exceptions' and continue errors to occur during testing.
  bool allowErrors = false;

  @override
  void reportExceptionNoticed(FlutterErrorDetails exception) {
    //
    if (allowErrors) {
      // 'Remove' the error shortly after it occurs to allow for possibly anothers.
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
