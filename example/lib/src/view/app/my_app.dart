// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// To be passed to the runApp() function.
/// This is the app's first StatefulWidget.
class MyApp extends StatefulWidget {
  /// A constant constructor
  const MyApp({super.key});

  /// This is the App's State object
  @override
  State createState() => _MyAppState();
}

///
class _MyAppState extends AppStateX<MyApp> {
  //
  _MyAppState()
      : super(
          controller: ExampleAppController(),
          controllers: [
            AnotherController(),
            YetAnotherController(),
          ],

          /// Demonstrate passing an 'object' down the Widget tree much like
          /// in the Scoped Model
          object: 'Hello!',
        );

  /// Try these different 'build' functions so to get access
  /// to a built-in FutureBuilder and or an InheritedWidget.

  @override
  Widget build(BuildContext context) {
    return super.build(context);
    // Comment out the super.build() and stay with the traditional Flutter approach.
    return MaterialApp(
      home: Page1(key: UniqueKey()),
    );
  }

  @override
  Widget buildF(BuildContext context) {
    return super.buildF(context);
    // Comment out super.buildF() and see how the initAsync() uses a FutureBuilder
    // to perform asynchronous operations while the State object starts up.
    return MaterialApp(
      home: Page1(key: UniqueKey()),
    );
  }

  /// Use buildIn() to use the built-in FutureBuilder and InheritedWidget.
  /// buildIn() replaces build() is most apps
  @override
  Widget buildIn(BuildContext context) {
    // Throw an error right here at the beginning to test recovery code.
    var throwError = controller is ExampleAppController;
    if (throwError) {
      final appCon = controller as ExampleAppController;
      throwError = appCon.errorAtStartup;
      // It'll trip again instantly and so don't trip it again.
      appCon.errorAtStartup = false;
    }
    if (throwError) {
      throw AssertionError('Error in buildIn!');
    }
    return MaterialApp(
      // A new unique key will recreate the State object
      home: Page1(key: UniqueKey()),
    );
  }
}
