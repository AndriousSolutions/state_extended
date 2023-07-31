# StateX
[![codecov](https://codecov.io/gh/AndriousSolutions/state_extended/branch/master/graph/badge.svg)](https://app.codecov.io/gh/AndriousSolutions/state_extended/blob/master/lib/state_extended.dart)
[![CI](https://github.com/AndriousSolutions/state_extended/actions/workflows/format_test_release.yml/badge.svg)](https://github.com/AndriousSolutions/state_extended/actions/workflows/format_then_test.yml)
[![Medium](https://img.shields.io/badge/Medium-Read-green?logo=Medium)](https://medium.com/@andrious/statex-b8f57015188f)
[![Pub.dev](https://img.shields.io/pub/v/state_extended.svg?logo=data:image/png;base64,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)](https://pub.dev/packages/state_extended)
[![GitHub stars](https://img.shields.io/github/stars/AndriousSolutions/state_extended.svg?style=social&amp;logo=github)](https://github.com/AndriousSolutions/state_extended/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/AndriousSolutions/state_extended)](https://github.com/AndriousSolutions/state_extended/commits/master)

![statex](https://user-images.githubusercontent.com/32497443/178387749-1e28f27f-f64c-41df-b5c0-a7591f194e22.jpg)

## An Extension of the State class
This package expands the capabilities of Flutter's State class.
This fundamental component of Flutter's state management had room for improvement.
The capabilities of Flutter's State class now includes 'State Object Controllers' and the app's 'lifecycle events.'

StateX should not be confused with GetX, however, they do have their similarities.
In particular, both involve 'controllers' that generally contain the 'business logic' involved in any given app.
GetX has its GetxController class while StateX has its StateXController class.

### Installing

I don't always like the version number suggested in the '[Installing](https://pub.dev/packages/state_extended#-installing-tab-)' page.
Instead, always go up to the '**major**' semantic version number when installing my library packages. This means always entering a version number trailing with two zero, '**.0.0**'. This allows you to take in any '**minor**' versions introducing new features as well as any '**patch**' versions that involves bugfixes. Semantic version numbers are always in this format: **major.minor.patch**.

1. **patch** - I've made bugfixes
2. **minor** - I've introduced new features
3. **major** - I've essentially made a new app. It's broken backwards-compatibility and has a completely new user experience. You won't get this version until you increment the **major** number in the pubspec.yaml file.

And so, in this case, add this to your package's pubspec.yaml file instead:
```javascript
dependencies:
  state_extended:^4.1.0
```

## Documentation

Turn to this free Medium article for a full overview of the package plus examples:
[![StateX](https://user-images.githubusercontent.com/32497443/179269220-80efea47-b852-47c0-a073-b22f502dc437.jpg)](https://medium.com/@andrious/statex-b8f57015188f)

## Example Code
Further examples can be found in its Github repository: 
[example app](https://github.com/AndriousSolutions/state_extended/tree/master/example)
```dart
//
import 'package:flutter/material.dart';

import 'package:state_extended/state_extended.dart';

void main() => runApp(const MaterialApp(home: MyApp(key: Key('MyApp'))));

/// README.md example app
class MyApp extends StatefulWidget {
  ///
  const MyApp({Key? key}) : super(key: key);

  /// This is the App's State object
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends AppStateX<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();
  _MyAppState._() : super(controller: Controller());
  static _MyAppState? _this;

  /// Supplies a widget to AppStateX's InheritedWidget.
  @override
  Widget buildIn(BuildContext context) => const MyHomePage();
}

/// The Home page
class MyHomePage extends StatefulWidget {
  ///
  const MyHomePage({
    Key? key,
    this.title = 'Flutter InheritedWidget Demo',
  }) : super(key: key);

  /// Title of the screen
  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _MyHomePageState();
}

/// This is a subclass of the State class.
/// This subclass is linked to the App's lifecycle using [WidgetsBindingObserver]
class _MyHomePageState extends StateX<MyHomePage> {
  /// Let the 'business logic' run in a Controller
  _MyHomePageState() : super(Controller()) {
    /// Acquire a reference to the passed Controller.
    con = controller as Controller;
  }

  late Controller con;

  @override
  void initState() {
    /// Look inside the parent function and see it calls
    /// all it's Controllers if any.
    super.initState();

    /// Retrieve the 'app level' State object
    appState = rootState!;

    /// You're able to retrieve the Controller(s) from other State objects.
    final con = appState.controller;

    /// Another way to retrieve the 'app level' State object
    appState = con?.state!.startState as AppStateX;

    /// You can retrieve by type as well
    appState = stateByType<AppStateX>()!;
  }

  late AppStateX appState;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          /// Linked to the built-in InheritedWidget.
          /// A Text widget to display the counter is in here.
          /// ONLY IS WIDGET is updated with every press of the button.
          const CounterWidget(),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      key: const Key('+'),

      /// rebuilds only the Text widget containing the counter.
      onPressed: () => con.onPressed(),
      child: const Icon(Icons.add),
    ),
  );
}

/// Demonstrating the InheritedWidget's ability to spontaneously rebuild
/// its dependent widgets.
class CounterWidget extends StatefulWidget {
  /// Pass along the State Object Controller to make this widget
  /// dependent on the App's InheritedWidget.
  const CounterWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CounterState();
}

class _CounterState extends StateX<CounterWidget> {
  @override
  Widget buildF(BuildContext context) {
    /// Making this widget dependent will cause the build() function below
    /// to run again if and when the App's InheritedWidget calls its notifyClients() function.
    final con = Controller();
    con.dependOnInheritedWidget(context);
    return Text(
      '${con.count}',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

/// Everything a State object can do, this Controller can do as well!
class Controller extends StateXController {
  /// Utilizing the Singleton pattern is a good programming practice
  factory Controller([StateX? state]) => _this ??= Controller._(state);
  Controller._(StateX? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  int get count => _model.integer;

  /// The Controller deals with the event handling and business logic.
  void onPressed() {
    //
    _model.incrementCounter();
    // Call the InheritedWidget in AppStateX to rebuild its dependents.
    notifyClients();
  }

  /// Used for long asynchronous operations that need to be done
  /// before the app can be fully available to the user.
  /// e.g. Opening Databases, accessing Web servers, etc.
  @override
  Future<bool> initAsync() async {
    // Simply wait for 10 seconds at startup.
    /// In production, this is where databases are opened, logins attempted, etc.
    return Future.delayed(const Duration(seconds: 10), () {
      return true;
    });
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in initAsync() routine above.
  @override
  bool onAsyncError(FlutterErrorDetails details) => false;

  /// Like the State object, the Flutter framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  void initState() {
    super.initState();

    /// A State object can reference it's 'current' State object controller.
    var thisController = state?.controller;

    /// The same controller can be retrieved by its unique identifier if you know it.
    /// You then don't have to know the type or the type is private with a leading underscore.
    /// Note, it has to be a Controller explicitly added to the State object at some time.
    thisController = state?.controllerById(thisController?.identifier);

    assert(thisController == this,
    'Just demonstrating the means to retrieve a Controller.');

    /// You can retrieve a Controller's state object by its StatefulWidget
    /// Good if the state class type is unknown or private with a leading underscore.
    var stateObj = stateOf<MyHomePage>();

    /// Retrieve the 'app level' State object
    final appState = rootState;

    assert(appState is _MyAppState,
    "Every Controller has access to the 'first' State object.");

    /// The 'app level' State object has *all* the Stat objects running in the App
    /// at any one point of time.
    stateObj = appState?.stateByType<_MyHomePageState>();

    /// Retrieve the State object's controller.
    final appController = appState?.controller;

    /// You're able to retrieve the Controller(s) from other State objects.
    /// if you know their unique identifier.
    final con = appState?.controllerById(appController?.identifier);

    assert(appController == con, 'They should be the same object.');
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  @override
  void deactivate() {
    super.deactivate();
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    super.activate();
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
  }

  /// Called when the corresponding [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// The framework always calls build() after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
    super.didUpdateWidget(oldWidget);
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  @override
  void didChangeDependencies() {
    return super.didChangeDependencies();
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    return super.reassemble();
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  ///
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  @override
  Future<bool> didPopRoute() async {
    return super.didPopRoute();
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  /// This method exposes the `pushRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  @override
  Future<bool> didPushRoute(String route) async {
    return super.didPushRoute(route);
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  ///
  /// The default implementation is to call the [didPushRoute] directly with the
  /// [RouteInformation.location].
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    return super.didPushRouteInformation(routeInformation);
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) {
    didChangeLocale(locale);
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resumed
    super.didChangeAppLifecycleState(state);
  }

  /// The application is in an inactive state and is not receiving user input.
  ///
  /// On iOS, this state corresponds to an app or the Flutter host view running
  /// in the foreground inactive state. Apps transition to this state when in
  /// a phone call, responding to a TouchID request, when entering the app
  /// switcher or the control center, or when the UIViewController hosting the
  /// Flutter app is transitioning.
  ///
  /// On Android, this corresponds to an app or the Flutter host view running
  /// in the foreground inactive state.  Apps transition to this state when
  /// another activity is focused, such as a split-screen app, a phone call,
  /// a picture-in-picture app, a system dialog, or another window.
  ///
  /// Apps in this state should assume that they may be [pausedLifecycleState] at any time.
  @override
  void inactiveLifecycleState() {
    super.inactiveLifecycleState();
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    super.pausedLifecycleState();
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {
    super.detachedLifecycleState();
  }

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {
    super.resumedLifecycleState();
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
  }
}

/// This example has a separate class that contains the data.
class Model {
  /// the public API for this class. Describes you're dealing with an integer.
  int get integer => _integer;
  int _integer = 0;

  /// The business logic involves incrementing an integer.
  int incrementCounter() => ++_integer;
}
```