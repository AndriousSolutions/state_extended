// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

/// The first page displayed in this app.
class Page1 extends StatefulWidget {
  /// Page 1
  Page1({Key? key}) : super(key: key ?? Controller().page1Key);

  @override
  State createState() => Page1State();
}

///
class Page1State extends StateX<Page1> with EventsStateMixin {
  /// Supply a controller to this State object
  /// so to call its setState() function below.
  Page1State()
      : super(
          controller: Controller(),
          useInherited: Controller().useInherited,
        ) {
    _con = controller as Controller;
    // Add some additional controllers if you like
    addAll([AnotherController(), YetAnotherController(), WordPairsTimer()]);
    // Retrieve from this State object a particular Controller.
    _timer = controllerByType<WordPairsTimer>()!;
  }

  late Controller _con;
  late WordPairsTimer _timer;

  /// The counter
  int count = 0;

  /// This function is not really necessary for th app to work
  /// Merely demonstrating the package's many capabilities to you.
  @override
  void initState() {
    //
    super.initState();

    /// Below a demonstration of the properties and functions available to you.

    // Just used to emphasize null can to returned if the controller is not found.
    StateXController? nullableController;

    /// Each StateX object references its current controller by this property.
    nullableController = controller;

    /// Each controller is assigned a unique identifier.
    // identifier is a 35-alphanumeric character string
    var id = nullableController?.identifier;

    /// You're able to retrieve a controller by its identifier.
    // Note, returns null if not found or id == null or empty
    nullableController = controllerById(id);

    /// You're able to retrieve a controller by its Type.
    // Note, returns null if not found.
    nullableController = controllerByType<Controller>();

    /// You're able to retrieve a controller by its Type.
    // Note, returns null if not found.
    var anotherController = controllerByType<AnotherController>();

    /// Each controller is assigned a unique identifier.
    // identifier is a 35-alphanumeric character string
    id = anotherController?.identifier;

    /// You're able to retrieve a controller by its identifier.
    // Note, returns null if not found or id == null or empty
    nullableController = controllerById(id);

    // No need to test 'nullableController is AnotherController'
    // Searching by identifier ensures its of that Type.
    if (nullableController != null) {
      anotherController = nullableController as AnotherController;
    }

    // Since, I'm confident such a controller will be retrieved
    // I can shortened the process like this.
    anotherController = controllerById(id) as AnotherController;

    final AppStateX? appState = appStateX;

    /// The controller is was also assigned to the 'first' State object.
    // Note, returns null if not found or id == null or empty
    anotherController = appState?.controllerById(id) as AnotherController;

    /// The controller is was assigned to the 'first' State object.
    // Note, returns null if not found.
    anotherController = appState?.controllerByType<AnotherController>();

    var sameState = stateByType<AppStateX>();

    sameState = ofState<AppStateX>(); // Merely different syntax

    /// It should be this very State object.
    if (sameState is AppStateX) {
      assert(sameState == appState, "Should be of type 'AppStateX'");
    }

    /// Retrieve the State object by its StatefulWidget
    State? state = controller!.stateOf<MyApp>();

    /// It should be this very State object.
    if (state is AppStateX) {
      assert(state == appState, "Should be of type 'AppStateX'");
    }

    /// Each State object is assigned a unique identifier.
    // identifier is a 35-alphanumeric character string
    id = appState?.identifier;

    state = stateById(id);

    /// It should be this very State object.
    if (state is AppStateX) {
      assert(state == appState, "Should be of type 'AppStateX'");
    }

    state = firstState;

    /// It should be this very State object.
    if (state is AppStateX) {
      assert(state == appState, "Should be of type 'AppStateX'");
    }

    /// The 'latest' StateX object running in the App.
    state = lastState;

    /// It should be this very State object.
    if (state is Page1State) {
      assert(state == this, "Should be of type 'Page1State'");
    }
  }

  ///
  TextStyle? style, textStyle;

  ///
  MediaQueryData? media;

  /// Using your favorite IDE, place a breakpoint in deactivate()
  @override
  Widget build(BuildContext context) => super.build(context);

