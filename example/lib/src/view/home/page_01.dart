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
  Page1State() : super(Controller());

  /// The Controller used
  late Controller con;

  /// The counter
  int count = 0;

  /// Ignore class, BuildPage
  /// BuildPage is just a 'generic' widget I made for each page to highlight
  /// the parameters it takes in for demonstration purposes.
  @override
  Widget build(context) => BuildPage(
        label: '1',
        count: count,
        counter: () {
          count++;
          // Commented out since the controller has access to this State object.
//          setState(() {});
          // Look how this Controller has access to this State object!
          // The incremented counter will not update otherwise! Powerful!
          // Comment out and the counter will appear not to work.
          controller?.setState(() {});
        },
        row: (BuildContext context) => [
          const SizedBox(),
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 2'),
              onPressed: () {
                Navigator.push(
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
