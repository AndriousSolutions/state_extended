// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Used by StateXController
/// Allows you to call 'setState' from the 'current' the State object.
///
/// dartdoc:
/// {@category State Object Controller}
mixin SetStateMixin {
  /// Calls the 'current' State object's setState() function if any.
  void setState(VoidCallback fn) => state?.setState(fn);

  /// Retrieve the State object by its StatefulWidget. Returns null if not found.
  StateX? stateOf<T extends StatefulWidget>() =>
      _stateWidgetMap.isEmpty ? null : _stateWidgetMap[_type<T>()];

  /// Supply the State object
  StateX? get state => _stateX;
  set state(covariant StateX? state) => _stateX = state;

  StateX? _stateX;

  final Set<StateX> _stateXSet = {};
  final Map<Type, StateX> _stateWidgetMap = {};
  bool _statePushed = false;

  /// Add the provided State object to the Map object if
  /// it's the 'current' StateX object in _stateX.
  void _addStateToSetter(covariant StateX stateX) {
    if (_statePushed && _stateX != null && _stateX == stateX) {
      _stateWidgetMap.addAll({stateX.widget.runtimeType: stateX});
    }
  }

  /// Add to a Set object and assigned to as the 'current' StateX
  /// However, if was already previously added, it's not added
  /// again to a Set object and certainly not set the 'current' StateX.
  bool _pushStateToSetter(covariant StateX? stateX) {
    //
    if (stateX == null) {
      return false;
    }
    // Pushed onto State Set.
    _statePushed = _stateXSet.contains(stateX) || _stateXSet.add(stateX);
    return _statePushed;
  }

  /// This removes the most recent StateX object added
  /// to the Set of StateX state objects.
  /// Primarily internal use only: This disconnects the StateXController from that StateX object.
  bool _popStateFromSetter([covariant StateX? stateX]) {
    // Return false if null
    if (stateX == null) {
      return false;
    }

    // Remove from the Map
    _stateWidgetMap.removeWhere((key, value) => value == stateX);
    // Remove from the Set
    final pop = _stateXSet.remove(stateX);

    // Was the 'popped' state the 'current' state?
    if (stateX == state) {
      //
      _statePushed = false;

      if (_stateXSet.isEmpty) {
        state = null;
      } else {
        state = _stateXSet.last;
      }
    }
    return pop;
  }

  /// Retrieve the StateX object of type T
  /// Returns null if not found
  T? ofState<T extends StateX>() {
    StateX? state;
    if (_stateXSet.isEmpty) {
      state = null;
    } else {
      final stateList = _stateXSet.toList(growable: false);
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

  /// To externally 'process' through the State objects.
  /// Invokes [func] on each StateX possessed by this object.
  bool forEachState(void Function(StateX state) func, {bool? reversed}) {
    bool each = true;
    Iterable<StateX> it;
    // In reversed chronological order
    if (reversed != null && reversed) {
      it = _stateXSet.toList(growable: false).reversed;
    } else {
      it = _stateXSet.toList(growable: false);
    }
    for (final StateX state in it) {
      try {
        if (state.mounted && !state._deactivated) {
          func(state);
        }
      } catch (e, stack) {
        each = false;
        // Record the error
        state.recordErrorInHandler(e, stack);
      }
    }
    return each;
  }

  /// Return the first State object
  StateX? get firstState => _stateXSet.isEmpty ? null : _stateXSet.first;

  /// Return the 'latest' State object
  StateX? get lastState => _stateXSet.isEmpty ? null : _stateXSet.last;

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

  /// Clean up memory in case not empty
  void disposeSetState() {
    _stateXSet.clear();
    _stateWidgetMap.clear();
  }
}

/// Used to explicitly return the 'type' indicated.
Type _type<U>() => U;
