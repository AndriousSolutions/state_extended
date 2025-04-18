// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/view.dart';

/// The first page displayed in this app.
class Page1 extends StatefulWidget {
  /// Page 1
  const Page1({super.key});

  @override
  State createState() => Page1State();
}

///
class Page1State extends StateX<Page1> with EventsStateMixin<Page1> {
  /// Supply a controller to this State object
  /// so to call its setState() function below.
  Page1State()
      : super(
          controller: Controller(),
          useInherited: Controller().useInherited,
        ) {
    _con = controller as Controller;
    // Add some additional controllers if you like
    addList([AnotherController(), YetAnotherController(), WordPairsTimer()]);
    _timer = controllerByType<WordPairsTimer>()!;
  }
  late Controller _con;
  late WordPairsTimer _timer;

  /// The counter
  int count = 0;

  /// This function is not really necessary for th app to work
  /// Merely demonstrating the package's many capabilities to you.
  @override
  void initState() {
    //
    super.initState();

    /// Below a demonstration of the properties and functions available to you.

    // Just used to emphasize null can to returned if the controller is not found.
    StateXController? nullableController;

    /// Each StateX object references its current controller by this property.
    nullableController = controller;

    /// Each controller is assigned a unique identifier.
    // identifier is a 35-alphanumeric character string
    var id = nullableController?.identifier;

    /// You're able to retrieve a controller by its identifier.
    // Note, returns null if not found or id == null or empty
    nullableController = controllerById(id);

    /// You're able to retrieve a controller by its Type.
    // Note, returns null if not found.
    nullableController = controllerByType<Controller>();

    /// You're able to retrieve a controller by its Type.
    // Note, returns null if not found.
    var anotherController = controllerByType<AnotherController>();

    /// Each controller is assigned a unique identifier.
    // identifier is a 35-alphanumeric character string
    id = anotherController?.identifier;

    /// You're able to retrieve a controller by its identifier.
    // Note, returns null if not found or id == null or empty
    nullableController = controllerById(id);

    // No need to test 'nullableController is AnotherController'
    // Searching by identifier ensures its of that Type.
    if (nullableController != null) {
      anotherController = nullableController as AnotherController;
    }

    // Since, I'm confident such a controller will be retrieved
    // I can shortened the process like this.
    anotherController = controllerById(id) as AnotherController;

    final AppStateX rootState = this.rootState!;

    /// The controller is was also assigned to the 'first' State object.
    // Note, returns null if not found or id == null or empty
    anotherController = rootState.controllerById(id) as AnotherController;

    /// The controller is was assigned to the 'first' State object.
    // Note, returns null if not found.
    anotherController = rootState.controllerByType<AnotherController>();

    /// InheritedWidget switch will reset count, but the controller can saves the count
    count = _con.page1Count;
    _con.page1Count = 0;
  }

  ///
  @override
  Widget builder(context) => Scaffold(
        appBar: AppBar(
          title: const Text('Three-page example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _timer.wordPair,
            const Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'You have pushed the button this many times:',
                ),
              ),
            ),
            Flexible(
              child: setBuilder(
                // Will build this one lone widget
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
                  const SizedBox(),
                  Flexible(
                    child: ElevatedButton(
                      key: const Key('Page 2'),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const Page2(),
                          ),
                        );
                      },
                      child: const Text(
                        'Page 2',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Use built-in InheritedWidget'),
                CupertinoSwitch(
                  key: const Key('InheritedSwitch'),
                  value: _con.useInherited,
                  onChanged: (v) {
                    // Save the setting
                    _con.useInherited = v;
                    // Save the count
                    _con.page1Count = count;
                    // Both access the 'first' StateX object
                    firstState?.setState(() {});
                    rootState?.setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('+'),
          onPressed: () {
            // Deliberately throw an error to demonstrate error handling.
            throw Exception('Fake error to demonstrate error handling!');

            count++;

            /// Commented out since the controller has access to this State object.
//          setState(() {});
            /// Look how this Controller has access to this State object!
            /// The incremented counter will not update otherwise! Powerful!
            /// Comment out and the counter will appear not to work.
            controller?.setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      );

  @override
  void onError(FlutterErrorDetails details) {
    //
    _timer.onError(details);

    final stack = details.stack;

    // Determine the specific error
    if (stack != null && stack.toString().contains('handleTap')) {
      // Indicate the error has been handled
      rootState?.lastFlutterError(details);
      // Increment the count like no error occurred
      count++;
      // Look how this Controller has access to this State object!
      controller?.setState(() {});
    }

    /// You have the option to implement an error handler to individual controllers
    for (final con in controllerList) {
      // If it has the onError() function
      if (con is StateXonErrorMixin) {
        final c = con as StateXonErrorMixin;
        c.onError(details);
        c.logErrorDetails(details);
      }
    }
  }

  /// Catch it if the initAsync() throws an error
  /// The FutureBuilder will fail, but you can examine the error
  @override
  Future<bool> catchAsyncError(Object error) async {
    final con = Controller();
    if (con.errorCatchAsyncError) {
      con.errorCatchAsyncError = false;
      throw AssertionError('Error in Catch!');
    }
    return false;
  }
}
