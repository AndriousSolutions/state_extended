//
import '/src/view.dart';

/// The App's Drawer
class AppDrawer extends DrawerWrap {
  ///
  AppDrawer({super.key}) {
    //
    // if (MyApp.app.appState?.routesGenerated ?? false) {
    //   add(ListTile(
    //     key: const Key('Navigation'),
    //     subtitle: const Text('App Navigation'),
    //     onTap: () async {
    //       await Navigator.pushNamed(MyApp.app.context!, '/Page01');
    //     },
    //   ));
    // }
  }
}

// **** StatefulWidget just doesn't work for a Drawer ****

/// A standard Drawer object for your Flutter app.
class DrawerWrap extends StatelessWidget {
  /// Supply the properties to a Material Design [Drawer] Widget.
  DrawerWrap({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.width,
    this.header,
    this.children,
    this.semanticLabel,
    this.scrollDirection,
    this.reverse,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives,
    this.addRepaintBoundaries,
    this.addSemanticIndexes,
  }) {
    // Take any defined items.
    if (children != null) {
      _children.addAll(children!);
    }
  }

  //
  final List<Widget> _children = <Widget>[];

  /// The drawer's color.
  final Color? backgroundColor;

  /// The z-coordinate at which to place this drawer relative to its parent.
  final double? elevation;

  /// The color used to paint a drop shadow under the drawer's [Material],
  /// which reflects the drawer's [elevation].
  final Color? shadowColor;

  /// The color used as a surface tint overlay on the drawer's background color,
  /// which reflects the drawer's [elevation].
  final Color? surfaceTintColor;

  /// The shape of the drawer.
  final ShapeBorder? shape;

  /// The width of the drawer.
  final double? width;

  /// The top-most region of a material design drawer.
  final DrawerHeader? header;

  /// The semantic label of the dialog used by accessibility frameworks.
  final String? semanticLabel;

  /// The axis along which the scroll view scrolls.
  final Axis? scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  final bool? reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final ScrollController? scrollController;

  /// Whether this is the primary scroll view associated with the parent
  final bool? primary;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed
  final bool? shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  final double? itemExtent;

  /// If non-null, forces the children to have the same extent as the given
  /// widget in the scroll direction.
  final Widget? prototypeItem;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  final bool? addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  final bool? addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  final bool? addSemanticIndexes;

  /// The List of Widget items that make up the Drawer's contents.
  final List<Widget>? children;

  /// one item
  void add(Widget? item) {
    if (item != null) {
      _children.add(item);
    }
  }

  /// Add a List
  void addAll(List<Widget>? items) {
    if (items != null) {
      _children.addAll(items);
    }
  }

  /// Remove an item
  bool remove(Widget? item) {
    bool remove = item != null;
    if (remove) {
      remove = _children.remove(item);
    }
    return remove;
  }

  @override
  Widget build(BuildContext context) {
    //
    final widgets = <Widget>[];

    if (header != null) {
      widgets.add(header!);
    }

    if (_children.isNotEmpty) {
      widgets.addAll(_children);
    }

    return Drawer(
      backgroundColor: backgroundColor,
      elevation: elevation ?? 16,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      width: width,
      semanticLabel: semanticLabel,
      child: ListView(
        scrollDirection: scrollDirection ?? Axis.vertical,
        reverse: reverse ?? false,
        controller: scrollController,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap ?? false,
        padding: padding,
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
        addAutomaticKeepAlives: addAutomaticKeepAlives ?? true,
        addRepaintBoundaries: addRepaintBoundaries ?? true,
        addSemanticIndexes: addSemanticIndexes ?? true,
        children: widgets,
      ),
    );
  }
}
