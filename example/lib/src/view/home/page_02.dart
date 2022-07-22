// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The second page displayed in this app.
class Page2 extends StatefulWidget {
  ///
  Page2({Key? key, this.tripError})
      : con = Controller(),
        super(key: key);

  ///
  final Controller con;

  ///
  final bool? tripError;

  @override
  State createState() => _Page2State();

  /// Public API for increment a 'Page 2' counter.
  void onPressed() {
    //
    var state = con.state;

    state = con.stateOf<Page2>();

    state = con.ofState<_Page2State>();

    con.onPressed();

    /// Comment out this line and be surprised it still works!!
    state?.setState(() {});

    // by its StatefulWidget
    var outsideState = con.stateOf<Page1>();

    // by its type
    outsideState = con.ofState<Page1State>();
  }
}

/// This works with a separate 'data source'
/// It doesn't no what data source, but being so, the count is never reset to zero.
class _Page2State extends InheritedStateX<Page2, _Page02Inherited> {
  /// Define an InheritedWidget to be inserted above this Widget on the Widget tree.
  _Page2State()
      : super(inheritedBuilder: (child) => _Page02Inherited(child: child));

  @override
  void initState() {
    /// Make this the 'current' State object for the Controller.
    add(widget.con);

    con = controller as Controller;

    /// Event the 'first' State object has a reference to itself
    AppStateX? firstState = con.rootState;

    /// The latest BuildContext in the app.
    BuildContext? lastContext = con.lastContext;

    /// The app's data object
    Object? dataObject = con.dataObject;

    /// Is the app is running in IDE or in production
    bool debugging = con.inDebugger;

    /// Allow for con.initState() function to fire.
    super.initState();
  }

  //
  late Controller con;

  /// Define the 'child' Widget that will be passed to the InheritedWidget above.
  @override
  Widget buildChild(BuildContext context) {
    //
    final tripError = widget.tripError ?? false;

    if (tripError) {
      throw AssertionError('Pretend a error occurs here in this function.');
    }

    // /// Comment this command out and the counter will not work.
    // /// That's because this Widget is then no longer a dependency to the InheritedWidget above.
    dependOnInheritedWidget(context);

    /// Ignore BuildPage(). It's used only to highlight the other features in this page
    return BuildPage(
      label: '2',
      count: con.count,
      counter: widget.onPressed,
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
              await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => Page3()));

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
        const Text("Has a 'data source' to save the count"),
      ],
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          key: const Key('Page 1 Counter'),
          style: flatButtonStyle,
          onPressed: () {
            final state = con.ofState<Page1State>()!;
            state.count++;
            state.setState(() {});
          },
          child: const Text('Page 1 Counter'),
        ),
      ],
    );
  }
}

/// The inserted InheritedWidget that takes in the buildChild() Widget above.
class _Page02Inherited extends InheritedWidget {
  const _Page02Inherited({Key? key, required Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(oldWidget) => true;
}
