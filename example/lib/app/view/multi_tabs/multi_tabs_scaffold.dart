//
import 'package:flutter/gestures.dart' show PointerDeviceKind;

// An absolute path is preferred but this source code is copied by other app.
import '/src/view.dart';

///
class MultiTabsScaffold extends StatelessWidget {
  ///
  const MultiTabsScaffold({
    super.key,
    required this.tabs,
    required this.labels,
    this.controller,
    this.initIndex,
    this.appBar,
    this.navigationBar,
    this.persistentFooterButtons,
    this.useMaterial,
    this.useNavigator,
  });

  ///
  final List<WidgetBuilder> tabs;

  ///
  final Map<String, Icon> labels;

  ///
  final TabsScaffoldController? controller;

  ///
  final int? initIndex;

  ///
  final PreferredSizeWidget? appBar;

  ///
  final CupertinoNavigationBar? navigationBar;

  ///
  final List<Widget>? persistentFooterButtons;

  /// Use Material Navigation widgets
  final bool? useMaterial;

  /// Use Navigator so to utilize Routes.
  final bool? useNavigator;

  @override
  Widget build(BuildContext context) => _BottomBarScaffold(widget: this);
}

//
class _BottomBarScaffold extends StatefulWidget {
  const _BottomBarScaffold({required this.widget});

  final MultiTabsScaffold widget;

  @override
  State<StatefulWidget> createState() => _BottomBarScaffoldState();
}

//
class _BottomBarScaffoldState extends State<_BottomBarScaffold> {
  ///
  @override
  void initState() {
    super.initState();
    //
    tabsScaffold = widget.widget;

    // A controller
    con = tabsScaffold.controller;

    // Reference
    con?.tabsScaffold = tabsScaffold;
    //
    con?.initTabsScaffold();

    // Supply the initial index
    // Record the 'current' index
    initIndex = tabsScaffold.initIndex ?? 0;

    // Record the 'current' index
    tabsScaffoldIndex = initIndex;

    barItems = _bottomBarItems();
  }

  late MultiTabsScaffold tabsScaffold;

  //
  late TabsScaffoldController? con;

  // Flag when tabs are switched
  bool? switched;

  late int tabsScaffoldIndex;

  late int initIndex;

  late List<BottomNavigationBarItem> barItems;

  @override
  Widget build(BuildContext context) {
    // Switching tabs
    if (switched ?? false) {
      switched = false;
    } else {
      // tab01 = null;
      // tab02 = null;
    }
    return MyApp.app.useMaterial
        ? _returnScaffold()
        : _returnCupertinoPageScaffold();
  }

  /// Return a Scaffold widget
  Widget _returnScaffold() => Scaffold(
        appBar: tabsScaffold.appBar,
        body: IndexedStack(
          index: tabsScaffoldIndex,
          children: _tabsList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabsScaffoldIndex,
          onTap: (int index) {
            if (tabsScaffoldIndex != index) {
              tabsScaffoldIndex = index;
              switched = true;
              setState(() {});
            }
            // Must be first switched
            if (switched != null) {
              // The initial tab
              if (tabsScaffoldIndex == initIndex) {
                con?.tabSwitchBack();
              } else {
                con?.tabSwitch(index);
              }
            }
          },
          items: barItems,
        ),
        persistentFooterButtons: tabsScaffold.persistentFooterButtons,
      );

