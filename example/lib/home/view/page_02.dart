// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

///
class Page2 extends StatefulWidget {
  ///
  const Page2({super.key});

  @override
  State<StatefulWidget> createState() => Page2State();
}

///
class Page2State extends StateX<Page2> with EventsStateMixin {
  /// Define an InheritedWidget to be inserted above this Widget on the Widget tree.
  /// showBinding: Print in console when Binding events are triggered.
  Page2State() : super(controller: Controller(), printEvents: true) {
    /// Cast to type, Controller
    con = controller as Controller;
  }

  /// The controller reference property
  late Controller con;

  /// This function is not really necessary for th app to work
  /// Merely demonstrating the package's many capabilities to you.
  @override
  void initState() {
    //
    super.initState();

    /// Even the app's 'first' StateX object
    final firstStateX = controller?.appStateX;

    assert(firstStateX is StateX, 'Should be a StateX object.');

    assert(firstStateX is AppStateX, 'Should be a AppStateX object.');

    /// Retrieve the first State object
    final firstState = controller?.state?.firstState;

    assert(firstState is State, 'Should be a State object.');

    /// Retrieve the latest, most recent State object.
    final lastState = controller?.state?.lastState;

    assert(lastState is Page2State, 'Should be this State object');

    /// The latest BuildContext in the app.
    /// Note, this State object's own context is not yet defined in initState()
    /// This is so important, there's a number of ways to get it.
    // ignore: unused_local_variable
    BuildContext? lastContext = controller?.state?.lastState?.context;
    lastContext = controller?.appStateX?.lastState?.context;
    lastContext = controller?.lastContext;

    /// The app's data object
    // ignore: unused_local_variable
    final Object? dataObject = controller?.dataObject;

    /// Is the app is running in IDE or in production
    // ignore: unused_local_variable
    final bool? debugMode = controller?.inDebugMode;

    // its current state object
    var state = con.state;

    // by its StatefulWidget
    state = con.stateOf<Page1>();

    // by its type
    state = con.ofState<Page1State>();

    // Look what you have access to 'outside' the build() function.
    // ignore: unused_local_variable
    final mounted = state?.mounted;

    // ignore: unused_local_variable
    final widget = state?.widget;

    // ignore: unused_local_variable
    final context = state?.context;

    // Retrieve the app's own controller.
    final appCon = ExampleAppController();

    final rootState = appCon.state;

    // All three share the same State object.
    assert(rootState is AppStateX, "Should be the 'root' state object.");
  }

  @override
  Widget build(BuildContext context) => MultiTabsScaffold(
        key: GlobalObjectKey<Page2State>(this),
        controller: con,
        tabs: [
          (_) => Scaffold(
                appBar: AppBar(
                  title: const Text('Three-page example'),
                ),
                persistentFooterButtons: [
                  ElevatedButton(
                    key: const Key('Page 1 Counter'),
                    style: flatButtonStyle,
                    onPressed: () {
                      final con = controller!;
                      // Retrieve specific State object (thus it can't be private)
                      Page1State state = con.ofState<Page1State>()!;
                      // Retrieve State object by its StatefulWidget (will have to cast)
                      state = con.stateOf<Page1>() as Page1State;
                      state.count++;
                      state.setState(() {});
                      state.notifyClients();
                    },
                    child: const Text('Page 1 Counter'),
                  ),
                ],
                floatingActionButton: FloatingActionButton(
                  key: const Key('+'),
                  onPressed: con.onPressed,
                  child: const Icon(Icons.add),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text("You're on page:"),
                    ),
                    const Flexible(
                      child: Text(
                        '2',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    const Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'You have pushed the button this many times:',
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${con.data}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Page button for Page 1
                          Flexible(
                            child: ElevatedButton(
                              key: const Key('Page 1'),
                              style: flatButtonStyle,
                              onPressed: () {
                                LogController.log("=========== onPressed('Page 1') in $eventStateClassName");
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Page 1',
                              ),
                            ),
                          ),

                          /// Page button for Page 3
                          Flexible(
                            child: ElevatedButton(
                              key: const Key('Page 3'),
                              style: flatButtonStyle,
                              onPressed: () async {
                                //
                                LogController.log("=========== onPressed('Page 3') in $eventStateClassName");
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const Page3()));

                                /// A good habit to get into. Refresh the screen again.
                                /// In this case, to show the count may have changed.
                                setState(() {});
                              },
                              child: const Text(
                                'Page 3',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child:
                                Text('Count is saved in a memory variable.')),
                      ],
                    ),
                  ],
                ),
              ),
              (_) => LogPage(key: UniqueKey()),
        ],
        labels: const {
          'Page 2': Icon(Icons.looks_two_outlined),
          'Logging': Icon(Icons.login_sharp),
        },
      );

  /// Supply a public method to be accessed in Page 3.
  /// Calling another State object's function for demonstration purposes
  void onPressed() {
    LogController.log("=========== onPressed('Page 1 Counter') in $eventStateClassName");
    final con = controller!;

    /// Retrieve specific State object (thus it can't be private)
    Page1State state = con.ofState<Page1State>()!;

    /// Retrieve State object by its StatefulWidget (will have to cast)
    state = con.stateOf<Page1>() as Page1State;
    state.count++;
    state.setState(() {});
  }
}

///
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);