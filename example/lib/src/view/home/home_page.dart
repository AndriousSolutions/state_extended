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
  Widget buildWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          /// SetState class is like a setState() function but called only when the App's InheritedWidget is rebuilt.
          child: SetState(
            builder: (context, dataObject) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Display the App's data object if it has something to display
                /// Note, the Stat Controllers has access to the same 'dataObject'
                if (dataObject != null &&
                    dataObject == con.dataObject &&
                    con.dataObject is String)
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      dataObject as String,
                      key: const Key('greetings'),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            Theme.of(context).textTheme.headline4!.fontSize,
                      ),
                    ),
                  ),
                Text(
                  'You have pushed the button this many times:',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  '${con.count}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('+'),

          /// Refresh only the Text widget containing the counter.
          onPressed: () => con.incrementCounter(),

          /// You can have the Controller called the interface (the View).
//          onPressed: con.onPressed,
          child: const Icon(Icons.add),
        ),
      );

  /// Supply an error handler for Unit Testing.
  @override
  void onError(FlutterErrorDetails details) {
    /// Error is now handled.
    super.onError(details);
  }
}
