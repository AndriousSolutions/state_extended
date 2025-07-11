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
        super(state);

  static Controller? _this;

  final Model _model;

  late ExampleAppController _appCon;

  /// Page1 Key
  /// Changing it will recreate its State object.
  Key? get page1Key => _page1Key ??= UniqueKey();

  set page1Key(Key? key) {
    _page1Key = key;
  }

  Key? _page1Key;

  /// Note, the count comes from a separate class, _Model.
  int get data => _model.counter;

  /// A flag indicating if an InheritedWidget is to be used.
  bool get useInherited => _useInherited;

  set useInherited(bool? use) {
    // Allow for null to mistakenly be passed
    if (use != null) {
      _useInherited = use;
      if (_useInherited) {
        // Ensure the other Switch is off
        _useChangeNotifier = false;
        removeAllStateListeners();
      }
    }
  }

  //
  bool _useInherited = false;

  @override
  void initState() {
    super.initState();

    /// Lets pretend you don't have ready access to the App Controller in some interface screens
    /// but is readily available in the Page 3 controller.
    /// Showing how some logic is hidden from the interface.
    _appCon =
        ExampleAppController(); // Not in constructor to prevent stack overflow.
  }

  /// Called with every new State object to use this controller if any
  @override
  void stateInit(state) {
    super.stateInit(state);

    if (state is Page1State) {
      /// State recreation will reset count, but the controller can saves the count
      state.count = page1Count;
    }
  }

  /// Called by the appropriate interface
  void onChangedInherited({bool? useInherited}) {
    // Allow for null to mistakenly be passed
    if (useInherited != null) {
      // Save the setting
      this.useInherited = useInherited;

      // See how additional logic is hidden from the interface
      // Page1 creates a new key and so a new State object with a new useInherited setting.
      page1Key = null;

      // Rebuild the App's State object
      appStateX?.setState(() {});

      //
      LogController.log(
          ':::::::::::: onChangedInherited($useInherited) in $controllerName');
    }
  }

  /// A flag indicating if an ChangeNotifier is to be used.
  bool get useChangeNotifier => _useChangeNotifier;

  set useChangeNotifier(bool? use) {
    _useChangeNotifier = use ?? false;
    if (_useChangeNotifier) {
      // Ensure the other Switch is off
      _useInherited = false;
    } else {
      removeAllStateListeners();
    }
  }

  //
  bool _useChangeNotifier = false;

  /// Called by the appropriate interface
  void onChangedNotifier({bool? useChangeNotifier}) {
    // Allow for null to mistakenly be passed
    if (useChangeNotifier != null) {
      // Save the setting
      this.useChangeNotifier = useChangeNotifier;

      //
      if (useChangeNotifier) {
        addStateListener(state);
      } else {
        removeStateListener(state);
      }

      // See how additional logic is hidden from the interface
      // Page1 creates a new key and so a new State object
      page1Key = null;

      //the App's State object.
      appStateX?.setState(() {});

      //
      LogController.log(
          ':::::::::::: onChangedNotifier($useChangeNotifier) in $controllerName');
    }
  }

  ///
  bool buildThisState(State? state) {
    // Allow for null to mistakenly be passed
    bool rebuild = state != null;
    if (rebuild) {
      rebuild = useInherited;
      if (rebuild) {
        /// This Builder Widget becomes a dependent of the built-in InheritedWidget.
        rebuild = dependOnInheritedWidget(state.context);
      }
      // Must test directly
      // Either useInherited or useChangeNotifier is true or neither.
      if (useChangeNotifier) {
        rebuild = addStateListener(state);
      } else {
        removeStateListener(state);
      }
    }
    return rebuild;
  }

  /// when the Drawer is just opened.
  void onOpenDrawer() {
    WordPairsTimer().deactivate();
  }

  /// When the Drawer is just closed.
  void onCloseDrawer() {
    WordPairsTimer().activate();
  }

  /// Page1 count is saved periodically
  int page1Count = 0;

  /// A specific function designated for a specific process
  void onPressedActionButton() {
    // We know the type of the 'current' State object.
    (state as Page1State).count++;
    // Record the count
    page1Count = (state as Page1State).count;

    /// Look how this Controller has access to this State object!
    /// The incremented counter will not update otherwise! Powerful!
    /// Comment out and the counter will appear not to work.
    // Step through the code, and see what it does and why.
    setState(() {});

    LogController.log('=========== onPressedActionButton() in $controllerName');
  }

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
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
    // The same thing but as type, StateX.
    statex?.setState(() {});

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
      // Assigning a value will cause 'appState?.notifyClients()'
      // Update the interface with the latest change.
      dataObject = _model.sayHello();
    }
  }

  @override
  void onError(FlutterErrorDetails details) {
    //
    final stack = details.stack;

    // Determine the specific error
    if (stack != null && stack.toString().contains('handleTap')) {
      // The Controller's 'current' State object.
      // ignore: unused_local_variable
      var pageState = state as Page1State;
      // Of course, there's two other ways to retrieve a State object.
      pageState = stateOf<Page1>() as Page1State;
      pageState = ofState<Page1State>()!;

      // The routine called when the button is pressed.
      onPressedActionButton();
    }
    // Optional at yhis point. You don't have to, but may call debugPrint()
    super.onError(details);
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
