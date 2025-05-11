// //
// import '/src/view.dart';
//
// ///
// class DevToolSettingsController extends StateXController {
//   /// Singleton Pattern
//   factory DevToolSettingsController() =>
//       _this ??= DevToolSettingsController._();
//
//   DevToolSettingsController._();
//
//   static DevToolSettingsController? _this;
//
//   @override
//   void initState() {
//     super.initState();
//     _useMaterial3 = MyApp.app.themeData?.useMaterial3 ?? false;
//   }
//
//   ///
//   bool get debugShowCheckedModeBanner => _debugShowCheckedModeBanner;
//   set debugShowCheckedModeBanner(bool? v) {
//     if (v != null) {
//       _debugShowCheckedModeBanner = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugShowCheckedModeBanner = true;
//
//   ///
//   bool get debugShowMaterialGrid => _debugShowMaterialGrid;
//   set debugShowMaterialGrid(bool? v) {
//     if (v != null) {
//       _debugShowMaterialGrid = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugShowMaterialGrid = false;
//
//   ///
//   bool get debugPaintSizeEnabled => _debugPaintSizeEnabled;
//   set debugPaintSizeEnabled(bool? v) {
//     if (v != null) {
//       _debugPaintSizeEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPaintSizeEnabled = false;
//
//   ///
//   bool get debugPaintBaselinesEnabled => _debugPaintBaselinesEnabled;
//   set debugPaintBaselinesEnabled(bool? v) {
//     if (v != null) {
//       _debugPaintBaselinesEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPaintBaselinesEnabled = false;
//
//   ///
//   bool get debugPaintLayerBordersEnabled => _debugPaintLayerBordersEnabled;
//   set debugPaintLayerBordersEnabled(bool? v) {
//     if (v != null) {
//       _debugPaintLayerBordersEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPaintLayerBordersEnabled = false;
//
//   ///
//   bool get debugPaintPointersEnabled => _debugPaintPointersEnabled;
//   set debugPaintPointersEnabled(bool? v) {
//     if (v != null) {
//       _debugPaintPointersEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPaintPointersEnabled = false;
//
//   ///
//   bool get debugRepaintRainbowEnabled => _debugRepaintRainbowEnabled;
//   set debugRepaintRainbowEnabled(bool? v) {
//     if (v != null) {
//       _debugRepaintRainbowEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugRepaintRainbowEnabled = false;
//
//   ///
//   bool get debugRepaintTextRainbowEnabled => _debugRepaintTextRainbowEnabled;
//   set debugRepaintTextRainbowEnabled(bool? v) {
//     if (v != null) {
//       _debugRepaintTextRainbowEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugRepaintTextRainbowEnabled = false;
//
//   ///
//   bool get debugPrintRebuildDirtyWidgets => _debugPrintRebuildDirtyWidgets;
//   set debugPrintRebuildDirtyWidgets(bool? v) {
//     if (v != null) {
//       _debugPrintRebuildDirtyWidgets = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPrintRebuildDirtyWidgets = false;
//
//   ///
//   bool get debugOnRebuildDirtyWidget => _debugOnRebuildDirtyWidget;
//   set debugOnRebuildDirtyWidget(bool? v) {
//     if (v != null) {
//       _debugOnRebuildDirtyWidget = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugOnRebuildDirtyWidget = false;
//
//   ///
//   // ignore: avoid_positional_boolean_parameters
//   void onDebugOnRebuildDirtyWidget(Element e, bool builtOnce) {
//     debugPrint('element: ${e.toStringShort()}  builtOnce: $builtOnce');
//   }
//
//   ///
//   bool get debugPrintBuildScope => _debugPrintBuildScope;
//   set debugPrintBuildScope(bool? v) {
//     if (v != null) {
//       _debugPrintBuildScope = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPrintBuildScope = false;
//
//   ///
//   bool get debugPrintGlobalKeyedWidgetLifecycle =>
//       _debugPrintGlobalKeyedWidgetLifecycle;
//   set debugPrintGlobalKeyedWidgetLifecycle(bool? v) {
//     if (v != null) {
//       _debugPrintGlobalKeyedWidgetLifecycle = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPrintGlobalKeyedWidgetLifecycle = false;
//
//   ///
//   bool get debugPrintScheduleBuildForStacks =>
//       _debugPrintScheduleBuildForStacks;
//   set debugPrintScheduleBuildForStacks(bool? v) {
//     if (v != null) {
//       _debugPrintScheduleBuildForStacks = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugPrintScheduleBuildForStacks = false;
//
//   ///
//   bool get debugProfileBuildsEnabled => _debugProfileBuildsEnabled;
//   set debugProfileBuildsEnabled(bool? v) {
//     if (v != null) {
//       _debugProfileBuildsEnabled = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugProfileBuildsEnabled = false;
//
//   ///
//   bool get debugProfileBuildsEnabledUserWidgets =>
//       _debugProfileBuildsEnabledUserWidgets;
//   set debugProfileBuildsEnabledUserWidgets(bool? v) {
//     if (v != null) {
//       _debugProfileBuildsEnabledUserWidgets = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugProfileBuildsEnabledUserWidgets = false;
//
//   ///
//   bool get debugEnhanceBuildTimelineArguments =>
//       _debugEnhanceBuildTimelineArguments;
//   set debugEnhanceBuildTimelineArguments(bool? v) {
//     if (v != null) {
//       _debugEnhanceBuildTimelineArguments = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugEnhanceBuildTimelineArguments = false;
//
//   ///
//   bool get debugHighlightDeprecatedWidgets => _debugHighlightDeprecatedWidgets;
//   set debugHighlightDeprecatedWidgets(bool? v) {
//     if (v != null) {
//       _debugHighlightDeprecatedWidgets = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _debugHighlightDeprecatedWidgets = false;
//
//   ///
//   bool get showPerformanceOverlay => _showPerformanceOverlay;
//   set showPerformanceOverlay(bool? v) {
//     if (v != null) {
//       _showPerformanceOverlay = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _showPerformanceOverlay = false;
//
//   ///
//   bool get showSemanticsDebugger => _showSemanticsDebugger;
//   set showSemanticsDebugger(bool? v) {
//     if (v != null) {
//       _showSemanticsDebugger = v;
//       MyApp.app.appState?.setState(() {});
//     }
//   }
//
//   //
//   bool _showSemanticsDebugger = false;
//
//   ///
//   bool get useMaterial3 => _useMaterial3;
//   set useMaterial3(bool? v) {
//     if (v != null) {
//       _useMaterial3 = v;
//       final themeData = MyApp.app.themeData;
//       if (themeData != null) {
//         final colorScheme = themeData.colorScheme;
//         MyApp.app.themeData =
//             ThemeData.from(colorScheme: colorScheme, useMaterial3: v);
//         MyApp.app.appState?.setState(() {});
//       }
//     }
//   }
//
//   //
//   bool _useMaterial3 = true;
// }
