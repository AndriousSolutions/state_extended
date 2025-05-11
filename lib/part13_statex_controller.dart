// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Your 'working' class most concerned with the app's functionality.
/// Add it to a 'StateX' object to associate it with that State object.
///
/// dartdoc:
/// {@category Testing}
/// {@category Get started}
/// {@category Event handling}
/// {@category State Object Controller}
class StateXController
    with
        SetStateMixin,
        ImplNotifyListenersChangeNotifierMixin,
        StateListener,
        AppStateMixin,
        AsyncOps {
  /// Optionally supply a State object to 'link' to this object.
  /// Thus, assigned as 'current' StateX for this object
  StateXController([StateX? state]) {
    addState(state);
  }

  /// Part of the Flutter engine's 'garbage collection' process.
  /// Note: YOU WILL HAVE NO IDEA WHEN THIS WILL RUN in the Framework.
  /// BEST NOT TO USE THIS FUNCTION EVER!
  @override
  @mustCallSuper
  void dispose() {
    // Call the dispose of the implementation of Change Notifier
    disposeChangeNotifier();

    /// Controllers state property is now null from deactivate() function
    /// Always call 'initializing' routines in initState() and activate()
    super.dispose();
  }

  /// Associate this StateXController to the specified State object
  /// to use that State object's functions and features.
  /// Returns that State object's unique identifier.
  String addState(StateX? state) {
    if (state == null) {
      return '';
    }
    if (state.add(this).isNotEmpty) {
      return state.identifier;
    } else {
      return '';
    }
  }

  /// The current StateX object.
  StateX? get state => _stateX;

  /// Link a widget to an InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) =>
      _stateX?.dependOnInheritedWidget(context) ?? false;

  /// In harmony with Flutter's own API
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  bool notifyClients() {
    final notify = _stateX?.notifyClients() ?? false;
    notifyListeners();
    return notify;
  }

  /// Call a State object's setState()
  /// and notify any listeners
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    notifyListeners();
  }

  /// The 'Change' event has already been called in a previous State object
  bool get didCallChangeEvent {
    bool change = false;
    final list = _stateXSet.toList(growable: false);
    for (final StateX state in list) {
      // You're at the current State object
      if (state == _stateX) {
        change = _didCallChange;
        _didCallChange = false;
        break;
      }
      if (!_didCallChange && state.controllerList.contains(this)) {
        _didCallChange = true;
        break;
      }
    }
    return change;
  }

  bool _didCallChange = false;
}
