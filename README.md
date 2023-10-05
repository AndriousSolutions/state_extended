# StateX
[![codecov](https://codecov.io/gh/AndriousSolutions/state_extended/branch/master/graph/badge.svg)](https://app.codecov.io/gh/AndriousSolutions/state_extended/blob/master/lib/state_extended.dart)
[![CI](https://github.com/AndriousSolutions/state_extended/actions/workflows/format_test_release.yml/badge.svg)](https://github.com/AndriousSolutions/state_extended/actions/workflows/format_then_test.yml)
[![Medium](https://img.shields.io/badge/Medium-Read-green?logo=Medium)](https://medium.com/@andrious/statex-b8f57015188f)
[![Pub.dev](https://img.shields.io/pub/v/state_extended.svg?logo=data:image/png;base64,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)](https://pub.dev/packages/state_extended)
[![GitHub stars](https://img.shields.io/github/stars/AndriousSolutions/state_extended.svg?style=social&amp;logo=github)](https://github.com/AndriousSolutions/state_extended/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/AndriousSolutions/state_extended)](https://github.com/AndriousSolutions/state_extended/commits/master)

![statex](https://user-images.githubusercontent.com/32497443/178387749-1e28f27f-f64c-41df-b5c0-a7591f194e22.jpg)

## An Extension of the State class
This package extends the capabilities of Flutter's State class.
This fundamental component of Flutter's state management had room for improvement.
The capabilities of Flutter's State class now includes a 'State Object Controller' and the some 22 'lifecycle events.'

StateX should not be confused with GetX.
Both do involve 'controllers' that generally contain the 'business logic' involved in an app.
GetX has its GetxController class while StateX has its StateXController class, 
but the similarities stops there.

<img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/716e2d31-1cfe-4d79-bed0-fe77dd02b71b" alt="statecontroller" width="700" height="277">

The <b>State</b> class is Flutter’s main player in State Management.
However, the <b>StateX</b> class then extends those capabilities to a separate controller class called, <b>StateXController</b>.
This arrangement encourages a clean architecture separating all the mutable properties and business logic 
from the State object and its interface as well as provide state management from <b><i>outside</i></b> the State class itself! 
Not only can the controller class call the State object's <b>setState</b>() function, 
it has access to the object itself, its extended functions, and its many properties (e.g. <b>widget</b>, <b>mounted</b>, <b>context</b>, etc.).

## Documentation
<ul>
   <li id="started"><a href="https://pub.dev/documentation/state_extended/latest/topics/Get%20started-topic.html">Get&nbsp;started</a></li>
   <li id="statex"><a href="https://pub.dev/documentation/state_extended/latest/topics/StateX%20class-topic.html">StateX class</a></li>
   <li id="controller"><a href="https://pub.dev/documentation/state_extended/latest/topics/State%20Object%20Controller-topic.html">State&nbsp;Object&nbsp;Controller</a></li>
   <li id="event"><a href="https://pub.dev/documentation/state_extended/latest/topics/Event%20handling-topic.html">Event handling</a></li>
   <li id="appstate"><a href="https://pub.dev/documentation/state_extended/latest/topics/AppStateX%20class-topic.html">AppStateX class</a></li>
   <li id="error"><a href="https://pub.dev/documentation/state_extended/latest/topics/Error%20handling-topic.html">Error Handling</a></li>
   <li id="testing"><a href="https://pub.dev/documentation/state_extended/latest/topics/Testing-topic.html">Testing</a></li>
</ul> 

## Example Code
Copy and paste the 'Counter Example App' below to see a quick and simple implementation.
Further examples accompany the this package when you download it: 
[example app](https://github.com/AndriousSolutions/state_extended/tree/master/example)

```dart
//
import 'package:flutter/material.dart';

import 'package:state_extended/state_extended.dart';

void main() => runApp(const MyApp(key: Key('MyApp')));

/// README.md example app
class MyApp extends StatefulWidget {
  ///
  const MyApp({super.key, this.title = 'StateX Demo App'});

  /// Title of the screen
  // Fields in a StatefulWidget should always be "final".
  final String title;

  /// This is the App's State object
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends AppStateX<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();
  _MyAppState._() : super(controller: AppController()) {
    /// Acquire a reference to the passed Controller.
    con = controller as AppController;
  }
  static _MyAppState? _this;

  late AppController con;

  /// Place a breakpoint here to see what's going on 'under the hood.'
  @override
  Widget build(BuildContext context) => super.build(context);

  /// Define the 'look and fell' of the overall app.
  /// The body: property takes in a separate widget for the 'home' page.
  @override
  Widget buildIn(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(title: widget.title),
  );
}

/// The Home page
class MyHomePage extends StatefulWidget {
  ///
  const MyHomePage({super.key, this.title});

  /// Title of the screen
  // Fields in a StatefulWidget should always be "final".
  final String? title;

  @override
  State createState() => _MyHomePageState();
}

/// This is a subclass of the State class.
/// This subclass is linked to the App's lifecycle using [WidgetsBindingObserver]
class _MyHomePageState extends StateX<MyHomePage> {
  /// Let the 'business logic' run in a Controller
  _MyHomePageState() : super(controller: HomeController(), useInherited: true) {
    con = controller as HomeController;
  }
  late HomeController con;
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

  /// Place a breakpoint here to see what's going on 'under the hood.'
  @override
  Widget build(BuildContext context) => super.build(context);

  /// Place a breakpoint here to see what's going on 'under the hood.'
  @override
  Widget buildF(BuildContext context) => super.buildF(context);

  @override
  Widget buildIn(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title ?? ''),
      // popup menu button
      actions: [con.popupMenuButton],
    ),
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
          /// ONLY THIS WIDGET is updated with every press of the button.
          const CounterWidget(),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      key: const Key('+'),
      // rebuilds only the Text widget containing the counter.
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

class _CounterState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    /// Making this widget dependent will cause the build() function below
    /// to run again if and when the App's InheritedWidget calls its notifyClients() function.
    final con = HomeController();
    con.dependOnInheritedWidget(context);
    return Text(
      con.data,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

/// Everything a State object can do, this Controller can do as well!
class HomeController extends StateXController {
  /// Utilizing the Singleton pattern is a good programming practice
  factory HomeController() => _this ??= HomeController._();
  // This constructor is hidden with the underscore.
  HomeController._()
      : _model = Model(),
        _letters = AlphabetLetters(),
        _primes = PrimeNumbers();
  static HomeController? _this;

  final Model _model;
  final AlphabetLetters _letters;
  final PrimeNumbers _primes;

  /// Note, each count comes from a separate class.
  String get data {
    String data;
    switch (_countType) {
      case CountType.prime:
        data = _primes.primeNumber.toString();
        break;
      case CountType.alphabet:
        data = _letters.current;
        break;
      default:
        data = _model.integer.toString();
    }
    return data;
  }

  CountType _countType = CountType.integer;

  /// The Controller deals with the event handling and business logic.
  void onPressed() {
    switch (_countType) {
      case CountType.prime:
        _primes.next();
        break;
      case CountType.alphabet:
        _letters.read();
        break;
      default:
        _model.incrementCounter();
    }
    //
    notifyClients();
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in initAsync() routine above.
  @override
  bool onAsyncError(FlutterErrorDetails details) => false;

  /// Provide a menu to this simple app.
  PopupMenuButton get popupMenuButton => PopupMenuButton<CountType>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: CountType.integer,
        child: Row(
          children: [
            if (_countType == CountType.integer)
              const Icon(Icons.star_rounded, color: Colors.black),
            const Text("Integers")
          ],
        ),
      ),
      PopupMenuItem(
        value: CountType.alphabet,
        child: Row(
          children: [
            if (_countType == CountType.alphabet)
              const Icon(Icons.star_rounded, color: Colors.black),
            const Text("Alphabet")
          ],
        ),
      ),
      PopupMenuItem(
        value: CountType.prime,
        child: Row(
          children: [
            if (_countType == CountType.prime)
              const Icon(Icons.star_rounded, color: Colors.black),
            const Text("Prime Numbers")
          ],
        ),
      ),
    ],
    onSelected: (value) {
      switch (value) {
        case CountType.prime:
          _countType = value;
          break;
        case CountType.alphabet:
          _countType = value;
          break;
        default:
        // In case the enumeration class was unknowingly changed
        // Default to integer
          _countType = CountType.integer;
      }
      // 'Refresh' the home screen to show the new count option
      setState(() {});
//      var state = this.state; // The controller's current State object
      // If you're not confident its the intended State class. Retrieve it.
//      state = stateOf<MyHomePage>();
//      state = ofState<_MyHomePageState>();
//      state?.setState(() {});
    },
    offset: const Offset(0, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 14,
  );

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
    //ignore: unused_local_variable
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
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: deactivate in HomeController');
    }
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    super.activate();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: activate in HomeController');
    }
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: dispose in HomeController');
    }
    super.dispose();
  }

  /// Called when the corresponding [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// The framework always calls build() after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
    super.didUpdateWidget(oldWidget);
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didUpdateWidget in HomeController');
    }
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeDependencies in HomeController');
    }
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    super.reassemble();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: reassemble in HomeController');
    }
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
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPopRoute in HomeController');
    }
    return super.didPopRoute();
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  /// This method exposes the `pushRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  @override
  Future<bool> didPushRoute(String route) async {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPushRoute in HomeController');
    }
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
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didPushRouteInformation in HomeController');
    }
    return super.didPushRouteInformation(routeInformation);
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeMetrics in HomeController');
    }
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeTextScaleFactor in HomeController');
    }
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangePlatformBrightness in HomeController');
    }
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeLocales in HomeController');
    }
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
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didChangeAppLifecycleState in HomeController');
    }
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
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: inactiveLifecycleState in HomeController');
    }
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    super.pausedLifecycleState();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: pausedLifecycleState in HomeController');
    }
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {
    super.detachedLifecycleState();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: detachedLifecycleState in HomeController');
    }
  }

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {
    super.resumedLifecycleState();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: resumedLifecycleState in HomeController');
    }
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: didHaveMemoryPressure in HomeController');
    }
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    if (inDebugMode) {
      //ignore: avoid_print
      print(
          '############ Event: didChangeAccessibilityFeatures in HomeController');
    }
  }
}

