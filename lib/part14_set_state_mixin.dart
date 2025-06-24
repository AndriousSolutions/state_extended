// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Used by StateXController.
/// Allows you to call [setState] function from the 'current' the State object.
///
/// dartdoc:
/// {@category State Object Controller}
mixin SetStateMixin {
  /// Calls the 'current' State object's setState() function if any.
  // ignore: invalid_use_of_protected_member
  void setState(VoidCallback fn) => state?.setState(fn);

  /// Retrieve the State object by its StatefulWidget. Returns null if not found.
  State? stateOf<T extends StatefulWidget>() =>
      _stateWidgetMap.isEmpty ? null : _stateWidgetMap[_type<T>()];

  /// Supply the State object
  State? get state => _state;

  // set state(covariant State? state) => _state = state;  // Shouldn't be public!!

  State? _state;

  final Set<State> _stateSet = {};
  final Map<Type, State> _stateWidgetMap = {};
  bool _stateJustAdded = false;

  /// Add the provided State object to the Map object if
  /// it's the 'current' StateX object in _stateX.
  void _addStateToSetter(State state) {
    if (_stateJustAdded && _state != null && _state == state) {
      _stateWidgetMap.addAll({state.widget.runtimeType: state});
    }
  }

  /// Add to a Set object and assigned to as the 'current' StateX
  /// However, if was already previously added, it's not added
  /// again to a Set object and certainly not set the 'current' StateX.
  bool _pushStateToSetter(State? state) {
    //
    if (state == null) {
      return false;
    }
    // Pushed onto State Set.
    _stateJustAdded = _stateSet.add(state);
    return _stateJustAdded;
  }

  /// This removes the most recent StateX object added
  /// to the Set of StateX state objects.
  /// Primarily internal use only: This disconnects the StateXController from that StateX object.
  bool _popStateFromSetter([State? state]) {
    // Return false if null
    if (state == null) {
      return false;
    }

    // Remove from the Map
    _stateWidgetMap.removeWhere((key, value) => value == state);

    // Remove from the Set
    final pop = _stateSet.remove(state);

    // Was the 'popped' state the 'current' state?
    if (state == _state) {
      //
      _stateJustAdded = false;

      if (_stateSet.isEmpty) {
        _state = null;
      } else {
        _state = _stateSet.last;
      }
    }
    return pop;
  }

  /// Retrieve the StateX object of type T
  /// Returns null if not found
  T? ofState<T extends State>() {
    State? state;
    if (_stateSet.isEmpty) {
      state = null;
    } else {
      final stateList = _stateSet.toList(growable: false);
      try {
        for (final item in stateList) {
          if (item is T) {
            state = item;
            break;
          }
        }
      } catch (_) {
        state = null;
      }
    }
    return state == null ? null : state as T;
  }

  /// Return the first State object
  State? get firstState => _stateSet.isEmpty ? null : _stateSet.first;

  /// Return the 'latest' State object
  State? get lastState => _stateSet.isEmpty ? null : _stateSet.last;

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => lastState?.context;

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  bool get inDebugMode {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// To externally 'process' through the State objects.
  /// Invokes [func] on each StateX possessed by this object.
  bool forEachState(void Function(State state) func, {bool? reversed}) {
    bool each = true;
    Iterable<State> it;
    // In reversed chronological order
    if (reversed != null && reversed) {
      it = _stateSet.toList(growable: false).reversed;
    } else {
      it = _stateSet.toList(growable: false);
    }
    for (final State state in it) {
      try {
        if (state.mounted) {
          if (state is! StateX || !state._deactivated) {
            func(state);
          }
        }
      } catch (e, stack) {
        each = false;
        // Record the error
        if (state is StateX) {
          state.recordErrorInHandler(e, stack);
        }
      }
    }
    return each;
  }

  /// To externally 'process' through the StateX objects.
  /// Invokes [func] on each StateX possessed by this object.
  bool forEachStateX(void Function(StateX state) func, {bool? reversed}) {
    bool each = true;
    Iterable<State> it;
    // In reversed chronological order
    if (reversed != null && reversed) {
      it = _stateSet.toList(growable: false).reversed;
    } else {
      it = _stateSet.toList(growable: false);
    }
    for (final State state in it) {
      try {
        if (state.mounted) {
          if (state is StateX && !state._deactivated) {
            func(state);
          }
        }
      } catch (e, stack) {
        each = false;
        // Record the error
        if (state is StateX) {
          state.recordErrorInHandler(e, stack);
        }
      }
    }
    return each;
  }

  /// Clean up memory in case not empty
  void disposeSetState() {
    _stateSet.clear();
    _stateWidgetMap.clear();
  }
}

/// Used to explicitly return the 'type' indicated.
Type _type<U>() => U;
