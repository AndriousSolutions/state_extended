// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This StatefulWidget works with the Fox InheritedWidget.
///

import '/src/another_app/controller_another_app.dart';

import '/src/another_app/view_another_app.dart';

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

// /// Supply an InheritedWidget to a StateX object: InheritedStateX
// class _InheritFoxState extends InheritedStateX<InheritFox, _FoxInherited> {
//   _InheritFoxState()
//       : super(
//           controller: FoxController(),
//           inheritedBuilder: (child) => _FoxInherited(child: child),
//         );
//
//   @override
//   Widget buildIn(context) => widget.child!;
// }
//
// /// The InheritedWidget assigned 'dependent' child widgets.
// class _FoxInherited extends InheritedWidget {
//   const _FoxInherited({Key? key, required Widget child})
//       : super(key: key, child: child);
//   @override
//   bool updateShouldNotify(oldWidget) => true;
// }
