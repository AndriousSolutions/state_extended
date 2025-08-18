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
  static final Map<String, StateX> _stateXs = {};

  /// This is 'privatized' function as it is an critical method and not for public access.
  /// This contains the 'main list' of StateX objects present in the app!
  bool _addToMapOfStates(StateX? state) {
    final add = state != null;
    if (add) {
      _stateXs[state._id] = state;
    }
    return add;
  }

  /// Remove the specified State object from static Set object.
  bool _removeFromMapOfStates(StateX? state) {
    var removed = state != null;
    if (removed) {
      final int length = _stateXs.length;
      _stateXs.removeWhere((key, value) => state._id == key);
      removed = _stateXs.length < length;
    }
    return removed;
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  T? stateByType<T extends State>() {
    State? state;
    try {
      final stateList = _listStateXs(
        reversed: true,
        where: (s) => s.mounted && !s._deactivated,
      );
      for (final item in stateList) {
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
    final stateList = _listStateXs(
      reversed: true,
      where: (s) => s.mounted && !s._deactivated,
    );
    for (final s in stateList) {
      if (s.widget is T) {
        state = s;
        break;
      }
    }
    return state;
  }

  /// Returns a State object using a unique String identifier.
  State? stateById(String? id) => _stateXs[id];

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
  State? get firstState => _nextState();

  /// Return the 'latest' State object
  State? get lastState => _nextState(reversed: true);

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => lastState?.context;

  /// Loop through the list and return the next available State object
  State? _nextState({bool? reversed}) {
    reversed = reversed != null && reversed;
    final list = _listStateXs(
      where: (s) => s.mounted && !s._deactivated,
      reversed: reversed,
    );
    return list.isEmpty ? null : list.first;
  }

  /// Returns a List of StateX objects using unique String identifiers.
  List<State> listStates(List<String> keys) => statesById(keys).values.toList();

// Ignore in test coverage
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

// Ignore in test coverage
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

  /// To internally 'process' through the [StateX] objects.
  /// Invokes [func] on each StateX possessed by this StateX object.
  /// With an option to process in reversed chronological order
  bool _forEachStateX(
    void Function(StateX state) func, {
    bool Function(StateX state)? where,
    bool? reversed,
    StateX? remove,
  }) {
    bool each = true;
    try {
      //
      final list = _listStateXs(
        reversed: reversed,
        where: where,
        remove: remove,
      );
      for (final state in list) {
        func(state);
      }
    } catch (e, stack) {
      each = false;
      // Record the error
      if (this is StateX) {
        (this as StateX).recordErrorInHandler(e, stack);
      }
    }
    return each;
  }

  /// Return a List of available StateX objects
  List<StateX> _listStateXs({
    bool? reversed,
    bool Function(StateX state)? where,
    StateX? remove,
  }) {
    // The iterable sequence of StateX objects
    List<StateX> list = _stateXsIterable(where: where).toList();
    // Exclude a particular StateX.
    if (remove != null) {
      list.remove(remove);
    }
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = list.reversed.toList(growable: false);
    } else {
      list = list.toList(growable: false);
    }
    return list;
  }

  // The iterable sequence of StateX objects
  Iterable<StateX> _stateXsIterable({
    bool Function(StateX state)? where,
  }) {
    Iterable<StateX> itr;

    if (where == null) {
      itr = _stateXs.values;
    } else {
      itr = _stateXs.values.where(where);
    }
    return itr;
  }

  /// Clear of memory
  static void _dispose() {
    _stateXs.clear();
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
