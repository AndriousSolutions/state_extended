// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This StatefulWidget works with the Fox InheritedWidget.
///

import '/another_app/_controller_another_app.dart';

import '/another_app/_view_another_app.dart';

/// This StatefulWidget stores an InheritedWidget
class InheritFox extends StatefulWidget {
  ///
  const InheritFox({Key? key, required this.child}) : super(key: key);

  ///
  final Widget child;

  @override
  State<StatefulWidget> createState() => _InheritFoxState();
}

class _InheritFoxState extends StateX<InheritFox> {
  _InheritFoxState() : super(controller: FoxController(), useInherited: true);

  @override
  Widget builder(context) => widget.child;
}
