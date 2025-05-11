// Copyright 2025 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  04 Jan 2025
//

import '/src/view.dart';

/// Signature for the common boolean Function implementations.
typedef BooleanFunctionIndicatorCallback = bool? Function();

/// Development tools in Flutter's debug.dart
mixin DebugPaintPrintProfileOptionsMixin {
  /// Highlights UI while debugging.
  bool? debugPaintSizeEnabled;

  /// Returns 'Highlights UI while debugging' boolean indicator.
  bool? onDebugPaintSizeEnabled() => inDebugPaintSizeEnabled?.call() ?? false;

  /// Returns 'Highlights UI while debugging' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPaintSizeEnabled;

  /// Causes each RenderBox to paint a line at each of its baselines.
  bool? debugPaintBaselinesEnabled;

  /// Returns 'to paint a line at each of its baselines' boolean indicator.
  bool? onDebugPaintBaselinesEnabled() =>
      inDebugPaintBaselinesEnabled?.call() ?? false;

  /// Returns 'to paint a line at each of its baselines' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPaintBaselinesEnabled;

  /// Causes objects like 'RenderPointerListener' to flash when tapped.
  bool? debugPaintPointersEnabled;

  /// Returns 'to flash when tapped' boolean indicator.
  bool? onDebugPaintPointersEnabled() =>
      inDebugPaintPointersEnabled?.call() ?? false;

  /// Returns 'to flash when tapped' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPaintPointersEnabled;

  /// Causes each Layer to paint a box around its bounds.
  bool? debugPaintLayerBordersEnabled;

  /// Returns 'to paint a box around its bounds' boolean indicator.
  bool? onDebugPaintLayerBordersEnabled() =>
      inDebugPaintLayerBordersEnabled?.call() ?? false;

  /// Returns 'to paint a box around its bounds' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPaintLayerBordersEnabled;

  /// Overlay a rotating set of colors when repainting layers in debug mode.
  bool? debugRepaintRainbowEnabled;

  /// Returns 'Overlay a rotating set of colors' boolean indicator.
  bool? onDebugRepaintRainbowEnabled() =>
      inDebugRepaintRainbowEnabled?.call() ?? false;

  /// Returns 'Overlay a rotating set of colors' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugRepaintRainbowEnabled;

  /// Overlay a rotating set of colors when repainting text in debug mode.
  bool? debugRepaintTextRainbowEnabled;

  /// Returns 'Overlay a rotating set of colors' boolean indicator.
  bool? onDebugRepaintTextRainbowEnabled() =>
      inDebugRepaintTextRainbowEnabled?.call() ?? false;

  /// Returns 'Overlay a rotating set of colors' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugRepaintTextRainbowEnabled;

  /// Log the dirty widgets that are built each frame.
  bool? debugPrintRebuildDirtyWidgets;

  /// Returns 'Log the dirty widgets that are built each frame' boolean indicator.
  bool? onDebugPrintRebuildDirtyWidgets() =>
      inDebugPrintRebuildDirtyWidgets?.call() ?? false;

  /// Returns 'Log the dirty widgets that are built each frame' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPrintRebuildDirtyWidgets;

  /// Callback invoked for every dirty widget built each frame.
  // ignore: avoid_positional_boolean_parameters
  void Function(Element e, bool builtOnce)? debugOnRebuildDirtyWidget;

  /// Returns 'Callback invoked for every dirty widget built' boolean indicator.
  RebuildDirtyWidgetCallback? onDebugOnRebuildDirtyWidget() =>
      inDebugOnRebuildDirtyWidget;

  /// Callback invoked for every dirty widget built each frame.
  // ignore: avoid_positional_boolean_parameters
  RebuildDirtyWidgetCallback? inDebugOnRebuildDirtyWidget;

  /// Log all calls to [BuildOwner.buildScope].
  bool? debugPrintBuildScope;

  /// Returns 'Highlights UI while debugging' boolean indicator.
  bool? onDebugPrintBuildScope() => inDebugPrintBuildScope?.call() ?? false;

  /// Returns 'Highlights UI while debugging' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPrintBuildScope;

  /// Log the call stacks that mark widgets as needing to be rebuilt.
  bool? debugPrintScheduleBuildForStacks;

  /// Returns 'mark widgets needed to be rebuilt' boolean indicator.
  bool? onDebugPrintScheduleBuildForStacks() =>
      inDebugPrintScheduleBuildForStacks?.call() ?? false;

  /// Returns 'mark widgets needed to be rebuilt' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPrintScheduleBuildForStacks;

  /// Log when widgets with global keys are deactivated and log when they are reactivated (retaken).
  bool? debugPrintGlobalKeyedWidgetLifecycle;

  /// Returns 'when widgets with global keys are deactivate' boolean indicator.
  bool? onDebugPrintGlobalKeyedWidgetLifecycle() =>
      inDebugPrintGlobalKeyedWidgetLifecycle?.call() ?? false;

  /// Returns 'when widgets with global keys are deactivate' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugPrintGlobalKeyedWidgetLifecycle;

  /// Adds 'Timeline' events for every Widget built.
  bool? debugProfileBuildsEnabled;

  /// Returns 'Adds 'Timeline' events' boolean indicator.
  bool? onDebugProfileBuildsEnabled() =>
      inDebugProfileBuildsEnabled?.call() ?? false;

  /// Returns 'Adds 'Timeline' events' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugProfileBuildsEnabled;

  /// Adds 'Timeline' events for every user-created [Widget] built.
  bool? debugProfileBuildsEnabledUserWidgets;

  /// Returns 'Highlights UI while debugging' boolean indicator.
  bool? onDebugProfileBuildsEnabledUserWidgets() =>
      inDebugProfileBuildsEnabledUserWidgets?.call() ?? false;

  /// Returns 'Highlights UI while debugging' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugProfileBuildsEnabledUserWidgets;

  /// Adds debugging information to 'Timeline' events related to [Widget] builds.
  bool? debugEnhanceBuildTimelineArguments;

  /// Returns 'debugging information to 'Timeline' events' boolean indicator.
  bool? onDebugEnhanceBuildTimelineArguments() =>
      inDebugEnhanceBuildTimelineArguments?.call() ?? false;

  /// Returns 'debugging information to 'Timeline' events' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugEnhanceBuildTimelineArguments;

  /// Show banners for deprecated widgets.
  bool? debugHighlightDeprecatedWidgets;

  /// Returns 'Show banners for deprecated widgets' boolean indicator.
  bool? onDebugHighlightDeprecatedWidgets() =>
      inDebugHighlightDeprecatedWidgets?.call() ?? false;

  /// Returns 'Show banners for deprecated widgets' boolean indicator.
  BooleanFunctionIndicatorCallback? inDebugHighlightDeprecatedWidgets;
}