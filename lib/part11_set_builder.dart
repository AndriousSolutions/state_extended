// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

// Widget builder allows for null
typedef BuilderMaybeObjectType = Widget Function(
    BuildContext context, Object? dataObj);

@Deprecated('Use SetBuilder instead')
class SetState extends SetBuilder {
  SetState({super.key, required super.builder});
}

///  Used like the function, setState(), to 'spontaneously' call
///  build() functions here and there in your app. Much like the Scoped
///  Model's ScopedModelDescendant() class.
///  This class object will only rebuild if the App's InheritedWidget notifies it
///  as it is a dependency.
///
/// dartdoc:
/// {@category AppStateX class}
@protected
class SetBuilder extends StatelessWidget {
  /// Supply a 'builder' passing in the App's 'data object' and latest BuildContext object.
  SetBuilder({super.key, required this.builder})
      : _key = _PrivateGlobalKey<_SetBuilderState>(_SetBuilderState(builder));

  final _PrivateGlobalKey _key;

  /// This is called with every rebuild of the App's inherited widget.
  final BuilderMaybeObjectType builder;

  @override
  Widget build(BuildContext context) => _SetBuilderWidget(key: _key);
}

class _SetBuilderWidget extends StatefulWidget {
  const _SetBuilderWidget({super.key});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      (key as GlobalObjectKey).value as State;
}

class _SetBuilderState extends State<_SetBuilderWidget> {
  _SetBuilderState(this.builder);
  BuilderMaybeObjectType builder;

  /// Calls the required Function object:
  /// Function(BuildContext context, T? dataObj)
  /// and passes along the app's custom 'object'
  @override
  Widget build(BuildContext context) {
    //
    /// Go up the widget tree and link to the App's inherited widget.
    AppStateX._instance?.dependOnInheritedWidget(context);
    AppStateX._instance?._inSetStateBuilder = true;

    StateX._setStateAllowed = false;

    final Widget widget = builder(context, AppStateX._instance?._dataObj);

    StateX._setStateAllowed = true;

    AppStateX._instance?._inSetStateBuilder = false;
    return widget;
  }
}
