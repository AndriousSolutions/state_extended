// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The Home page
class HomePage extends StatefulWidget {
  /// With a constant constructor, instantiated once.
  const HomePage({Key? key, this.title = 'Flutter Demo'}) : super(key: key);

  /// Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateX<HomePage> {
  /// Let the 'business logic' run in a Controller
  _HomePageState() : super(Controller()) {
    /// Acquire a reference to the passed Controller.
    con = controller as Controller;
  }

  late Controller con;

  @override
  void initState() {
    /// Look inside the parent function and see it calls
    /// all it's Controllers if any.
    super.initState();

    var con = controller;

    con = controllerByType<Controller>();

    con = controllerById(con?.identifier);

    /// Retrieve the 'app level' State object
    appState = rootState!;

    /// You're able to retrieve the Controller(s) from other State objects.
    con = appState.controller;

    con = appState.controllerByType<Controller>();

    con = appState.controllerById(con?.identifier);

    /// You're able to retrieve the 'past' Controller(s)
    con = controllerByType<AppController>();

    con = appState.controllerByType<AppController>();
  }

  late AppStateX appState;

  /// Build the 'child' Widget passed to the InheritedWidget.
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        /// SetState class is like a setState() function but called
        /// only when the App's InheritedWidget is rebuilt.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Display the App's data object if it has something to display
            SetState(
              builder: (context, dataObject) => Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  dataObject is! String ? '' : dataObject,
                  key: const Key('greetings'),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium!.fontSize,
                  ),
                ),
              ),
            ),
            Text(
              'You have pushed the button this many times:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // A Text widget to display the counter is in here.
            CounterWidget(controller: con),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('+'),

        /// Refresh only the Text widget containing the counter.
        onPressed: con.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Demonstrating the InheritedWidget's ability to spontaneously rebuild
/// its dependent widgets.
class CounterWidget extends StatefulWidget {
  /// Pass along the State Object Controller to make this widget
  /// dependent on the App's InheritedWidget.
  const CounterWidget({super.key, this.controller});

  /// Making this widget dependent will cause the build() function below
  /// to run again if and when the App's InheritedWidget calls its notifyClients() funciton.
  final Controller? controller;

  @override
  State<StatefulWidget> createState() => _CounterState();
}

class _CounterState extends State<CounterWidget> {
  @override
  void initState() {
    super.initState();
    con = widget.controller;
  }

  Controller? con;

  @override
  Widget build(BuildContext context) {
    // Set a dependency to this widget
    con?.dependOnInheritedWidget(context);
    return Text(
      '${con?.count ?? 0}',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
