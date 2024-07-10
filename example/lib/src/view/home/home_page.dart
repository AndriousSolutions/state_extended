// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

/// The Home page
class HomePage extends StatefulWidget {
  /// With a constant constructor, instantiated once.
  const HomePage({super.key, this.title = 'Hello! example'});

  /// Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateX<HomePage> with EventsStateMixin<HomePage> {
  /// Let the 'business logic' run in a Controller
  _HomePageState() : super(controller: Controller()) {
    /// Acquire a reference to the passed Controller.
    con = controller as Controller;
    timer = CounterTimer();
    add(timer);
  }

  late Controller con;
  late CounterTimer timer;

  @override
  void initState() {
    /// Look inside the parent function and see it calls
    /// all it's Controllers if any.
    super.initState();
  }

  /// The State class' interface
  @override
  Widget builder(BuildContext context) {
    //
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            timer.counter,

            /// SetState class is like a setState() function but called
            /// only when the App's InheritedWidget is called again.
            SetState(
              builder: (context, dataObject) => Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  /// Display the App's data object if it has something to display
                  dataObject is! String ? '' : dataObject,
                  key: const Key('greetings'),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: textTheme.headlineMedium?.fontSize,
                  ),
                ),
              ),
            ),
            Text(
              'You have pushed the button this many times:',
              style: textTheme.bodyLarge,
            ),
            // The count is here.
            Text(
              '${con.data}',
              style: textTheme.headlineMedium,
            ),
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
