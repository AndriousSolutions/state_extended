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

// App's InheritedWidget
// Every time it's called, its dependencies are rebuilt.
class _InheritedWidgetState extends State<_InheritedWidgetStatefulWidget> {
  @override
  void initState() {
    super.initState();
    // Reference this State object so to call in the notifyClients()
    AppStateX._instance?._inheritedState = this;
  }

  @override
  Widget build(BuildContext context) => StateXInheritedWidget(
      state: AppStateX._instance!, child: const _BuilderStatefulWidget());
}
