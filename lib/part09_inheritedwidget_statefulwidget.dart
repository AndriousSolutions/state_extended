// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

// Called in AppStateX.buildF()
class _InheritedWidgetStatefulWidget extends StatefulWidget {
  const _InheritedWidgetStatefulWidget();
  @override
  State<StatefulWidget> createState() => _InheritedWidgetState();
}

// Reference this State object in the notifyClients()
class _InheritedWidgetState extends State<_InheritedWidgetStatefulWidget> {
  @override
  void initState() {
    super.initState();
    // Record this State object
    appState = RootState._rootStateX!;
    appState._inheritedState = this;
  }

  late AppStateX appState;

  // App's InheritedWidget
  @override
  Widget build(BuildContext context) => StateXInheritedWidget(
        state: appState,
        child: const _BuilderStatefulWidget(),
      );
}
