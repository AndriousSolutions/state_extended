///
import '/src/view.dart';

///
class DevTools extends StateXController {
  /// Singleton Pattern
  factory DevTools() => _this ??= DevTools._();

  DevTools._();

  static DevTools? _this;

  /// Called when it's [StateX] object is itself disposed of.
  @override
  void dispose() {
    // Good practice to nullify static instance reference.
    // Flutter's garbage collection does its best, but why not if no longer used
    _this = null;
    super.dispose();
  }

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
