// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Works with the collection of State objects in the App.
///
/// dartdoc:
/// {@category StateX class}
mixin MapOfStateXsMixin on State {
  /// All the State objects in this app.
  static final Map<String, State> _states = {};

  /// This is 'privatized' function as it is an critical method and not for public access.
  /// This contains the 'main list' of StateX objects present in the app!
  bool _addToMapOfStates(StateX? state) {
    final add = state != null;
    if (add) {
      //
      _states[state._id] = state;
    }
    return add;
  }

  /// Remove the specified State object from static Set object.
  bool _removeFromMapOfStates(StateX? state) {
    var removed = state != null;
    if (removed) {
      final int length = _states.length;
      _states.removeWhere((key, value) => state._id == key);
      removed = _states.length < length;
    }
    return removed;
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  T? stateByType<T extends State>() {
    State? state;
    try {
      for (final item in _states.values) {
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

  /// Consistent with the equivalent in the StateXController class
  T? ofState<T extends State>() => stateByType<T>();

  /// Retrieve the State object by its StatefulWidget. Returns null if not found.
  State? stateOf<T extends StatefulWidget>() {
    State? state;
    for (final s in _states.values.toList().reversed) {
      if (s.widget is T) {
        state = s;
        break;
      }
    }
    return state;
  }

  /// Returns a State object using a unique String identifier.
  State? stateById(String? id) => _states[id];

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

  @Deprecated('Use appCon instead.')
  StateXController? get rootCon => appCon;

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get appCon {
    StateXController? controller;
    final state = firstState;
    if (state != null && state is StateX) {
      controller = state.controller;
    }
    return controller;
  }

  /// Return the first State object
  State? get firstState => _nextStateX();

  /// Return the 'latest' State object
  State? get lastState => _nextStateX(reversed: true);

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => lastState?.context;

  /// Loop through the list and return the next available State object
  State? _nextStateX({bool? reversed}) {
    reversed = reversed != null && reversed;
    State? nextState;
    final list = _statesList(reversed: reversed);
    for (final State state in list) {
      if (state.mounted && (state is! StateX || !state._deactivated)) {
        nextState = state;
        break;
      }
    }
    return nextState;
  }

  /// Returns a List of StateX objects using unique String identifiers.
  List<State> listStates(List<String> keys) {
    return statesById(keys).values.toList();
  }

// coverage:ignore-start
  /// To externally 'process' through the [State] objects.
  /// Invokes [func] on each StateX possessed by this StateX object.
  /// With an option to process in reversed chronological order
  @Deprecated(
      'No longer allowed access to all State objects in the App.\n Only Controllers have this forEachState() function.')
  bool forEachState(
    void Function(State state) func, {
    bool? reversed,
    State? remove,
  }) =>
      false;

// coverage:ignore-end

// coverage:ignore-start
  /// To externally 'process' through the [StateX] objects.
  /// Invokes [func] on each StateX possessed by this StateX object.
  /// With an option to process in reversed chronological order
  @Deprecated(
      'No longer allowed access to all State objects in the App.\n Only Controllers have this forEachState() function.')
  bool forEachStateX(
    void Function(StateX state) func, {
    bool? reversed,
    State? remove,
  }) =>
      false;

// coverage:ignore-end

  /// To externally 'process' through the [StateX] objects.
  /// Invokes [func] on each StateX possessed by this StateX object.
  /// With an option to process in reversed chronological order
  bool _forEachStateX(
    void Function(StateX state) func, {
    bool? reversed,
    State? remove,
  }) {
    bool each = true;
    final list = _statesList(reversed: reversed, remove: remove);
    for (final State state in list) {
      try {
        if (state.mounted) {
          // if (state.mounted && !state._deactivated) { // Not working out gp
          if (state is StateX && !state._deactivated) {
            func(state);
          }
        }
      } catch (e, stack) {
        each = false;
        // Record the error
        if (this is StateX) {
          (this as StateX).recordErrorInHandler(e, stack);
        }
      }
    }
    return each;
  }

  /// Return a List of available StateX objects
  List<State> _statesList({bool? reversed, State? remove}) {
    List<State> list;
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = _states.values.toList().reversed.toList();
    } else {
      list = _states.values.toList();
    }
    // Exclude a particular State.
    if (remove != null) {
      list.remove(remove);
    }
    return list.toList(growable: false);
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
