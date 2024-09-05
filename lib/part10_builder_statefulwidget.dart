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
  Widget build(BuildContext context) => appState.builder(context);
}
