// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The first page displayed in this app.
class Page1 extends StatefulWidget {
  /// Page 1
  const Page1({super.key});

  @override
  State createState() => Page1State();
}

///
class Page1State extends StateX<Page1> {
  /// Supply a controller to this State object
  /// so to call its setState() function below.
  Page1State() : super(controller: Controller());

  /// The counter
  int count = 0;

  /// This function is not really necessary for th app to work
  /// Merely demonstrating the package's many capabilities to you.
  @override
  void initState() {
    //
    super.initState();

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
  }

  /// Ignore class, BuildPage
  /// BuildPage is just a 'generic' widget I made for each page to highlight
  /// the parameters it takes in for demonstration purposes.
  @override
  Widget build(context) => BuildPage(
        label: '1',
        count: count,
        counter: () {
          count++;

          /// Commented out since the controller has access to this State object.
//          setState(() {});
          /// Look how this Controller has access to this State object!
          /// The incremented counter will not update otherwise! Powerful!
          /// Comment out and the counter will appear not to work.
          controller?.setState(() {});
        },
        row: (BuildContext context) => [
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
      );
}
