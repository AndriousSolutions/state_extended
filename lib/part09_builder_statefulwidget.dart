// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

// Call the AppState's builder() function
class _BuilderStatefulWidget extends StatefulWidget {
  const _BuilderStatefulWidget(this.appState);
  final AppStateX appState;
  @override
  State<StatefulWidget> createState() => _BuilderState();
}

// Reference this State object in the buildF()
class _BuilderState extends State<_BuilderStatefulWidget> {
  //
  @override
  void initState() {
    super.initState();
    appState = widget.appState;
    appState._builderState = this; // nullified in AppStateX dispose()
  }
  // Will never be null
  late AppStateX appState;

  //
  @override
  Widget build(BuildContext context) => appState.builder(context);
}
