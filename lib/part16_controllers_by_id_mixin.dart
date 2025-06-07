// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Manages the 'Controllers' associated with this
/// StateX object at any one time by their unique identifier.
mixin _ControllersById<T extends StatefulWidget> on StateX<T> {
  /// Stores the Controller by its Id
  ///  [<id, controller>]
  final Map<String, StateXController> _mapControllerById = {};

  /// List the runtimeType of the stored controllers.
  ///  [<id, type>]
  final Map<String, Type> _mapControllerTypes = {};

  /// Supply a public list of all the Controllers.
  @override
  List<StateXController> get controllerList =>
      _mapControllerById.values.toList(growable: false);

  /// Collect a 'StateXController'
  /// Returns the StateXController's unique identifier.
  @override
  String add(StateXController? con) {
    String id;
    if (con == null) {
      id = '';
    } else {
      id = con.identifier;
      if (!containsId(id)) {
        _mapControllerById[id] = con;
        // Will need to retrieve controller by type at times.
        _mapControllerTypes[id] = con.runtimeType;

        /// This connects the StateXController to this State object!
        if(con._pushStateToSetter(this)){
          // If just added, assign as the 'current' state object.
          con.state = this;
        }
      }
    }
    return id;
  }

  /// Collect a list of 'Controllers'.
  @override
  List<String> addList(List<StateXController>? list) {
    //list.forEach(add);
    final List<String> keyIds = [];
    if (list != null) {
      for (final con in list) {
        keyIds.add(add(con));
      }
    }
    return keyIds;
  }

  /// Remove a 'StateXController'
  /// Returns boolean if successful.
  @override
  bool remove(StateXController? con) => removeByKey(con!.identifier);

  /// Remove a specific 'StateXController' by its unique 'key' identifier.
  @override
  bool removeByKey(String? id) {
    bool remove = id != null;
    if (remove) {
      remove = _mapControllerById.containsKey(id);
      if (remove) {
        _mapControllerById.remove(id);
        _mapControllerTypes.remove(id);
      }
    }
    return remove;
  }

  /// Retrieve a StateXController by type.
  @override
  U? controllerByType<U extends StateXController>() {
    U? controller;

    // Take a copy of the types
    final temp = Map.of(_mapControllerTypes);

    // and remove all not of the specified type
    temp.removeWhere((key, value) => value != U);

    // There can only be one instance of a particular type returned.
    if (temp.length == 1) {
      controller = _mapControllerById[temp.keys.first] as U?;
    }
    return controller;
  }

  // Retrieve a controller by it's unique identifier.
  @override
  StateXController? controllerById(String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    return _mapControllerById[id];
  }

  /// Returns true if found.
  @override
  bool contains(StateXController con) {
    bool contains = false;
    for (final controller in controllerList) {
      contains = controller == con;
      if (contains) {
        break;
      }
    }
    return contains;
  }

  /// Returns the list of 'Controllers' but you must know their keys.
  @override
  List<StateXController?> listControllers(List<String?>? keys) =>
      _controllersById(keys).values.toList();

  /// Returns a list of controllers by their unique identifiers.
  Map<String, StateXController?> _controllersById(List<String?>? ids) {
    final Map<String, StateXController?> controllers = {};
    if (ids != null) {
      for (final id in ids) {
        if (id != null && id.isNotEmpty) {
          if (_mapControllerById.containsKey(id)) {
            controllers[id] = _mapControllerById[id];
          }
        }
      }
    }
    return controllers;
  }

  /// Returns 'the first' StateXController associated with this StateX object.
  /// Returns null if empty.
  @override
  StateXController? get rootCon {
    final list = controllerList;
    return list.isEmpty ? null : list.first;
  }

  /// Returns true if the specified 'StateXController' is associated with this StateX object.
  bool containsId(String? id) => _mapControllerById.containsKey(id);

  /// To externally 'process' through the controllers.
  /// Invokes [func] on each StateXController possessed by this StateX object.
  /// With an option to process in reversed chronological order
  @override
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
        recordErrorInHandler(e, stack);
      }
    }
    return each;
  }

  @override
  void dispose() {
    // Clear the its list of Controllers
    _mapControllerById.clear();
    _mapControllerTypes.clear();
    super.dispose();
  }
}