  /// Return a CupertinoPageScaffold widget
  Widget _returnCupertinoPageScaffold() => CupertinoPageScaffold(
        navigationBar: tabsScaffold.navigationBar,
        child: SafeArea(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: barItems,
              currentIndex: tabsScaffoldIndex,
              onTap: (index) => tabsScaffoldIndex = index,
            ),
            tabBuilder: (_, index) => CupertinoTabView(
//              onUnknownRoute: AppErrorHandler.onUnknownRoute,
              builder: (_) => _tabWidget(index),
            ),
          ),
        ),
      );

  // Produces the List of Widgets
  List<Widget> _tabsList() {
    // Nothing to produce
    if (tabsScaffold.tabs.isEmpty) {
      return [const SizedBox.shrink()];
    }
    //
    final tabs = <Widget>[];

    var cnt = 0;

    Widget? wid;

    while (cnt < tabsScaffold.tabs.length) {
      //
      try {
        wid = _StackPage(
          key: GlobalObjectKey<_BottomBarScaffoldState>(tabsScaffold.tabs[cnt]),
          child: tabsScaffold.tabs[cnt].call(context),
        );
      } catch (e) {
        wid = const SizedBox.shrink();
      }
      //
      tabs.add(wid);
      //
      cnt++;
    }
    //
    return tabs;
  }

  // Return by index
  Widget _tabWidget(int index) {
    //
    Widget? wid;

    if (tabsScaffold.tabs.isNotEmpty && index < tabsScaffold.tabs.length) {
      try {
        wid = tabsScaffold.tabs[index].call(context);
      } catch (e) {
        wid = null;
      }
    }
    return wid ?? const SizedBox.shrink();
  }

  // Produce the List of BottomNavigationBarItem
  List<BottomNavigationBarItem> _bottomBarItems() {
    //
    const emptyBottomBar = BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: ' ',
    );

    // Nothing to produce
    if (tabsScaffold.labels.isEmpty) {
      return [emptyBottomBar];
    }

    // Crate a List
    final labelList = tabsScaffold.labels.entries.toList(growable: false);

    final bottomBarItems = <BottomNavigationBarItem>[];

    var cnt = 0;

    // Should match the number of tabs
    while (cnt < tabsScaffold.tabs.length) {
      //
      if (cnt >= labelList.length) {
        bottomBarItems.add(emptyBottomBar);
        continue;
      }

      BottomNavigationBarItem item;

      try {
        //
        final label = labelList[cnt];

        item = BottomNavigationBarItem(
          key: GlobalObjectKey<_BottomBarScaffoldState>(label),
          icon: label.value,
          label: label.key,
        );
      } catch (e) {
        item = emptyBottomBar;
      }
      //
      bottomBarItems.add(item);
      //
      cnt++;
    }

    return bottomBarItems;
  }
}

//
class _StackPage extends StatelessWidget {
  const _StackPage({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(_) => child ?? const SizedBox.shrink();
}

///
class BackButtonCupertinoPageScaffold extends StatelessWidget {
  ///
  const BackButtonCupertinoPageScaffold({
    super.key,
    this.title,
    this.child,
  });

  /// Title page
  final String? title;

  /// Displayed widget
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    //
    Widget widget = child ??
        CupertinoButton(
          child: const Text('Press me'),
          onPressed: () => Navigator.of(context).maybePop(),
        );

    if (kIsWeb || MyApp.app.inWindows) {
      widget = ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: widget,
      );
    }

    //
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        middle: Text(title ?? ''),
      ),
      child: SafeArea(
        child: widget,
      ),
    );
  }
}

/// Event handler Controller
mixin TabsScaffoldController on StateXController {
  ///
  int tabsScaffoldIndex = 0;

  ///
  bool switched = false;

  ///
  MultiTabsScaffold? get tabsScaffold => _twoTab;
  set tabsScaffold(MultiTabsScaffold? twoTab) => _twoTab ??= twoTab;
  MultiTabsScaffold? _twoTab;

  ///
  @override
  void deactivate() {
    switched = true;
    deactivateTabsScaffold();
    super.deactivate();
  }

  ///
  @override
  void dispose() {
    _twoTab = null;
    super.dispose();
  }

  ///
  void initTabsScaffold() {}

  ///
  void deactivateTabsScaffold() {}

  ///
  void tabSwitch(int index) {}

  ///
  void tabSwitchBack() {}
}
