// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  The Controller for this app's Home Page StatefulWidget.
///

import '/src/controller.dart';

import '/src/view.dart';

///
class HomeController extends StateXController
    with EventsControllerMixin, TabsScaffoldController {
  /// It's practical at times to make Controllers using the Singleton pattern
  factory HomeController() => _this ??= HomeController._();

  HomeController._() : super();
  static HomeController? _this;

  /// Called when it's [StateX] object is itself disposed of.
  @override
  void dispose() {
    // Good practice to nullify static instance reference.
    // Flutter's garbage collection does its best, but why not if no longer used
    _this = null;
    super.dispose();
  }

  /// The List of Widgets
  List<Widget> get children => _imageList();

  List<Widget> _imageList() {
    // Default number is assigned if one is not provided.
    final List<Widget> images = [];
    final animals = [1, 2, 3, 4];

    int cnt = 0;
    int dog = 0;
    int cat = 0;
    int fox = 0;
    int bird = 0;

    const number = 12;
    const limit = 3;

    while (cnt < number) {
      // Shuffle the elements
      animals.shuffle();
      switch (animals[0]) {
        case 1:
          if (dog == limit) {
            // try again.
            continue;
          } else {
            dog++;
            images.add(const RandomDog());
          }
          break;
        case 2:
          if (cat == limit) {
            // try again.
            continue;
          } else {
            cat++;
            images.add(const RandomCat());
          }
          break;
        case 3:
          if (fox == limit) {
            // try again.
            continue;
          } else {
            fox++;
            images.add(const RandomFox());
          }
          break;
        case 4:
          if (bird == limit) {
            // try again.
            continue;
          } else {
            bird++;
            images.add(const RandomBird());
          }
          break;
      }
      cnt++;
    }
    return images;
  }

  ///
  void newBirds() => BirdController().newAnimals();

  ///
  void newCats() => CatController().newAnimals();

  ///
  void newDogs() => DogController().newAnimals();

  ///
  void newFoxes() => FoxController().newAnimals();
}
