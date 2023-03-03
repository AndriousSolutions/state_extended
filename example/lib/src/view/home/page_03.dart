// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/another_app/view.dart' as i;

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';
import 'package:flutter/foundation.dart';

/// The third page displayed in this app.
class Page3 extends StatefulWidget {
  /// You can instantiate the State Controller in the StatefulWidget;
  const Page3({super.key});

  @override
  State createState() => _Page3State();
}

class _Page3State extends StateX<Page3> {
  @override
  void initState() {
    super.initState();
    // Demonstrates the ability to process all the StateX objects
    // currently available in the app.
    forEachState((state) {
      if (kDebugMode) {
        print(state.hasError);
        print(state.errorMsg);
        print(state.stackTrace?.toString() ?? '');
      }
    });
  }

  //
  int count = 0;

  @override
  Widget build(BuildContext context) => _buildPage3(
        count: count,
        newKey: () {
          startState?.setState(() {});
        },
        counter: () => setState(() => count++),
        page1counter: () {
          // Merely instantiating the StatefulWidget to call its function.
          final state = Controller().ofState<Page2State>()!;
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
                key: const Key('Hello! example'),
                onPressed: () {
                  Navigator.push(
                      endState!.context,
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
