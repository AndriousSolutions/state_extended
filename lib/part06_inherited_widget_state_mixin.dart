// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Supplies an InheritedWidget to a State class
///
/// dartdoc:
/// {@category StateX class}
/// {@category Using InheritedWidget}
mixin InheritedWidgetStateMixin on State {
  /// A flag determining whether the built-in InheritedWidget is used or not.
  bool get useInherited => _useInherited;
  bool _useInherited = false;

  // Collect any 'widgets' depending on this State's InheritedWidget.
  final Set<BuildContext> _dependencies = {};

  InheritedElement? _inheritedElement;

  // Widget passed to the InheritedWidget.
  Widget? _child;

  /// dartdoc:
  /// {@category StateX class}
  Widget buildF(BuildContext context) {
    _buildFOverridden = false;
    if (_useInherited) {
      _child ??= builder(context);
    } else {
      _child = builder(context);
    }
    return _useInherited
        ? StateXInheritedWidget(
            state: this as StateX,
            child: _child ?? const SizedBox.shrink(),
          )
        : _child!;
  }

  /// A flag. Note if buildF() function was overridden or not.
  bool get buildFOverridden => _buildFOverridden;
  bool _buildFOverridden = true;

  /// Use this function instead of the build() function
  ///
  /// dartdoc:
  /// {@category StateX class}
  Widget builder(BuildContext context) {
    _builderOverridden = false;
    return const SizedBox.shrink();
  }

  /// A flag. Note if builder() function was overridden or not.
  bool get builderOverridden => _builderOverridden;
  bool _builderOverridden = true;

  /// Determine if the dependencies should be updated.
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  ///
  ///  Set the specified widget (through its context) as a dependent of the InheritedWidget
  ///
  ///  Return false if not configured to use the InheritedWidget
  bool dependOnInheritedWidget(BuildContext? context) {
    final depend = useInherited && context != null;
    if (depend) {
      if (_inheritedElement == null) {
        _dependencies.add(context);
      } else {
        context.dependOnInheritedElement(_inheritedElement!);
      }
    }
    return depend;
  }

  /// In harmony with Flutter's own API there's also a notifyClients() function
  /// Rebuild the InheritedWidget of the 'closes' InheritedStateX object if any.
  bool notifyClients() {
    final inherited = useInherited;
    if (inherited) {
      setState(() {});
    }
    return inherited;
  }


  @Deprecated('Use setBuilder() instead.')
  Widget stateSet(WidgetBuilder? builder) => setBuilder(builder);

  /// Called when the State's InheritedWidget is called again
  /// This 'widget builder' will be called again.
  Widget setBuilder(WidgetBuilder? builder) {
    builder ??= (_) => const SizedBox.shrink();
    return useInherited && this is StateX
        ? StateDependentWidget(stateMixin: this as StateX, builder: builder)
        : builder(context);
  }

  /// Copy particular properties from the 'previous' StateX
  // ignore: unused_element
  // void _copyOverStateDependencies([StateX? oldState]) {
  //   //
  //   if (oldState == null) {
  //     return;
  //   }
  //   _dependencies.addAll(oldState._dependencies);
  // }

  @override
  void dispose() {
    _child = null;
    _inheritedElement = null;
    _dependencies.clear();
    super.dispose();
  }
}
