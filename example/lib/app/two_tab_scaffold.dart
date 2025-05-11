//
import 'package:flutter/gestures.dart' show PointerDeviceKind;

// An absolute path is preferred but this source code is copied by other app.
import '/src/view.dart';

///
// class TwoTabScaffold extends StatefulWidget {
class TwoTabScaffold extends StatelessWidget {
  ///
  const TwoTabScaffold({
    super.key,
    required this.tab01,
    this.tab01Label,
    required this.tab02,
    this.tab02Label,
    this.controller,
    this.initIndex,
    this.appBar,
    this.navigationBar,
    this.persistentFooterButtons,
    this.useMaterial,
    this.useNavigator,
  });

  ///
  final WidgetBuilder tab01, tab02;

  ///
  final Map<String, Icon>? tab01Label, tab02Label;

  ///
  final TwoTabScaffoldController? controller;

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

  final TwoTabScaffold widget;

  @override
  State<StatefulWidget> createState() => _BottomBarScaffoldState();
}

//
class _BottomBarScaffoldState extends State<_BottomBarScaffold> {
  //
  late TwoTabScaffold twoTab;

  @override
  void initState() {
    super.initState();
    twoTab = widget.widget;
    // A controller
    con = twoTab.controller;
    //
    con?.twoTab = twoTab;
    //
    con?.initTwoTab();
    //
    globalKeys = {
      0: GlobalKey<_BottomBarScaffoldState>(debugLabel: 'StackIndex01'),
      1: GlobalKey<_BottomBarScaffoldState>(debugLabel: 'StackIndex02'),
      2: GlobalKey<_BottomBarScaffoldState>(debugLabel: 'BarItem01'),
      3: GlobalKey<_BottomBarScaffoldState>(debugLabel: 'BarItem02'),
    };

    // Supply the initial index
    initIndex = twoTab.initIndex ?? 0;

    // Record the 'current' index
    currentIndex = initIndex;

    final label01 = twoTab.tab01Label;
    if (label01 != null && label01.isNotEmpty) {
      tab01Label = label01;
    }

    final label02 = twoTab.tab02Label;
    if (label02 != null && label02.isNotEmpty) {
      tab02Label = label02;
    }
  }

  ///
  late TwoTabScaffoldController? con;

  late int initIndex;

  late int currentIndex;

  Map<int, GlobalKey>? globalKeys;

  // Flag when tabs are switched
  bool? switched;

  Widget? tab01, tab02;
  Map<String, Icon>? tab01Label, tab02Label;

  @override
  void dispose() {
    con?.disposeTwoTab();
    globalKeys = null;
    tab01 = null;
    tab02 = null;
    super.dispose();
  }

  @override
  void deactivate() {
    // Don't build if and when returning
    switched = true;
    con?.deactivateTwoTab();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // Switching tabs
    if (switched ?? false) {
      switched = false;
    } else {
      tab01 = null;
      tab02 = null;
    }
    return MyApp.app.useMaterial
        ? _returnScaffold()
        : _returnCupertinoPageScaffold();
  }

  /// Return a Scaffold widget
  Widget _returnScaffold() => Scaffold(
        appBar: twoTab.appBar,
        body: IndexedStack(
          index: currentIndex,
          children: <Widget>[
            _StackPage(
              key: globalKeys![0]!,
              child: tab01 ??= twoTab.tab01(context),
            ),
            _StackPage(
              key: globalKeys![1]!,
              child: tab02 ??= twoTab.tab02(context),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            if (currentIndex != index) {
              currentIndex = index;
              switched = true;
              setState(() {});
            }
            // Must be first switched
            if (switched != null) {
              // The initial tab
              if (currentIndex == initIndex) {
                con?.switchBackTwoTab();
              } else {
                con?.switchTwoTab();
              }
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              key: globalKeys![2]!,
              icon: tab01Label?.values.last ?? const Icon(Icons.home),
              label: tab01Label?.keys.last ?? 'Home',
            ),
            BottomNavigationBarItem(
              key: globalKeys![3]!,
              icon: tab02Label?.values.last ?? const Icon(Icons.settings),
              label: tab02Label?.keys.last ?? 'Settings',
            ),
          ],
        ),
        persistentFooterButtons: twoTab.persistentFooterButtons,
      );

  /// Return a CupertinoPageScaffold widget
  Widget _returnCupertinoPageScaffold() => CupertinoPageScaffold(
        navigationBar: twoTab.navigationBar,
        child: SafeArea(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  key: globalKeys![2]!,
                  icon: tab01Label?.values.last ??
                      const Icon(CupertinoIcons.home),
                  label: tab01Label?.keys.last ?? 'Home',
                ),
                BottomNavigationBarItem(
                  key: globalKeys![3]!,
                  icon: tab02Label?.values.last ??
                      const Icon(CupertinoIcons.settings),
                  label: tab02Label?.keys.last ?? 'Settings',
                ),
              ],
              currentIndex: currentIndex,
              onTap: (index) => currentIndex = index,
            ),
            tabBuilder: (_, index) => CupertinoTabView(
//              onUnknownRoute: AppErrorHandler.onUnknownRoute,
              builder: (context) => index == 0
                  ? tab01 ??= twoTab.tab01(context)
                  : tab02 ??= twoTab.tab02(context),
            ),
          ),
        ),
      );
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
mixin class TwoTabScaffoldController {
  /// TwoTabScaffold object
  TwoTabScaffold? get twoTab => _twoTab;
  set twoTab(TwoTabScaffold? twoTab) => _twoTab ??= twoTab;
  TwoTabScaffold? _twoTab;

  ///
  void initTwoTab() {}

  ///
  void disposeTwoTab() {}

  ///
  void deactivateTwoTab() {}

  ///
  void switchTwoTab() {}

  ///
  void switchBackTwoTab() {}
}