// The means 'to talk' between the Controller and the Model
enum CountType { integer, prime, alphabet }

/// A separate class that contains the data.
class Model {
  int _integer = 0;
  // The external property transferring the value to the outside world.
  int get integer => _integer;

  /// The business logic involves incrementing something.
  void incrementCounter() => ++_integer;
}

/// Goes through the alphabet.
class AlphabetLetters {
  // Used for incrementing the alphabet
  int start = "a".codeUnitAt(0);
  int end = "z".codeUnitAt(0);

  late int letter = start;

  // The external property transferring the value to the outside world.
  String get current => String.fromCharCode(letter);

  /// The business logic involves incrementing something.
  void read() {
    letter++;
    if (letter > end) {
      letter = start;
    }
  }
}

/// Another class. A complete different type of data conceived.
class PrimeNumbers {
  PrimeNumbers({int? start, int? end}) {
    start = start ?? 1;
    end = end ?? 1000;
    if (start < 0) {
      start = 1;
    }
    if (end <= start) {
      end = 1000;
    }
    initPrimeNumbers(start, end);
  }
  final List<int> _numbers = [];

  int _cnt = 0;

  int get primeNumber => _numbers[_cnt];

  void next() {
    _cnt++;
    if (_cnt > _numbers.length) {
      _cnt = 0;
    }
  }

  void initPrimeNumbers(int M, int N) {
    a:
    for (var k = M; k <= N; ++k) {
      for (var i = 2; i <= k / i; ++i) {
        if (k % i == 0) {
          continue a;
        }
      }
      _numbers.add(k);
    }
  }
}

/// Everything a State object can do, this Controller can do as well!
class AppController extends StateXController {
  factory AppController() => _this ??= AppController._();
  AppController._();

  static AppController? _this;

  /// Used for long asynchronous operations that need to be done
  /// before the app can be fully available to the user.
  /// e.g. Opening Databases, accessing Web servers, etc.
  @override
  Future<bool> initAsync() async {
    // Simply wait for 10 seconds at startup.
    /// In production, this is where databases are accessed, web services opened, login attempts, etc.
    return Future.delayed(const Duration(seconds: 10), () {
      return true;
    });
  }
}
```