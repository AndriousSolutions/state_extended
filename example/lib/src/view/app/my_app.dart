// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

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
class _MyAppState extends AppStateX<MyApp> with ClassNameMixin {
  //
  _MyAppState()
      : super(
          controller: ExampleAppController(),
          controllers: [
            AnotherController(),
            YetAnotherController(),
          ],

          /// Demonstrate passing an 'object' down the Widget tree much like
          /// how it's done using Scoped Model, but better.
          object: 'Hello!',
          printEvents: true, // Print event function calls
        );

  @override
  void initState() {
    super.initState();
    final con = controller as ExampleAppController;
    // No Splash screen when testing
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      con.splashScreen = true;
    }

    /// Set these to run certain error handling
    // con.allowErrors = true;
    // con.errorAtStartup = true;
  }

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

  /// Use this instead of the build() function
  @override
  Widget builder(BuildContext context) {
    // Throw an error right here at the beginning to test recovery code.
    final appCon = controller as ExampleAppController;
    if (appCon.errorInBuilder) {
      appCon.errorInBuilder = false;
      throw Exception('Error in builder!');
    }
    return MaterialApp(
      navigatorObservers:
          RouteObserverStates.list, // State object aware of route changes
      // A new unique key will recreate the State object
      home: Page1(key: UniqueKey()),
    );
  }

  @override
  Widget? onSplashScreen(context) {
    Widget? widget;
    final con = ExampleAppController();
    if (con.splashScreen) {
      widget = const SplashScreen();
    }
    return widget;
  }

  @override
  void onError(FlutterErrorDetails details) {
    // For demonstration purposes, test if a particular error was handled.
    final errorDetails = lastFlutterError();

    String message;

    if (errorDetails == null) {
      message = '';
    } else {
      message = errorDetails.exceptionAsString();
    }

    // If not handled, call the parent class routine
    if (message.isEmpty ||
        !message.contains('Fake error to demonstrate error handling!')) {
      super.onError(details);
    }
  }

  @override
  // ignore: unnecessary_overrides
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return super.updateShouldNotify(oldWidget);
  }

  @override
  // ignore: unnecessary_overrides
  bool dependOnInheritedWidget(BuildContext? context) {
    return super.dependOnInheritedWidget(context);
  }
}
