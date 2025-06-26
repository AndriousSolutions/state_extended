///
import '/src/view.dart';

///
class DevTools extends StateXController {
  /// Singleton Pattern
  factory DevTools() => _this ??= DevTools._();

  DevTools._();

  static DevTools? _this;

  ///
  @override
  Future<bool> initAsync() async {
    await super.initAsync();
    final settings = await _getPreferences();
    return settings;
  }

  ///
  @override
  Future<void> deactivate() async {
    await _setPreferences();
  }

  /// Device
  @override
  void inactiveAppLifecycleState() {
    _setPreferences();
  }

  /// Called during hot reload.
  @override
  void reassemble() {
    _setPreferences();
  }

  ///
  bool get debugShowCheckedModeBanner => _debugShowCheckedModeBanner ?? true;

  set debugShowCheckedModeBanner(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugShowCheckedModeBanner', v);
      _debugShowCheckedModeBanner = v;
      setSettingState();
    }
  }

  bool? _debugShowCheckedModeBanner;

  ///
  bool get debugShowMaterialGrid => _debugShowMaterialGrid ?? false;

  set debugShowMaterialGrid(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugShowMaterialGrid', v);
      _debugShowMaterialGrid = v;
      setSettingState();
    }
  }

  bool? _debugShowMaterialGrid;

  ///
  bool get debugPaintSizeEnabled => _debugPaintSizeEnabled ?? false;

  set debugPaintSizeEnabled(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugPaintSizeEnabled', v);
      _debugPaintSizeEnabled = v;
      setSettingState();
    }
  }

  bool? _debugPaintSizeEnabled;

  ///
  bool get debugPaintBaselinesEnabled => _debugPaintBaselinesEnabled ?? false;

  set debugPaintBaselinesEnabled(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugPaintBaselinesEnabled', v);
      _debugPaintBaselinesEnabled = v;
      setSettingState();
    }
  }

  bool? _debugPaintBaselinesEnabled;

  ///
  bool get debugPaintLayerBordersEnabled =>
      _debugPaintLayerBordersEnabled ?? false;

  set debugPaintLayerBordersEnabled(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugPaintLayerBordersEnabled', v);
      _debugPaintLayerBordersEnabled = v;
      setSettingState();
    }
  }

  bool? _debugPaintLayerBordersEnabled;

  ///
  bool get debugPaintPointersEnabled => _debugPaintPointersEnabled ?? false;

  set debugPaintPointersEnabled(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugPaintPointersEnabled', v);
      _debugPaintPointersEnabled = v;
      setSettingState();
    }
  }

  bool? _debugPaintPointersEnabled;

  ///
  bool get debugRepaintRainbowEnabled => _debugRepaintRainbowEnabled ?? false;

  set debugRepaintRainbowEnabled(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugRepaintRainbowEnabled', v);
      _debugRepaintRainbowEnabled = v;
      setSettingState();
    }
  }

  bool? _debugRepaintRainbowEnabled;

  ///
  bool get debugRepaintTextRainbowEnabled =>
      _debugRepaintTextRainbowEnabled ?? false;

  set debugRepaintTextRainbowEnabled(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('debugRepaintTextRainbowEnabled', v);
      _debugRepaintTextRainbowEnabled = v;
      setSettingState();
    }
  }

  bool? _debugRepaintTextRainbowEnabled;

  ///
  bool get showPerformanceOverlay => _showPerformanceOverlay ?? false;

  set showPerformanceOverlay(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('showPerformanceOverlay', v);
      _showPerformanceOverlay = v;
      setSettingState();
    }
  }

  bool? _showPerformanceOverlay;

  ///
  bool get showSemanticsDebugger => _showSemanticsDebugger ?? false;

  set showSemanticsDebugger(bool? v) {
    //
    if (v != null) {
      //
      MyApp.prefs.setBool('showSemanticsDebugger', v);
      _showSemanticsDebugger = v;
      setSettingState();
    }
  }

  bool? _showSemanticsDebugger;

  /// Call the setState() functions
  void setSettingState() {
    // Update this StatefulWidget
    setState(() {});
    // Update the whole app
    appStateX?.setState(() {});
  }

  ///
  Future<bool> _getPreferences() async {
    //
    var preferences = true;

    /// Any error will be caught and returns false;
    try {
      // Access the device's persistent store
      final prefs = MyApp.prefs;

      _debugShowCheckedModeBanner =
          await prefs.getBool('debugShowCheckedModeBanner') ?? true;

      _debugShowMaterialGrid =
          await prefs.getBool('debugShowMaterialGrid') ?? false;

      _debugPaintSizeEnabled =
          await prefs.getBool('debugPaintSizeEnabled') ?? false;

      _debugPaintBaselinesEnabled =
          await prefs.getBool('debugPaintBaselinesEnabled') ?? false;

      _debugPaintLayerBordersEnabled =
          await prefs.getBool('debugPaintLayerBordersEnabled') ?? false;

      _debugPaintPointersEnabled =
          await prefs.getBool('debugPaintPointersEnabled') ?? false;

      _debugRepaintRainbowEnabled =
          await prefs.getBool('debugRepaintRainbowEnabled') ?? false;

      _debugRepaintTextRainbowEnabled =
          await prefs.getBool('debugRepaintTextRainbowEnabled') ?? false;

      _showPerformanceOverlay =
          await prefs.getBool('showPerformanceOverlay') ?? false;

      _showSemanticsDebugger =
          await prefs.getBool('showSemanticsDebugger') ?? false;
      //
    } catch (e) {
      preferences = false;
    }
    return preferences;
  }

  ///
  Future<bool> _setPreferences() async {
    //
    var set = true;

    /// Any error will be caught and returns false;
    try {
      // Access the device's persistent store
      final prefs = MyApp.prefs;

      await prefs.setBool(
          'debugShowCheckedModeBanner', _debugShowCheckedModeBanner!);

      await prefs.setBool('debugShowMaterialGrid', _debugShowMaterialGrid!);

      await prefs.setBool('_debugPaintSizeEnabled', _debugPaintSizeEnabled!);

      await prefs.setBool(
          '_debugPaintBaselinesEnabled', _debugPaintBaselinesEnabled!);

      await prefs.setBool(
          '_debugPaintLayerBordersEnabled', _debugPaintLayerBordersEnabled!);

      await prefs.setBool(
          'debugPaintPointersEnabled', _debugPaintPointersEnabled!);

      await prefs.setBool(
          'debugRepaintRainbowEnabled', _debugRepaintRainbowEnabled!);

      await prefs.setBool(
          'debugRepaintTextRainbowEnabled', _debugRepaintTextRainbowEnabled!);

      await prefs.setBool('showPerformanceOverlay', _showPerformanceOverlay!);

      await prefs.setBool('showSemanticsDebugger', _showSemanticsDebugger!);
      //
    } catch (e) {
      set = false;
    }
    return set;
  }
}

