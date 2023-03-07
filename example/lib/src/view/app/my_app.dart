// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// To be passed to the runApp() function.
/// This is the app's first StatefulWidget.
class MyApp extends StatefulWidget {
  /// A constant constructor
  const MyApp({super.key, this.throwErrors});

  /// Purposely throws errors as the app runs.
  final bool? throwErrors;

  /// This is the App's State object
  @override
  State createState() => _MyAppState();
}

///
class _MyAppState extends AppStateX<MyApp> {
  //
  _MyAppState()
      : super(
          controller: AppController(),
          controllers: [
            Controller(),
            AnotherController(),
            YetAnotherController(),
          ],

          /// Demonstrate passing an 'object' down the Widget tree much like
          /// in the Scoped Model
          object: 'Hello!',
        );

  /// Try these different 'build' functions so to get access
  /// to a built-in FutureBuilder and or an InheritedWidget.

  /// Override build() and stay with the traditional Flutter approach.
  // @override
  // Widget build(BuildContext context) => MaterialApp(
  //   home: Page1(key: UniqueKey()),
  // );

  /// Override buildF() and implement initAsync() and use a FutureBuilder
  /// to perform asynchronous operations while the app starts up.
  // @override
  // Widget buildF(BuildContext context) => MaterialApp(
  //       home: Page1(key: UniqueKey()),
  //     );

  /// Override buildIn() to use the FutureBuilder again but also
  /// the built-in InheritedWidget.
  @override
  Widget buildIn(BuildContext context) =>
      MaterialApp(home: Page1(key: GlobalKey()));

  ///
  @override
  bool get inFlutterTester => super.inFlutterTester;
}
