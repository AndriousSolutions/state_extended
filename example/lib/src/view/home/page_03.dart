// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

///
class Page3 extends StatefulWidget {
  ///
  const Page3({super.key});

  @override
  State<StatefulWidget> createState() => Page3State();
}

///
class Page3State extends StateX<Page3> with EventsStateMixin<Page3> {
  /// Use built-in InheritedWidget
  Page3State() : super(controller: Controller(), useInherited: true) {
    /// Cast to type, Controller
    con = controller as Controller;
  }

  /// The controller reference property
  late Controller con;
  ///
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
  Widget builder(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Three-page example'),
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
                '3',
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
              child: con.setBuilder(
                (context) => Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ElevatedButton(
                    key: const Key('New Key'),
                    onPressed: () {
                      // Both do the same thing!
                      firstState?.setState(() {});
                      rootState?.setState(() {});
                    },
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
                            builder: (BuildContext context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text("'InheritedWidget' example"),
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('+'),
          onPressed: () {
            count++;
            con.setState((){});
          },
          child: const Icon(Icons.add),
        ),
        persistentFooterButtons: [
          ElevatedButton(
            key: const Key('Page 1 Counter'),
            onPressed: () {
              // Return State object by its type or by its StatefulWidget Type
              // Both returns null if not found.
              var page2State = con.ofState<Page2State>();
              final stateX = con.stateOf<Page2>();

              if(stateX != null && stateX is Page2State){
                // ignore: unnecessary_cast
                page2State = stateX as Page2State;
              }
              // Merely instantiating the StatefulWidget to call its function.
              page2State?.onPressed();
            },
            child: const Text('Page 1 Counter'),
          ),
          ElevatedButton(
            key: const Key('Page 2 Counter'),
            onPressed: () {
              con.onPressed();
            },
            child: const Text('Page 2 Counter'),
          ),
        ],
      );
}
