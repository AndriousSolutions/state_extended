// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  Stores the InheritedWidget used to update the Cat images.
///

import '/src/another_app/controller.dart';

import '/src/another_app/view.dart';

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

// /// Supply an InheritedWidget to a StateX object: InheritedStateX
// class _InheritCatState extends InheritedStateX<InheritCat, _CatInherited> {
//   _InheritCatState()
//       : super(
//           controller: CatController(),
//           inheritedBuilder: (child) => _CatInherited(child: child),
//         );
//
//   @override
//   Widget buildIn(context) => widget.child!;
// }
//
// /// The InheritedWidget assigned 'dependent' child widgets.
// class _CatInherited extends InheritedWidget {
//   const _CatInherited({Key? key, required Widget child})
//       : super(key: key, child: child);
//   @override
//   bool updateShouldNotify(oldWidget) => true;
// }
