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

  /// Supply the State object
  State? get state => _state;

  // set state(covariant State? state) => _state = state;  // Shouldn't be public!!

  State? _state;

  final Set<State> _stateSet = {};
  bool _stateJustAdded = false;

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

    // If just added, assign as the 'current' state object.
    if (_stateJustAdded || _state == null) {
      _state = state;
    }
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

  /// Returns a State object using a unique String identifier.
  State? stateById(String? id) {
    State? state;
    if (_stateSet.isNotEmpty && id != null) {
      id = id.trim();
      final stateList = _stateSet.toList().reversed;
      for (final s in stateList) {
        if (s is StateX && s.identifier == id) {
          state = s;
          break;
        }
      }
    }
    return state;
  }

  /// Returns a Map of StateView objects using unique String identifiers.
  Map<String, State> statesById(List<String> ids) {
    final Map<String, State> map = {};
    for (final id in ids) {
      final state = stateById(id);
      if (state != null) {
        map[id] = state;
      }
    }
    return map;
  }

  /// Returns a List of StateX objects using unique String identifiers.
  List<State> listStates(List<String> keys) => statesById(keys).values.toList();

  /// Retrieve the State object by type
  /// Returns null if not found
  T? stateByType<T extends State>() => ofState<T>();

  /// Retrieve the StateX object of type T
  /// Returns null if not found
  T? ofState<T extends State>() {
    State? state;
    if (_stateSet.isNotEmpty) {
      try {
        for (final item in _stateSet.toList().reversed) {
          if (item is T) {
            state = item;
            break;
          }
        }
      } catch (_) {
        state = null;
      }
    }
    return state as T?;
  }

  /// Retrieve the State object by its StatefulWidget. Returns null if not found.
  State? stateOf<T extends StatefulWidget>() {
    State? state;
    for (final s in _stateSet.toList().reversed) {
      if (s.widget is T) {
        state = s;
        break;
      }
    }
    return state;
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
  }
}

/// Used to explicitly return the 'type' indicated.
Type _type<U>() => U;