///
class DevToolsSettings extends StatefulWidget {
  ///
  const DevToolsSettings({super.key});

  @override
  State createState() => _DevToolsSettingsState();
}

///
class _DevToolsSettingsState extends StateX<DevToolsSettings> {
  //
  _DevToolsSettingsState() : super(controller: DevTools()) {
    con = controller as DevTools;
  }

  //
  late DevTools con;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: devSettings,
      );

  ///
  List<Widget> get devSettings {
    final List<Widget> widgets = <Widget>[
      ListTile(
        leading: const Icon(Icons.bug_report),
        title: const Text('Show DEBUG banner'),
        onTap: () {
          con.debugShowCheckedModeBanner = !con.debugShowCheckedModeBanner;
        },
        trailing: Switch(
          value: con.debugShowCheckedModeBanner,
          onChanged: (bool value) {
            con.debugShowCheckedModeBanner = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.picture_in_picture),
        title: const Text('Show rendering performance overlay'),
        onTap: () {
          con.showPerformanceOverlay = !con.showPerformanceOverlay;
        },
        trailing: Switch(
          value: con.showPerformanceOverlay,
          onChanged: (bool value) {
            con.showPerformanceOverlay = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.accessibility),
        title: const Text('Show accessibility information'),
        onTap: () {
          con.showSemanticsDebugger = !con.showSemanticsDebugger;
        },
        trailing: Switch(
          value: con.showSemanticsDebugger,
          onChanged: (bool value) {
            con.showSemanticsDebugger = value;
          },
        ),
      ),
    ];
    // An approach to determine if running in your IDE or not is the assert()
    // i.e. When your in your Debugger or not.
    // The compiler removes assert functions and their content when in Production.
    assert(() {
      // material grid and size construction lines are only available in checked mode
      widgets.addAll(<Widget>[
        // Don't show the material grid if running in the Cupertino interface
        ListTile(
          leading: const Icon(Icons.border_clear),
          title: const Text('Show material grid'),
          onTap: () {
            con.debugShowMaterialGrid = !con.debugShowMaterialGrid;
          },
          trailing: Switch(
            value: con.debugShowMaterialGrid,
            onChanged: (bool value) {
              con.debugShowMaterialGrid = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.border_all),
          title: const Text('Paint construction lines'),
          onTap: () {
            con.debugPaintSizeEnabled = !con.debugPaintSizeEnabled;
          },
          trailing: Switch(
            value: con.debugPaintSizeEnabled,
            onChanged: (bool value) {
              con.debugPaintSizeEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_color_text),
          title: const Text('Show character baselines'),
          onTap: () {
            con.debugPaintBaselinesEnabled = !con.debugPaintBaselinesEnabled;
          },
          trailing: Switch(
            value: con.debugPaintBaselinesEnabled,
            onChanged: (bool value) {
              con.debugPaintBaselinesEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.filter_none),
          title: const Text('Highlight layer boundaries'),
          onTap: () {
            con.debugPaintLayerBordersEnabled =
                !con.debugPaintLayerBordersEnabled;
          },
          trailing: Switch(
            value: con.debugPaintLayerBordersEnabled,
            onChanged: (bool value) {
              con.debugPaintLayerBordersEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mouse),
          title: const Text('Flash interface taps'),
          onTap: () {
            con.debugPaintPointersEnabled = !con.debugPaintPointersEnabled;
          },
          trailing: Switch(
            value: con.debugPaintPointersEnabled,
            onChanged: (bool value) {
              con.debugPaintPointersEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.gradient),
          title: const Text('Highlight repainted layers'),
          onTap: () {
            con.debugRepaintRainbowEnabled = !con.debugRepaintRainbowEnabled;
          },
          trailing: Switch(
            value: con.debugRepaintRainbowEnabled,
            onChanged: (bool value) {
              con.debugRepaintRainbowEnabled = value;
            },
          ),
        ),
      ]);
      return true;
    }());

    return widgets;
  }
}
