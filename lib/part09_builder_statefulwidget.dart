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
  //
  @override
  void initState() {
    super.initState();
    appState = context.findAncestorStateOfType<AppStateX>();
    appState?._builderState = this; // nullified in AppStateX dispose()
  }

  // Will never be null
  AppStateX? appState;

  //
  @override
  Widget build(BuildContext context) =>
      appState?.builder(context) ?? const SizedBox.shrink();

  @override
  void dispose() {
    appState = null;
    super.dispose();
  }
}
