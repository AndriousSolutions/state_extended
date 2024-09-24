// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

// Call the AppState's builder() function
class _BuilderStatefulWidget extends StatefulWidget {
  const _BuilderStatefulWidget();
  @override
  State<StatefulWidget> createState() => _BuilderState();
}

// Reference this State object in the buildF()
class _BuilderState extends State<_BuilderStatefulWidget> {
  @override
  void initState() {
    super.initState();
    // Record this State object
    appState = RootState._rootStateX!;
    appState._builderState = this;
  }

  late AppStateX appState;

  @override
  Widget build(BuildContext context) {
    //
    Widget? widget;
    FlutterErrorDetails? errorDetails;

    try {
      widget = appState.builder(context);
    } catch (e) {
      errorDetails = FlutterErrorDetails(
        exception: e,
        stack: e is Error ? e.stackTrace : null,
        library: 'part10_builder_statefulwidget.dart',
        context: ErrorDescription('Error with appState.builder()'),
      );
    }

    // A error
    if (errorDetails != null) {
      //
      try {
        appState.onError(errorDetails);
      } catch (e) {
        // ignore error
      }

      try {
        widget = ErrorWidget.builder(errorDetails);
      } catch (e) {
        // Throw in DebugMode.
        if (kDebugMode) {
          rethrow;
        } else {
          // Record error in log
          _logPackageError(
            e,
            library: 'part10_builder_statefulwidget.dart',
            description: 'Error with ErrorWidget.builder(errorDetails)',
          );
        }
      }
    }

    // Must provide something. Blank then
    widget ??= const SizedBox.shrink();

    return widget;
  }
}
