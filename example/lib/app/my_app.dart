// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

/// To be passed to the runApp() function.
/// This is the app's first StatefulWidget.
class MyApp extends StatefulWidget {
  /// A constant constructor
  const MyApp({super.key});

  /// The App object reference
  static final AppObject app = AppObject();

  /// The App's Preferences
  static SharedPreferencesAsync get prefs => app.prefs;

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
        ) {
    // Assign the App State object
    MyApp.app.appState = this;
  }

  /// Try these different 'build' functions so to get access
  /// to a built-in FutureBuilder and or an InheritedWidget.

  @override
  Widget build(BuildContext context) {
    return super.build(context);
    // Comment out the super.build() and stay with the traditional Flutter approach.
    // ignore: dead_code
    return MaterialApp(
      home: Page1(key: UniqueKey()),
    );
  }

  @override
  Widget buildF(BuildContext context) {
    return super.buildF(context);
    // Comment out super.buildF() and see how the initAsync() uses a FutureBuilder
    // to perform asynchronous operations while the State object starts up.
    // ignore: dead_code
    return MaterialApp(
      home: Page1(key: UniqueKey()),
    );
  }

  /// Use this instead of the build() function
  @override
  Widget builder(BuildContext context) {
    // Every State object has a controller property
    var con = controller as ExampleAppController;
    // Every State object has the App's main controller as a property.
    con = appCon as ExampleAppController;
    // Throw an error right here at the beginning to test recovery code.
    if (con.errorInBuilder) {
      con.errorInBuilder = false;
      throw Exception('Error in builder()!');
    }
    return MaterialApp(
      navigatorObservers:
          RouteObserverStates.list, // State object aware of route changes
      // A new key will recreate the State object
      home: Page1(key: con.page1Key),
    );
  }

  /// Set to true and see the built-in spinner at startup
  bool spinnerStartup = false;

  @override
  Widget? onSplashScreen(context) {
    Widget? widget;
    if (!spinnerStartup) {
      // No Splash screen during testing
      if (WidgetsBinding.instance is WidgetsFlutterBinding) {
        widget = const SplashScreen();
      }
    }
    return widget;
  }

  @override
  void onError(FlutterErrorDetails details) {
    //
    assert(() {
      debugPrint('########### onError() in $className');
      return true;
    }());

    final errorDetails = lastFlutterError();

    String message;

    if (errorDetails == null) {
      message = '';
    } else {
      message = errorDetails.exceptionAsString();
    }
  }

  /// Catch it if the initAsync() throws an error
  /// WITH GREAT POWER COMES GREAT RESPONSIBILITY
  /// Return true to ignore the error, false to continue the error handling
  @override
  Future<bool> catchAsyncError(Object error) async {
    // Don't log the next error.
    logStateXError = false;

    assert(() {
      debugPrint('########### catchAsyncError() in $className');
      return true;
    }());

    final errMag = error.toString();

    var caught = errMag.contains('Error in initAsync()!');

    if (!caught) {
      caught = errMag.contains('Error in AnotherController.initAsync()!');
    }

    if (caught) {
      assert(() {
        debugPrint(
            '########### Caught error in catchAsyncError() for $className');
        return true;
      }());
    }

    return caught;
  }

  @override
  void onAsyncError(errorDetails) {
    logErrorDetails(errorDetails);
    assert(() {
      debugPrint('########### onAsyncError in $className');
      return true;
    }());
  }

  @override
  // ignore: unnecessary_overrides
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    assert(() {
      debugPrint('########### updateShouldNotify in $className');
      return true;
    }());
    return super.updateShouldNotify(oldWidget);
  }

  @override
  // ignore: unnecessary_overrides
  bool dependOnInheritedWidget(BuildContext? context) {
    assert(() {
      debugPrint('########### dependOnInheritedWidget in $className');
      return true;
    }());
    return super.dependOnInheritedWidget(context);
  }
}
