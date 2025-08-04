// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This widget works with the free Bird API.
///

import '/src/controller.dart';

import '/src/view.dart';

///
class RandomBird extends StatefulWidget {
  ///
  const RandomBird({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RandomBirdState();
}

class _RandomBirdState extends ImageAPIStateX<RandomBird> {
  _RandomBirdState()
      : super(
          controller: BirdController.count(),
          message: 'message',
          uri: Uri(
            scheme: 'https',
            host: 'api.sefinek.net',
            path: 'api/v2/random/animal/bird',
          ),
        );

  /// Place a breakpoint on this build() function and see how things work.
  @override
  // ignore: unnecessary_overrides
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  // ignore: unnecessary_overrides
  Widget buildF(BuildContext context) => super.buildF(context);

  @override
  // ignore: unnecessary_overrides
  Widget builder(context) => super.builder(context);
}
