// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

/// EventsControllerMixin puts print() in every event method
class Controller extends StateXController
    with StateXonErrorMixin, EventsControllerMixin, TabsScaffoldController {
  // TwoTabScaffoldController {
  /// It's a good practice and follow the Singleton pattern.
  /// There's on need for more than one instance of this particular class.
  factory Controller([StateX? state]) => _this ??= Controller._(state);
  Controller._(StateX? state)
      : _model = Model(),
        super(state) {
    /// Lets pretend you don't have ready access to the App Controller in some interface screens
    /// but is readily available in the Page 3 controller.
    /// Showing how some logic is hidden from the interface.
    _appCon = ExampleAppController();
  }
  static Controller? _this;

  final Model _model;

  late ExampleAppController _appCon;

  /// Note, the count comes from a separate class, _Model.
  int get data => _model.counter;

  /// A flag indicating if an InheritedWidget is to be used.
  bool get useInherited => _useInherited;
  set useInherited(bool? use) {
    // See how additional logic is hidden from the interface
    // Page1 creates a new key and so a new State object
    page1Key = null;
    _useInherited = use ?? false;
  }

  //
  bool _useInherited = false;

  /// Page1 count is saved periodically
  int page1Count = 0;

  /// Page1 Key
  /// Changing it will recreate its State object.
  Key get page1Key => _appCon.page1Key;
  set page1Key(Key? key) => _appCon.page1Key = key;

  /// The API matches the name of the Widget's named parameter
  /// Increment and then call the State object's setState() function to reflect the change.
  void onPressed() {
    LogController.log(
        "########### onPressed('Page 2 Counter') in $controllerName");
    incrementCounter();
  }

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
    page2State?.setState(() {}, log: false);
    // Retrieve the StateX object for StatefulWidget, Page2. Null if not found.
    final stateX = stateOf<Page2>();
    (stateX as EventsStateMixin?)?.setState(() {}, log: false);

    // Retrieves the controller's 'latest' State object. Null if no State objects.
    (lastState as EventsStateMixin?)?.setState(() {}, log: false);

    /// If count is divisible by 5
    if (_model.counter % 5 == 0) {
      // Assigning a value will cause 'rootState?.notifyClients()'
      // Update the interface with the latest change.
      dataObject = _model.sayHello();
    }
  }

  ///
  @override
  void deactivateTabsScaffold() => _appCon.deactivateTabsScaffold();

  ///
  @override
  void tabSwitch(int index) => _appCon.tabSwitch(index);

  ///
  @override
  void tabSwitchBack() => _appCon.tabSwitchBack();
}
