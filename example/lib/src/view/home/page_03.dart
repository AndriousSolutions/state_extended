// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/another_app/view.dart' as i;

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The third page displayed in this app.
class Page3 extends StatefulWidget {
  /// You can instantiate the State Controller in the StatefulWidget;
  Page3({super.key});

  /// To the contain a reference to the State object.
  final _stateList = <StateX>[];

  @override
  State createState() => _Page3State();

  /// Note, there is more than one way below to access the State object.
  void onPressed() {
    // Retrieve the State Object
    final state = _stateList.first;

    state.setState(() {
      (state as _Page3State).count++;
    });
  }
}

class _Page3State extends StateX<Page3> {
  _Page3State() : super(Controller());
  //
  @override
  void initState() {
    // Register the controller with the StateX
    widget._stateList.add(this);

    // Allow for con.initState() to be called.
    super.initState();

    // Retrieve a past controller.
    final otherCon = controllerByType<YetAnotherController>();
    final state = otherCon?.state;
    assert(state is AppStateX, "Should be the 'root' state object.");
  }

  int count = 0;

  /// Completely unnecessary because the Controller uses a
  /// factory constructor, but if such a Controller had
  /// separate instances you should add the new controller.
  @override
  void didUpdateWidget(Page3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Remove this state object from the old Widget.
    oldWidget._stateList.clear();

    // Make this the 'current' State object for the Controller.
    widget._stateList.add(this);
  }

  @override
  Widget build(BuildContext context) => _buildPage3(
        count: count,
        newKey: () {
          rootState?.setState(() {});
        },
        counter: widget.onPressed,
        page1counter: () {
          Page1().onPressed();
        },
        page2counter: () {
          Controller().onPressed();
        },
      );

  /// Ignore this function. Study the features above instead.
  Widget _buildPage3({
    int count = 0,
    required void Function() counter,
    required void Function() newKey,
    required void Function() page1counter,
    required void Function() page2counter,
  }) =>
      BuildPage(
        label: '3',
        count: count,
        counter: counter,
        column: (_) => [
          Flexible(
            child: ElevatedButton(
              key: const Key('New Key'),
              onPressed: newKey,
              child: const Text('New Key for Page 1'),
            ),
          ),
          Row(children: [
            const SizedBox(width: 5),
            Flexible(
              child: ElevatedButton(
                key: const Key('Hello! example'),
                onPressed: () {
                  Navigator.push(
                      lastContext!,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const HomePage()));
                },
                child: const Text("'Hello!' example"),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: ElevatedButton(
                key: const Key('InheritedWidget example'),
                onPressed: () {
                  Navigator.push(
                      lastContext!,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const i.HomePage()));
                },
                child: const Text("'InheritedWidget' example"),
              ),
            ),
          ]),
        ],
        row: (BuildContext context) => [
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 1'),
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text('Page 1'),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 2'),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Page 2'),
            ),
          ),
        ],
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            key: const Key('Page 1 Counter'),
            onPressed: page1counter,
            child: const Text('Page 1 Counter'),
          ),
          ElevatedButton(
            key: const Key('Page 2 Counter'),
            onPressed: page2counter,
            child: const Text('Page 2 Counter'),
          ),
        ],
      );
}
