// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

// Widget builder allows for null
typedef BuilderMaybeObjectType = Widget Function(
    BuildContext context, Object? dataObj);

@Deprecated('Use SetBuilder instead')
class SetState extends SetBuilder {
  const SetState({super.key, required super.builder});
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
class SetBuilder extends StatefulWidget {
  ///
  const SetBuilder({super.key, required this.builder});
  // This is called with every rebuild of the App's inherited widget.
  final BuilderMaybeObjectType builder;
  @override
  State<StatefulWidget> createState() => _SetBuilderState();
}

// class _SetBuilderState extends State<_SetBuilderWidget> {
class _SetBuilderState extends State<SetBuilder> {
  @override
  void initState() {
    super.initState();
    builder = widget.builder;
  }

  late BuilderMaybeObjectType builder;

  /// Calls the required Function object:
  /// Function(BuildContext context, T? dataObj)
  /// and passes along the app's custom 'object'
  @override
  Widget build(BuildContext context) {
    //
    if (appState == null) {
      // Look for it in the Widget tree
      appState = context.findAncestorStateOfType<AppStateX>();

      // Go up the widget tree and link to the App's inherited widget.
      appState?.dependOnInheritedWidget(context);
    }

    appState?._inSetStateBuilder = true;

    StateX._setStateAllowed = false;

    final Widget widget = builder(context, appState?._dataObj);

    StateX._setStateAllowed = true;

    appState?._inSetStateBuilder = false;

    return widget;
  }

  // An App's State object
  AppStateX? appState;

  @override
  void dispose() {
    appState = null;
    super.dispose();
  }
}
