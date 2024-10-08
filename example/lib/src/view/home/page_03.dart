// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/another_app/view.dart' as i;

import '/src/controller.dart';

import '/src/view.dart';

/// The third page displayed in this app.
class Page3 extends StatefulWidget {
  /// You can instantiate the State Controller in the StatefulWidget;
  const Page3({super.key});

  @override
  State createState() => _Page3State();
}

class _Page3State extends StateX<Page3> with EventsStateMixin<Page3> {
  // Use built-in InheritedWidget
  _Page3State() : super(useInherited: true);
  //
  int count = 0;

  // Place a breakpoint here from your favorite IDE and see how it works.
  @override
  //ignore: unnecessary_overrides
  Widget build(BuildContext context) => super.build(context);

  // Place a breakpoint here from your favorite IDE and see how it works.
  @override
  //ignore: unnecessary_overrides
  Widget buildF(BuildContext context) => super.buildF(context);

  /// You could use the builder() function here instead
  /// It'll behave has the build() function
  @override
  Widget builder(BuildContext context) {
    // Comment out this line, and the counter is suddenly not working
    // state() is a widget that depends on the State InheritedWidget
    // it will rebuild but only if the InheritedWidget is called again by notifyClients()
    return stateSet(_builder);
    // That's because _build() is never called again by the InheritedWidget.
    return _builder(context);
  }

  Widget _builder(BuildContext context) => _buildPage3(
        count: count,
        newKey: () {
          // Both do the same thing!
          firstState?.setState(() {});
          rootState?.setState(() {});
        },
        counter: () {
          count++;
          notifyClients();
        },
        page1counter: () {
          // Merely instantiating the StatefulWidget to call its function.
          var state = Controller().ofState<Page2State>()!;
          state = Controller().stateOf<Page2>()! as Page2State;
          state.onPressed();
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
                key: const Key('InheritedWidget example'),
                onPressed: () async {
                  await Navigator.push(
                    lastState!.context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => const i.HomePage()),
                  );
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
