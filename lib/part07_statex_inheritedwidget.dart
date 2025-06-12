// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// The built-in InheritedWidget used by [StateX]
///
/// dartdoc:
/// {@category StateX class}
class StateXInheritedWidget extends InheritedWidget {
  const StateXInheritedWidget({
    super.key,
    required this.state,
    required super.child,
  });

  final StateX state;

  @override
  InheritedElement createElement() {
    //
    final element = InheritedElement(this);
    state._inheritedElement = element;
    // Associate any dependencies widgets to this InheritedWidget
    // toList(growable: false) prevent concurrent error
    for (final context in state._dependencies.toList(growable: false)) {
      context.dependOnInheritedElement(element);
      state._dependencies.remove(context);
    }
    return element;
  }

  /// Use the StateX's updateShouldNotify() function
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      state.updateShouldNotify(oldWidget);
}
