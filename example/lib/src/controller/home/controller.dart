// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

/// EventsControllerMixin puts print() in every event method
class Controller extends StateXController with EventsControllerMixin {
  /// It's a good practice and follow the Singleton pattern.
  /// There's on need for more than one instance of this particular class.
  factory Controller([StateX? state]) => _this ??= Controller._(state);
  Controller._(StateX? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  int get data => _model.counter;

  /// The flag indicating if an InheritedWidget is to used.
  bool useInherited = false;

  /// Page1 count is saved periodically
  int page1Count = 0;

  /// The API matches the name of the Widget's named parameter
  /// Increment and then call the State object's setState() function to reflect the change.
  void onPressed() => incrementCounter();

  /// The Controller knows how to 'talk to' the Model and to the interface.
  void incrementCounter() {
    //
    _model.incrementCounter();

    // Rebuild the interface to display any changes.
    // Every setState() listed below performs the same thing.

    // Every StateXController has a setState() function.
    setState(() {});
    // Every StateXController references its 'current' State object
    state?.setState(() {});

    // Retrieve the StateX object of type Page2State. Null if not found.
    final page2State = ofState<Page2State>();
    page2State?.setState(() {});
    // Retrieve the StateX object for StatefulWidget, Page2. Null if not found.
    final stateX = stateOf<Page2>();
    stateX?.setState(() {});

    // Retrieves the controller's 'latest' State object. Null if no State objects.
    lastState?.setState(() {});

    /// If count is divisible by 5
    if (_model.counter % 5 == 0) {
      // Assigning a value will cause 'rootState?.notifyClients()'
      // Update the interface with the latest change.
      dataObject = _model.sayHello();
    }
  }
}
