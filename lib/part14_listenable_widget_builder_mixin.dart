// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// setBuilder(WidgetBuilder? builder) rebuilds with every setState() call.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin ListenableWidgetBuilderMixin {

  /// Returns a widget from builder assuming the current object is a [Listenable]
  /// const SizedBox.shrink() otherwise
  Widget setBuilder(WidgetBuilder? builder) {
    if (builder != null) {
      _widgetBuilderUsed = true;
    }
    return _ListenableWidgetBuilder(
      listenable: this,
      builder: builder,
    );
  }

  /// A flag. Noting if the function above is ever used.
  bool get setBuilderUsed => _widgetBuilderUsed;
  bool _widgetBuilderUsed = false;
}

/// Creates a widget that rebuilds when the given listenable calls.
/// notifyListeners() function
class _ListenableWidgetBuilder extends StatefulWidget {
  /// The arguments is not required.
  const _ListenableWidgetBuilder({
    this.listenable,
    this.builder,
  });

  /// Checked in State object if, in fact, a Listenable
  final dynamic listenable;

  /// Supply a Widget builder
  final WidgetBuilder? builder;

  /// Subclasses typically do not override this method.
  @override
  State createState() => _ListenableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Listenable>('listenable', listenable));
  }
}

//
class _ListenableState extends State<_ListenableWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    // May be actually be a Listenable
    if (widget.builder != null && widget.listenable is Listenable) {
      widgetBuilder = widget.builder!;
      listenable = widget.listenable;
      listenable?.addListener(_callBuild);
    } else {
      // A widget must be provided. Even if it's nothing
      widgetBuilder = (_) => const SizedBox.shrink();
    }
  }

  // Possibly not provided
  Listenable? listenable;
  // A Widget will be returned no matter what is provided.
  late WidgetBuilder widgetBuilder;

  @override
  void didUpdateWidget(_ListenableWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Possibly a O(2) expense if oldWidget == widget
    if (oldWidget.listenable is Listenable) {
      oldWidget.listenable?.removeListener(_callBuild);
    }
    if (widget.listenable is Listenable) {
      widget.listenable?.addListener(_callBuild);
    }
  }

  @override
  void dispose() {
    listenable?.removeListener(_callBuild);
    listenable = null;
    super.dispose();
  }

  void _callBuild() {
    //
    if (!mounted) {
      return;
    }
    setState(() {
      // Call the build() function again
    });
  }

  @override
  Widget build(BuildContext context) => widgetBuilder.call(context);
}
