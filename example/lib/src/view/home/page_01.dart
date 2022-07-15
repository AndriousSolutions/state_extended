// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

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
    //
    var state = con.ofState<Page1State>()!;
    state = con.state as Page1State;

    state.setState(() {
      state.count++;
    });
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

    /// Allow the con.initState() to be called.
    super.initState();
  }

  /// The Controller used
  late Controller con;

  /// The counter
  int count = 0;

  /// Responsible for the incrementation
  void onPressed() {
    count++;
    setState(() {});
  }

  @override
  Widget build(context) {
    // Takes this state object as a dependency to an InheritedWidget.
    // Link this widget to the InheritedWidget
    // Only useful if buildInherited() is used instead of setState().
    dependOnInheritedWidget(context);
    return buildPage1(
      count: count,
      counter: onPressed,
    );
  }

  /// Page 1
  Widget buildPage1({
    int count = 0,
    required void Function() counter,
  }) =>
      BuildPage(
        label: '1',
        count: count,
        counter: counter,
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
