// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Supply access to the 'Root' State object.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin RootStateMixin {
  ///Important to record the 'root' StateX object. Its an InheritedWidget!
  bool setRootStateX(StateX? state) {
    // This can only be called once successfully. Subsequent calls are ignored.
    // Important to prefix with the class name to 'share' this as a mixin.
    final set =
        state != null && RootStateMixin._rootStateX == null && state is AppStateX;
    if (set) {
      // Important to prefix with the class name to 'share' this as a mixin.
      RootStateMixin._rootStateX = state;
    }
    return set;
  }

  /// To supply the static value across all instances of
  /// StateX objects, ControllerMVC objects and Model objects
  /// reference it using the class prefix, RootState.
  static AppStateX? _rootStateX;

  /// Returns the 'first' StateX object in the App
  // Important to prefix with the class name to 'share' this as a mixin.
  AppStateX? get rootState => RootStateMixin._rootStateX;

  /// Returns the 'latest' context in the App.
  BuildContext? get lastContext => RootStateMixin._rootStateX?.lastState?.context;

  /// This is of type Object allowing you
  /// to propagate any class object you wish down the widget tree.
  Object? get dataObject => RootStateMixin._rootStateX?._dataObj;

  /// Assign an object to the property, dataObject.
  /// It will not assign null and if SetState objects are implemented,
  /// will call the App's InheritedWidget to be rebuilt and call its
  /// dependencies.
  set dataObject(Object? object) {
    // Never explicitly set to null
    if (object != null) {
      final state = RootStateMixin._rootStateX;
      final dataObject = state?._dataObj;
      // Notify dependencies only if their was a change.
      if (dataObject == null || dataObject != object) {
        state?._dataObj = object;
        // Call inherited widget to 'rebuild' any dependencies
        state?.notifyClients();
      }
    }
  }

  /// Clear the static reference.
  /// Important to prefix with the class name to 'share' this as a mixin.
  void _clearRootStateX() => RootStateMixin._rootStateX = null;

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  bool get inDebugMode {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
