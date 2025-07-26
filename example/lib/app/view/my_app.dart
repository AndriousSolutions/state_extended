// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart' as debug;

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
class _MyAppState extends AppStateX<MyApp> with EventsStateMixin {
  //
  _MyAppState()
      : dev = DevTools(),
        super(
          controller: ExampleAppController(),
          controllers: [
            BuildErrorWidget(header: 'Error', appName: 'Three-page example'),
            AnotherController(),
            YetAnotherController(),
          ],

          /// Passing an 'object' down the Widget tree much like
          /// how it's done using Scoped Model, but better.
          object: 'Hello!',
          // debugPrintEvents: true, // Print event function calls to the console
          debugPrintEvents: false, // Do not print event function calls
        ) {
    // Assign the App State object
    MyApp.app.appState = this;
  }

  final DevTools dev;

  /// Place a breakpoint to see the inner workings
  @override
  void dispose() {
    super.dispose();
  }

  /// Try these different 'build' functions so to get access
  /// to a built-in FutureBuilder and or an InheritedWidget.

  @override
  Widget build(BuildContext context) {
    //
    assert(() {
      // Highlights UI while debugging.
      debug.debugPaintSizeEnabled = dev.debugPaintSizeEnabled;
      debug.debugPaintBaselinesEnabled = dev.debugPaintBaselinesEnabled;
      debug.debugPaintPointersEnabled = dev.debugPaintPointersEnabled;
      debug.debugPaintLayerBordersEnabled = dev.debugPaintLayerBordersEnabled;
      debug.debugRepaintRainbowEnabled = dev.debugRepaintRainbowEnabled;
      debug.debugRepaintTextRainbowEnabled = dev.debugRepaintTextRainbowEnabled;
      return true;
    }());
    // Comment out the super.build() and use the traditional Flutter approach.
    return super.build(context);
    // ignore: dead_code
    final con = controller as ExampleAppController;
    return MaterialApp(
      color: Colors.blue,
      theme: con.themeData,
      home: Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(child: DevToolsSettings()),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            WordPairsTimer().deactivate();
          } else {
            WordPairsTimer().activate();
          }
        },
        body: Page1(),
      ),
    );
  }

  /// Use this instead of the build() function
  @override
  Widget builder(BuildContext context) {
    // Every State object has a controller property
    var con = controller as ExampleAppController;
    // Every State object has the App's main controller as a property.
    con = appCon as ExampleAppController;
    //
    return MaterialApp(
      debugShowMaterialGrid: dev.debugShowMaterialGrid,
      showPerformanceOverlay: dev.showPerformanceOverlay,
      showSemanticsDebugger: dev.showSemanticsDebugger,
      debugShowCheckedModeBanner: dev.debugShowCheckedModeBanner,
      navigatorObservers: RouteObserverStates.list,
      color: Colors.blue,
      theme: con.themeData,
      home: Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(child: DevToolsSettings()),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            WordPairsTimer().deactivate();
            // con.onOpenDrawer();
          } else {
            WordPairsTimer().activate();
            // con.onCloseDrawer();
          }
        },
        body: Page1(),
      ),
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

  /// Catch it if the initAsync() throws an error
  /// WITH GREAT POWER COMES GREAT RESPONSIBILITY
  /// Return true to ignore the error, false to continue the error handling
  @override
  Future<bool> catchAsyncError(Object error) async {
    // Don't log the next error.
    logStateXError = false;

    assert(() {
      debugPrint('=========== catchAsyncError() in $eventStateClassName');
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
            '=========== Caught error in catchAsyncError() for $eventStateClassName');
        return true;
      }());
    }

    return caught;
  }

  @override
  void onAsyncError(errorDetails) {
    logErrorDetails(errorDetails);
  }

  /// ========================================= Unnecessary overrides but helpful to you

  /// Using your favorite IDE, place a breakpoint in deactivate()
  ///  and get an appreciation of what's involved in closing a screen
  @override
  void deactivate() {
    super.deactivate();
  }

  /// Using your favorite IDE, place a breakpoint in setState()
  ///  and get an appreciation of what's involved in closing a screen
  @override
  // ignore: unnecessary_overrides
  void setState(VoidCallback fn, {bool? log}) => super.setState(fn, log: log);
}
