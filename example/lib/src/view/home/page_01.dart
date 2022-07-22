// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The first page displayed in this app.
class Page1 extends StatefulWidget {
  /// Page 1
  Page1({super.key}) : con = Controller();

  /// The Controller used.
  final Controller con;

  @override
  State createState() => Page1State();

  /// The event handler
  void onPressed() {
    // See the number of ways to retrieve a State object.

    // its current state object
    var state = con.state;

    // by its StatefulWidget
    state = con.stateOf<Page1>();

    // by its type
    state = con.ofState<Page1State>();

    state?.setState(() {
      (state as Page1State).count++;
    });

    final mounted = state?.mounted;

    final widget = state?.widget;

    final context = state?.context;
  }
}

///
class Page1State extends StateX<Page1> {
  //
  @override
  void initState() {
    /// Link with the StateX so con.setState(() {}) will work.
    add(widget.con);
    con = controller as Controller;

    final mountedTest = mounted;

    final widgetTest = widget;

    final contextTest = context;

    /// Allow the con.initState() to be called.
    super.initState();
  }

  /// The Controller used
  late Controller con;

  /// The counter
  int count = 0;

  /// BuildPage is just a 'generic' widget I made for each page to highlight
  /// the parameters it taks in for demonstration purposes.
  @override
  Widget build(context) => BuildPage(
        label: '1',
        count: count,
        counter: () {
          count++;
          setState(() {});
          //         setState(()=> count++);  // variation of the same thing.
        },
        row: (BuildContext context) => [
          const SizedBox(),
          ElevatedButton(
            key: const Key('Page 2'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Page2(),
                ),
              );
            },
            child: const Text(
              'Page 2',
            ),
          ),
        ],
      );
}
