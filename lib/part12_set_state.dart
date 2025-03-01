// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

///  Used like the function, setState(), to 'spontaneously' call
///  build() functions here and there in your app. Much like the Scoped
///  Model's ScopedModelDescendant() class.
///  This class object will only rebuild if the App's InheritedWidget notifies it
///  as it is a dependency.
///
/// dartdoc:
/// {@category AppStateX class}
@protected
class SetState extends StatelessWidget {
  /// Supply a 'builder' passing in the App's 'data object' and latest BuildContext object.
  const SetState({super.key, required this.builder});

  /// This is called with every rebuild of the App's inherited widget.
  final Widget Function(BuildContext context, Object? object) builder;

  /// Calls the required Function object:
  /// Function(BuildContext context, T? object)
  /// and passes along the app's custom 'object'
  @override
  Widget build(BuildContext context) {
    //
    final rootState = RootStateMixin._rootStateX;

    if (rootState != null) {
      /// Go up the widget tree and link to the App's inherited widget.
      rootState.dependOnInheritedWidget(context);
      rootState._inSetStateBuilder = true;
      StateX._setStateAllowed = false;
    }

    final Widget widget = builder(context, rootState?._dataObj);

    if (rootState != null) {
      StateX._setStateAllowed = true;
      rootState._inSetStateBuilder = false;
    }
    return widget;
  }
}
