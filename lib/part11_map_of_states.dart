// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Works with the collection of State objects in the App.
///
/// dartdoc:
/// {@category StateX class}
/// {@category StateXController class}
mixin _MapOfStates on State {
// mixin _MapOfStates on State {
  /// All the State objects in this app.
  static final Map<String, StateX> _states = {};

  /// This is 'privatized' function as it is an critical method and not for public access.
  /// This contains the 'main list' of StateX objects present in the app!
  bool _addToMapOfStates(StateX? state) {
    final add = state != null;
    if (add) {
      //
      _MapOfStates._states[state._id] = state;
    }
    return add;
  }

  /// Remove the specified State object from static Set object.
  bool _removeFromMapOfStates(StateX? state) {
    var removed = state != null;
    if (removed) {
      final int length = _MapOfStates._states.length;
      _MapOfStates._states.removeWhere((key, value) => state._id == key);
      removed = _MapOfStates._states.length < length;
    }
    return removed;
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  T? stateByType<T extends StateX>() {
    StateX? state;
    try {
      for (final item in _MapOfStates._states.values) {
        if (item is T) {
          state = item;
          break;
        }
      }
    } catch (_) {
      state = null;
    }
    return state == null ? null : state as T;
  }

  /// Returns a StateView object using a unique String identifier.
  StateX? stateById(String? id) => _MapOfStates._states[id];

  /// Returns a Map of StateView objects using unique String identifiers.
  Map<String, StateX> statesById(List<String> ids) {
    final Map<String, StateX> map = {};
    for (final id in ids) {
      final state = stateById(id);
      if (state != null) {
        map[id] = state;
      }
    }
    return map;
  }

  /// Returns a List of StateX objects using unique String identifiers.
  List<StateX> listStates(List<String> keys) {
    return statesById(keys).values.toList();
  }

  /// Return a List of available StateX objects
  List<StateX> statesList({bool? reversed, StateX? remove}) {
    List<StateX> list;
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = _MapOfStates._states.values.toList().reversed.toList();
    } else {
      list = _MapOfStates._states.values.toList();
    }
    // Exclude a particular State.
    if (remove != null) {
      list.remove(remove);
    }
    return list.toList(growable: false);
  }

  @Deprecated('Use appCon instead.')
  StateXController? get rootCon => appCon;
  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get appCon {
    StateXController? controller;
    final state = firstState;
    if (state != null) {
      controller = state.controller;
    }
    return controller;
  }

  /// Return the first State object
  StateX? get firstState => _nextStateX();

  /// Return the 'latest' State object
  StateX? get lastState => _nextStateX(reversed: true);

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => lastState?.context;

  /// Loop through the list and return the next available State object
  StateX? _nextStateX({bool? reversed}) {
    reversed = reversed != null && reversed;
    StateX? nextState;
    final list = statesList(reversed: reversed);
    for (final StateX state in list) {
      if (state.mounted && !state._deactivated) {
        nextState = state;
        break;
      }
    }
    return nextState;
  }

  /// To externally 'process' through the State objects.
  /// Invokes [func] on each StateX possessed by this StateX object.
  /// With an option to process in reversed chronological order
  bool forEachState(void Function(StateX state) func,
      {bool? reversed, StateX? remove}) {
    bool each = true;
    final list = statesList(reversed: reversed, remove: remove);
    for (final StateX state in list) {
      try {
        if (state.mounted && !state._deactivated) {
          func(state);
        }
      } catch (e, stack) {
        each = false;
        // Record the error
        if (this is StateX) {
          (this as StateX).recordException(e, stack);
        }
      }
    }
    return each;
  }

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  bool get inDebugMode {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
