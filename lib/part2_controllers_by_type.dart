// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Collects Controllers of various types.
/// A State object, by definition, then can't have multiple instances of the same type.
///
/// dartdoc:
/// {@category StateX class}
mixin _ControllersByType on State {
  /// A collection of Controllers identified by type.
  /// <type, controller>
  final Map<Type, StateXController> _mapControllerByType = {};

  /// Returns true if found.
  bool contains(StateXController con) =>
      _mapControllerByType.containsValue(con);

  /// Returns true if found
  bool containsType<T>() => _mapControllerByType.containsKey(T);

  /// List the controllers.
  List<StateXController> get controllerList =>
      _mapControllerByType.values.toList(growable: false);

  /// Add a list of 'Controllers'.
  List<String> addList(List<StateXController> list) {
    final List<String> keyIds = [];
    for (final con in list) {
      if (!_mapControllerByType.containsKey(con.runtimeType)) {
        keyIds.add(add(con));
      }
    }
    return keyIds;
  }

  /// Add a 'StateXController'
  /// Returns the StateXController's unique identifier.
  String add(StateXController? con) {
    String id;
    if (con == null) {
      id = '';
    } else {
      id = con.identifier;
      final type = con.runtimeType;
      if (_mapControllerByType.containsKey(type)) {
        // Indicate is was not added.
        id = '';
      } else {
        _mapControllerByType.addAll({type: con});
      }
    }
    return id;
  }

  /// Remove a 'StateXController'
  bool remove(StateXController? con) {
    bool removed = con != null;
    if (removed) {
      removed = _mapControllerByType.remove(con.runtimeType) != null;
    }
    return removed;
  }

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  bool removeByKey(String? id) {
    bool removed = id != null;
    if (removed) {
      final con = controllerById(id);
      removed = con != null;
      if (removed) {
        removed = remove(con);
      }
    }
    return removed;
  }

  /// Retrieve a StateXController by type.
  U? controllerByType<U extends StateXController>() =>
      _mapControllerByType[_type<U>()] as U?;

  /// Retrieve a controller by it's unique identifier.
  StateXController? controllerById(String? id) {
    StateXController? con;
    if (id != null && id.isNotEmpty) {
      for (final controller in controllerList) {
        if (controller.identifier == id) {
          con = controller;
          break;
        }
      }
    }
    return con;
  }

  /// Returns the list of 'Controllers' but you must know their keys.
  List<StateXController?> listControllers(List<String?>? ids) {
    final List<StateXController?> controllers = [];
    if (ids != null) {
      for (final id in ids) {
        if (id != null && id.isNotEmpty) {
          for (final controller in controllerList) {
            if (controller.identifier == id) {
              controllers.add(controller);
              break;
            }
          }
        }
      }
    }
    return controllers;
  }

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get firstCon {
    final list = controllerList;
    return list.isEmpty ? null : list.first;
  }

  /// Returns 'the last' StateXController associated with this StateX object.
  /// Returns null if empty.
  StateXController? get lastCon {
    final list = controllerList;
    return list.isEmpty ? null : list.last;
  }

  /// To externally 'process' through the controllers.
  /// Invokes [func] on each StateXController possessed by this StateX object.
  /// With an option to process in reversed chronological order
  bool forEach(void Function(StateXController con) func, {bool? reversed}) {
    bool each = true;
    Iterable<StateXController> list;
    // In reversed chronological order
    if (reversed != null && reversed) {
      list = controllerList.reversed;
    } else {
      list = controllerList;
    }
    for (final StateXController con in list) {
      try {
        func(con);
      } catch (e, stack) {
        each = false;
        if (this is StateX) {
          (this as StateX).recordException(e, stack);
        }
      }
    }
    return each;
  }

  /// Copy particular properties from the 'previous' StateX
  // ignore: unused_element
  void _copyOverStateControllers([StateX? oldState]) {
    //
    if (oldState == null) {
      return;
    }
    // Copy over certain properties
    _mapControllerByType.addAll(oldState._mapControllerByType);
  }

  @override
  void dispose() {
    // Clear the its list of Controllers
    _mapControllerByType.clear();
    super.dispose();
  }
}
