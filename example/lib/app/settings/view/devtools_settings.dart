// //
// import '/src/controller.dart';
// //
// import '/src/view.dart';
//
// ///
// class DevSettingsDrawer extends AppDrawer {
//   ///
//   DevSettingsDrawer({super.key}) {
//     if (MyApp.app.useMaterial) {
//       add(const DevToolsSettings.column(key: Key('DevToolsSettings')));
//     } else {
//       add(const DevToolsSettings.disabled(key: Key('DevToolsSettings')));
//     }
//   }
// }
//
// ///
// class DevToolsSettings extends StatefulWidget {
//   /// Provide the Dev Tool options in a ListView
//   const DevToolsSettings({super.key, this.shrinkWrap})
//       : column = false,
//         useAssert = true;
//
//   /// Wrap the options in a Column
//   const DevToolsSettings.column({super.key, this.shrinkWrap})
//       : column = true,
//         useAssert = true;
//
//   /// Only disable those options not available
//   const DevToolsSettings.disabled({super.key, this.shrinkWrap})
//       : column = true,
//         useAssert = false;
//
//   ///
//   final bool? shrinkWrap;
//
//   /// Wrap the options in a Column
//   final bool column;
//
//   /// Use assert to remove options only available during development.
//   final bool useAssert;
//
//   @override
//   State createState() => _DevToolsSettingsState();
// }
//
// ///
// class _DevToolsSettingsState extends State<DevToolsSettings> {
//   _DevToolsSettingsState() {
//     con = DevToolSettingsController();
//   }
//
//   late DevToolSettingsController con;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget wid;
//     if (widget.column) {
//       wid = Column(
//         children: devSettings,
//       );
//     } else {
//       wid = ListView(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         shrinkWrap: widget.shrinkWrap ?? false,
//         children: devSettings,
//       );
//     }
//     return wid;
//   }
//
//   ///
//   List<Widget> get devSettings {
//     //
//     final isPhone = MediaQuery.of(context).size.shortestSide < 600;
//
//     final isSmall = isPhone && !kIsWeb;
//
//     // Disable if running in Cupertino
//     final disable = MyApp.app.useCupertino;
//
//     final tip = disable ? 'Enabled in Material Design' : '';
//
//     final List<Widget> widgets = <Widget>[
//       listTile(
//         key: const Key('overlay'),
//         leading: isSmall ? null : const Icon(Icons.picture_in_picture),
//         title: isSmall
//             ? const Text('Perform overlay')
//             : const Text('Show rendering performance overlay'),
//         onTap: () {
//           con.showPerformanceOverlay = !con.showPerformanceOverlay;
//           setState(() {});
//         },
//         value: con.showPerformanceOverlay,
//         onChanged: (bool value) {
//           con.showPerformanceOverlay = value;
//           setState(() {});
//         },
//       ),
//       listTile(
//         key: const Key('accessibility'),
//         leading: isSmall ? null : const Icon(Icons.accessibility),
//         title: isSmall
//             ? const Text('Access')
//             : const Text('Show accessibility information'),
//         onTap: () {
//           con.showSemanticsDebugger = !con.showSemanticsDebugger;
//           setState(() {});
//         },
//         value: con.showSemanticsDebugger,
//         onChanged: (bool value) {
//           con.showSemanticsDebugger = value;
//           setState(() {});
//         },
//       ),
//       listTile(
//         key: const Key('banner'),
//         leading: isSmall ? null : const Icon(Icons.bug_report),
//         title: isSmall ? const Text('DEBUG banner') : const Text('Show DEBUG banner'),
//         onTap: () {
//           con.debugShowCheckedModeBanner = !con.debugShowCheckedModeBanner;
//           setState(() {});
//         },
//         value: con.debugShowCheckedModeBanner,
//         onChanged: (bool value) {
//           con.debugShowCheckedModeBanner = value;
//           setState(() {});
//         },
//       ),
//       if (MyApp.app.useMaterial)
//         listTile(
//           key: const Key('material 3'),
//           leading:
//               isSmall ? null : const Icon(Icons.screen_lock_landscape_sharp),
//           title: isSmall
//               ? const Text('Material 3')
//               : const Text('Use Material 3 Design'),
//           onTap: () {
//             con.useMaterial3 = !con.useMaterial3;
//             setState(() {});
//           },
//           value: con.useMaterial3,
//           onChanged: (bool value) {
//             con.useMaterial3 = value;
//             setState(() {});
//           },
//         ),
//       listTile(
//         key: const Key('grid'),
//         leading: isSmall ? null : const Icon(Icons.border_clear),
//         title:
//             isSmall ? const Text('Material grid') : const Text('Show material grid'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugShowMaterialGrid = !con.debugShowMaterialGrid;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugShowMaterialGrid,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugShowMaterialGrid = value;
//                 setState(() {});
//               },
//       ),
//     ];
//
//     // An approach to determine if running in your IDE or not is the assert()
//     // i.e. When your in your Debugger or not.
//     if (widget.useAssert) {
//       // The compiler removes assert functions and their content when in Production.
//       assert(() {
//         devToolsOptions(widgets);
//         return true;
//       }());
//     } else {
//       devToolsOptions(widgets);
//     }
//     return widgets;
//   }
//
//   /// Supply those Dev tools available only during Development
//   void devToolsOptions(List<Widget> widgets) {
//     //
//     final isPhone = MediaQuery.of(context).size.shortestSide < 600;
//
//     final isSmall = isPhone && !kIsWeb;
//
//     // Disable if running in Production
//     const disable = kReleaseMode;
//
//     const tip = disable ? 'Only in Development' : '';
//
//     // material grid and size construction lines are only available in checked mode
//     widgets.addAll(<Widget>[
//       listTile(
//           key: const Key('construction'),
//           leading: isSmall ? null : const Icon(Icons.border_all),
//           title: isSmall
//               ? const Text('Construct lines')
//               : const Text('Paint construction lines'),
//           onTap: disable
//               ? null
//               : () {
//                   con.debugPaintSizeEnabled = !con.debugPaintSizeEnabled;
//                   setState(() {});
//                 },
//           tip: tip,
//           value: con.debugPaintSizeEnabled,
//           onChanged: disable
//               ? null
//               : (bool value) {
//                   con.debugPaintSizeEnabled = value;
//                   setState(() {});
//                 }),
//       listTile(
//         key: const Key('baselines'),
//         leading: isSmall ? null : const Icon(Icons.format_color_text),
//         title: isSmall
//             ? const Text('Character baselines')
//             : const Text('Show character baselines'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPaintBaselinesEnabled =
//                     !con.debugPaintBaselinesEnabled;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPaintBaselinesEnabled,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPaintBaselinesEnabled = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('taps'),
//         leading: isSmall ? null : const Icon(Icons.mouse),
//         title:
//             isSmall ? const Text('Flash taps') : const Text('Flash interface taps'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPaintPointersEnabled = !con.debugPaintPointersEnabled;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPaintPointersEnabled,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPaintPointersEnabled = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('lines'),
//         leading: isSmall ? null : const Icon(Icons.filter_none),
//         title: isSmall
//             ? const Text('Boundary lines')
//             : const Text('Highlight layer boundaries'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPaintLayerBordersEnabled =
//                     !con.debugPaintLayerBordersEnabled;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPaintLayerBordersEnabled,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPaintLayerBordersEnabled = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('layers'),
//         leading: isSmall ? null : const Icon(Icons.gradient),
//         title: isSmall
//             ? const Text('Highlight layers')
//             : const Text('Highlight repainted layers'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugRepaintRainbowEnabled =
//                     !con.debugRepaintRainbowEnabled;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugRepaintRainbowEnabled,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugRepaintRainbowEnabled = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('colors'),
//         leading: isSmall ? null : const Icon(Icons.vignette),
//         title: isSmall
//             ? const Text('Color text')
//             : const Text('Rotating colors repainting text'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugRepaintTextRainbowEnabled =
//                     !con.debugRepaintTextRainbowEnabled;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugRepaintTextRainbowEnabled,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugRepaintTextRainbowEnabled = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('dirty'),
//         leading: isSmall ? null : const Icon(Icons.dirty_lens),
//         title: isSmall
//             ? const Text('Log dirty widgets')
//             : const Text('Log dirty widgets rebuilt'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPrintRebuildDirtyWidgets =
//                     !con.debugPrintRebuildDirtyWidgets;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPrintRebuildDirtyWidgets,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPrintRebuildDirtyWidgets = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('callback'),
//         leading: isSmall ? null : const Icon(Icons.dirty_lens_rounded),
//         title: isSmall
//             ? const Text('Callback for every rebuild')
//             : const Text('Callback called for every dirty widget rebuilt'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugOnRebuildDirtyWidget = !con.debugOnRebuildDirtyWidget;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugOnRebuildDirtyWidget,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugOnRebuildDirtyWidget = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('scope'),
//         leading: isSmall ? null : const Icon(Icons.arrow_circle_right_outlined),
//         title: isSmall
//             ? const Text('Log Scope')
//             : const Text('Log to BuildOwner.buildScope'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPrintBuildScope = !con.debugPrintBuildScope;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPrintBuildScope,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPrintBuildScope = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('rebuilds'),
//         leading: isSmall ? null : const Icon(Icons.update),
//         title: isSmall
//             ? const Text('Log widget rebuilds')
//             : const Text('Log call stacks marking widgets to rebuild'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPrintScheduleBuildForStacks =
//                     !con.debugPrintScheduleBuildForStacks;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPrintScheduleBuildForStacks,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPrintScheduleBuildForStacks = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('global'),
//         leading: isSmall ? null : const Icon(Icons.language),
//         title: isSmall
//             ? const Text("Log widget's global keys")
//             : const Text(
//                 'Log widgets with global keys when deactivated and reactivated'
//                     ),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugPrintGlobalKeyedWidgetLifecycle =
//                     !con.debugPrintGlobalKeyedWidgetLifecycle;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugPrintGlobalKeyedWidgetLifecycle,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugPrintGlobalKeyedWidgetLifecycle = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('build'),
//         leading: isSmall ? null : const Icon(Icons.location_history_outlined),
//         title: isSmall
//             ? const Text("'Timeline' for every build")
//             : const Text("Adds 'Timeline' events for every Widget build"),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugProfileBuildsEnabled = !con.debugProfileBuildsEnabled;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugProfileBuildsEnabled,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugProfileBuildsEnabled = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('timeline'),
//         leading: isSmall ? null : const Icon(Icons.foundation),
//         title: isSmall
//             ? const Text("'Timeline' for every user build")
//             : const Text("Adds 'Timeline' for every user-created [Widget] built"),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugProfileBuildsEnabledUserWidgets =
//                     !con.debugProfileBuildsEnabledUserWidgets;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugProfileBuildsEnabledUserWidgets,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugProfileBuildsEnabledUserWidgets = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('debugging'),
//         leading: isSmall ? null : const Icon(Icons.view_timeline),
//         title: isSmall
//             ? const Text('Debug info.')
//             : const Text("Adds debugging info. to 'Timeline' related to Widget builds"
//                 ),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugEnhanceBuildTimelineArguments =
//                     !con.debugEnhanceBuildTimelineArguments;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugEnhanceBuildTimelineArguments,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugEnhanceBuildTimelineArguments = value;
//                 setState(() {});
//               },
//       ),
//       listTile(
//         key: const Key('deprecated'),
//         leading: isSmall ? null : const Icon(Icons.wrong_location),
//         title: isSmall
//             ? const Text('Deprecate widgets')
//             : const Text('Show banners for deprecated widgets'),
//         onTap: disable
//             ? null
//             : () {
//                 con.debugHighlightDeprecatedWidgets =
//                     !con.debugHighlightDeprecatedWidgets;
//                 setState(() {});
//               },
//         tip: tip,
//         value: con.debugHighlightDeprecatedWidgets,
//         onChanged: disable
//             ? null
//             : (bool value) {
//                 con.debugHighlightDeprecatedWidgets = value;
//                 setState(() {});
//               },
//       ),
//     ]);
//   }
// }
