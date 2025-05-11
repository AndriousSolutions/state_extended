// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  Stores the InheritedWidget used to update the Cat images.
///

import '/src/controller.dart';

import '/src/view.dart';

/// This StatefulWidget stores an InheritedWidget
class InheritCat extends StatefulWidget {
  ///
  const InheritCat({Key? key, required this.child}) : super(key: key);

  ///
  final Widget child;

  @override
  State<StatefulWidget> createState() => _InheritCatState();
}

class _InheritCatState extends StateX<InheritCat> {
  _InheritCatState() : super(controller: CatController(), useInherited: true);

  @override
  Widget builder(context) => widget.child;
}