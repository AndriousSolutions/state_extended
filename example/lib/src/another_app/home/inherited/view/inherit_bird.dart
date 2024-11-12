// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  Contains the InheritedWidget for updating the Bird Image widgets.
///

import '/src/controller.dart';

import '/src/view.dart';

///
class InheritBird extends StatefulWidget {
  ///
  const InheritBird({
    Key? key,
    required this.child,
  }) : super(key: key);

  ///
  final Widget child;

  @override
  State<StatefulWidget> createState() => _InheritBirdState();
}

class _InheritBirdState extends StateX<InheritBird> {
  _InheritBirdState() : super(controller: BirdController(), useInherited: true);

  @override
  Widget builder(context) => widget.child;
}

// /// Supply an InheritedWidget to a StateX object, InheritedStateX
// class _InheritBirdState extends InheritedStateX<InheritBird, _BirdInherited> {
//   _InheritBirdState()
//       : super(
//           controller: BirdController(),
//           inheritedBuilder: (child) => _BirdInherited(child: child),
//         );
//
//   @override
//   Widget buildIn(context) => widget.child!;
// }
//
// /// The InheritedWidget assigned 'dependent' child widgets.
// class _BirdInherited extends InheritedWidget {
//   const _BirdInherited({Key? key, required Widget child})
//       : super(key: key, child: child);
//   @override
//   bool updateShouldNotify(oldWidget) => true;
// }
