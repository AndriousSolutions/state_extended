// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The second page displayed in this app.
class Page2 extends StatefulWidget {
  ///
  const Page2({super.key});

  @override
  State createState() => Page2State();
}

/// This works with a separate 'data source'
/// It a separate data source, and so the count is never reset to zero.
class Page2State extends StateX<Page2> {
  /// Define an InheritedWidget to be inserted above this Widget on the Widget tree.
  Page2State() : super(controller: Controller()) {
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

    /// Even the app's 'first' State object has a reference to itself
    final firstState = controller?.rootState;

    assert(firstState is AppStateX, "Should be the 'root' state object.");

    /// The latest BuildContext in the app.
    /// This is so important, there's a number of ways to get it.
    // ignore: unused_local_variable
    BuildContext? lastContext = controller?.state?.endState?.context;
    lastContext = controller?.rootState?.endState?.context;
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

  /// Define the 'child' Widget that will be called by the built-in FutureBuilder.
  /// Ignore BuildPage(). It's used only to highlight the other features in this page
  @override
  Widget buildF(BuildContext context) => BuildPage(
        label: '2',
        count: con.count,
        counter: con.onPressed,
        row: (context) => [
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 1'),
              style: flatButtonStyle,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Page 1',
              ),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 3'),
              style: flatButtonStyle,
              onPressed: () async {
                //
                await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Page3()));

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
        column: (context) => [
          const Flexible(child: Text("Has a 'data source' to save the count")),
        ],
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            key: const Key('Page 1 Counter'),
            style: flatButtonStyle,
            onPressed: onPressed,
            child: const Text('Page 1 Counter'),
          ),
        ],
      );

  /// Supply a public method to be accessed in Page 3.
  /// Calling another State object's function for demonstration purposes
  void onPressed() {
    final con = controller!;
    // Retrieve specific State object (thus it can't be private)
    Page1State state = con.ofState<Page1State>()!;
    // Retrieve State object by its StatefulWidget (will have to cast)
    state = con.stateOf<Page1>() as Page1State;
    state.count++;
    state.setState(() {});
  }
}
