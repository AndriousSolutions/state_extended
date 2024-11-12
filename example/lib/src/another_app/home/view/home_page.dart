// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  The StatefulWidget representing the app's Home Page.
///

import '/src/another_app/controller_another_app.dart';

import '/src/another_app/view_another_app.dart';

/// The Home page
class HomePage extends StatefulWidget {
  ///
  const HomePage({Key? key, this.title}) : super(key: key);

  ///
  final String? title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateX<HomePage> {
  _HomePageState() : super(controller: HomeController()) {
    con = controller as HomeController;
  }
  late HomeController con;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'Inherited State Object Demo.'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: InheritBird(
          child: InheritCat(
            child: InheritDog(
              child: InheritFox(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: con.children,
                ),
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          OverflowBar(
            // spacing: 5,
            // overflowAlignment: OverflowBarAlignment.center,
            children: [
              TextButton(
                key: const Key('New Dogs'),
                onPressed: () => con.newDogs(),
                child: const Text('New Dogs'),
              ),
              TextButton(
                key: const Key('New Cats'),
                onPressed: () => con.newCats(),
                child: const Text('New Cats'),
              ),
              TextButton(
                key: const Key('New Foxes'),
                onPressed: () => con.newFoxes(),
                child: const Text('New Foxes'),
              ),
              TextButton(
                key: const Key('New Birds'),
                onPressed: () => con.newBirds(),
                child: const Text('New Birds'),
              ),
            ],
          ),
        ],
      );
}
