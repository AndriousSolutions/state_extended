// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

// Widget builder allows for null
typedef MaybeBuildWidgetType = Widget? Function(BuildContext context);

/// Creates a widget that rebuilds when the given listenable calls
/// notifyListeners() function
/// Used by [StateXController]'s [setBuilder] function
///
/// dartdoc:
/// {@category State Object Controller}
class ListenableWidgetBuilder extends StatefulWidget {
  /// The arguments is not required.
  const ListenableWidgetBuilder({
    super.key,
    this.listenable,
    this.builder,
  });

  /// Checked in State object if, in fact, a Listenable
  final dynamic listenable;

  /// Supply a Widget builder
  final MaybeBuildWidgetType? builder;

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
class _ListenableState extends State<ListenableWidgetBuilder> {
  //
  @override
  void initState() {
    super.initState();
    // May actually be a Listenable
    if (widget.builder != null && widget.listenable is Listenable) {
      builder = widget.builder!;
      listenable = widget.listenable;
      listenable?.addListener(_callBuild);
    } else {
      // A widget must be provided. Even if it's nothing
      builder = (_) => const SizedBox.shrink();
    }
  }

  // Possibly not provided
  Listenable? listenable;

  // A Widget will be returned no matter what is provided.
  late MaybeBuildWidgetType builder;

  // Store the past widget displayed, and use it if builder returns null.
  Widget? _widget;

  @override
  void didUpdateWidget(ListenableWidgetBuilder oldWidget) {
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
    _widget = null;
    listenable?.removeListener(_callBuild);
    listenable = null;
    super.dispose();
  }

  void _callBuild() {
    if (mounted) {
      setState(() {
        // Call the build() function again
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final widget = builder.call(context);
    // The builder is allowed to return null.
    if (widget == null) {
      _widget ??= const SizedBox.shrink();
    } else {
      _widget = widget;
    }
    return _widget!;
  }
}
