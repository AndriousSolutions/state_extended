// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Supply access to the 'App' State object.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin class AppStateMixin {
  /// Returns the 'first' StateX object in the App
  // Important to prefix with the class name to 'share' this as a mixin.
  @Deprecated('Use appStateX instead.')
  AppStateX? get rootState => appStateX;

  /// The App's State object
  AppStateX? get appStateX {
    // TODO: implement appStateX
    throw UnimplementedError();
  }

  /// This is of type Object allowing you
  /// to propagate any class object you wish down the widget tree.
  Object? get dataObject => appStateX?._dataObj;

  /// Assign an object to the property, dataObject.
  /// It will not assign null and if SetState objects are implemented,
  /// will call the App's InheritedWidget to be rebuilt and call its
  /// dependencies.
  set dataObject(Object? object) {
    //
    if (object != null) {
      final state = appStateX;
      final dataObject = state?._dataObj;
      // Notify dependencies only if their was a change.
      if (dataObject == null || dataObject != object) {
        state?._dataObj = object;
        // Call inherited widget to 'rebuild' any dependencies
        state?.notifyClients();
      }
    }
  }
}

/// Deprecated, Use [AppStateMixin] mixin instead.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
@Deprecated('Use AppStateMixin mixin instead.')
// ignore: deprecated_member_use_from_same_package
mixin RootStateMixin {
  /// Returns the 'first' StateX object in the App
  // Important to prefix with the class name to 'share' this as a mixin.
  @Deprecated('Use appState instead.')
  AppStateX? get rootState => appStateX;

  AppStateX? get appStateX => AppStateX._instance;

  /// This is of type Object allowing you
  /// to propagate any class object you wish down the widget tree.
  Object? get dataObject => AppStateX._instance?._dataObj;

  /// Assign an object to the property, dataObject.
  /// It will not assign null and if SetState objects are implemented,
  /// will call the App's InheritedWidget to be rebuilt and call its
  /// dependencies.
  set dataObject(Object? object) {
    //
    if (object != null) {
      final state = AppStateX._instance;
      final dataObject = state?._dataObj;
      // Notify dependencies only if their was a change.
      if (dataObject == null || dataObject != object) {
        state?._dataObj = object;
        // Call inherited widget to 'rebuild' any dependencies
        state?.notifyClients();
      }
    }
  }
}