  ///
  @override
  Widget builder(context) {
    //
    if (style == null) {
      final textTheme = Theme.of(context).textTheme;
      style ??= textTheme.headlineMedium;
      textStyle ??= textTheme.labelSmall;
    }
    media ??= MediaQuery.of(context);
    final inMobile = media!.size.shortestSide < 600;
    final isPortrait = media!.orientation == Orientation.portrait || inMobile;
    //
    return MultiTabsScaffold(
      controllers: [_con, _timer],
      tabs: [
        (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Three-page example'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _timer.wordPair,
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        'You have pushed the button this many times:',
                      ),
                    ),
                  ),
                  Table(children: [
                    TableRow(children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('$count',
                            key: const Key('Text'), style: style),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Text()', style: textStyle),
                      ),
                    ]),
                    if (isPortrait)
                      TableRow(children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: setBuilder((_) {
                            return Text('$count', style: style);
                          }),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('setBuilder()', style: textStyle),
                        ),
                      ]),
                    if (isPortrait)
                      TableRow(children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: _TextStatefulWidget(),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('StatefulWidget()', style: textStyle),
                        ),
                      ]),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(),
                        Flexible(
                          child: ElevatedButton(
                            key: const Key('Page 2'),
                            onPressed: () async {
                              LogController.log(
                                  "=========== onPressed('Page 2') in $eventStateClassName");
                              await Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const Page2(),
                                ),
                              );
                            },
                            child: const Text(
                              'Page 2',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Use built-in InheritedWidget'),
                      CupertinoSwitch(
                        key: const Key('InheritedSwitch'),
                        value: _con.useInherited,
                        onChanged: (v) {
                          _con.onChangedInherited(useInherited: v);
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Use built-in ChangeNotifier'),
                      CupertinoSwitch(
                        key: const Key('ChangeNotifierSwitch'),
                        value: _con.useChangeNotifier,
                        onChanged: (v) {
                          _con.onChangedNotifier(useChangeNotifier: v);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                key: const Key('+'),
                onPressed: () {
                  ///
                  LogController.log(
                      '=========== onPressed() in $eventStateClassName');

                  /// Look at the ways to supply the App's main controller
                  var appController = appCon as ExampleAppController;

                  appController =
                      (firstState as StateX).controller as ExampleAppController;

                  appController = appStateX!.controller as ExampleAppController;

                  if (appController.errorButton) {
                    // Deliberately throw an error to demonstrate error handling.
                    throw AssertionError(
                        'Fake error to demonstrate error handling!');
                  }
                  // The Interface has no idea what happens in here. However, you do.
                  _con.onPressedActionButton();
                },
                child: const Icon(Icons.add),
              ),
            ),
        (_) => const ScrollScreen(
              title: 'Testing',
              child: SettingsPage(),
            ),
        (_) => LogPage(key: UniqueKey()),
        // Recreate State object every time!
      ],
      labels: const {
        'Page 1': Icon(Icons.home),
        'Testing': Icon(Icons.settings),
        'Logging': Icon(Icons.login_sharp),
      },
    );
  }

  @override
  void onError(FlutterErrorDetails details) {
    super.onError(details);
    // recover
    _timer.activate();
  }

  /// Catch it if the initAsync() throws an error
  /// The FutureBuilder will fail, but you can examine the error
  @override
  Future<bool> catchAsyncError(Object error) async {
    //
    final caught =
        error.toString().contains('Error in AnotherController.initAsync()!');
    if (caught) {
      assert(() {
        debugPrint(
            '=========== Caught error in catchAsyncError() for $eventStateClassName');
        return true;
      }());
    }

    final con = appCon as ExampleAppController;
    if (con.errorCatchAsyncError) {
      con.errorCatchAsyncError = false;
      throw Exception('Error in Catch!');
    }

    return caught;
  }

  @override
  // ignore: unnecessary_overrides
  void setState(VoidCallback fn, {bool? log}) => super.setState(fn, log: log);
}

///
class _TextStatefulWidget extends StatefulWidget {
  const _TextStatefulWidget();

  //
  @override
  State<StatefulWidget> createState() => _TextState();
}

class _TextState extends State<_TextStatefulWidget> {
  @override
  void initState() {
    super.initState();
    con = Controller();
  }

  ///
  late Controller con;

  //
  @override
  Widget build(BuildContext context) {
    /// Determine how you're going to 'rebuild' this State object.
    con.buildThisState(this);
    style ??= Theme.of(context).textTheme.headlineMedium;
    return Text('${con.page1Count}', style: style);
  }

  ///
  TextStyle? style;

  @override
  void dispose() {
    style = null;
    super.dispose();
  }
}
