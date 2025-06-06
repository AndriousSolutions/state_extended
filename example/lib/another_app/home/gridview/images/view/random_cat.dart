// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This widget works with the free Cat API.
///

import '/src/controller.dart';

import '/src/view.dart';

///
class RandomCat extends StatefulWidget {
  ///
  const RandomCat({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RandomCatState();
}

class _RandomCatState extends ImageAPIStateX<RandomCat> {
  _RandomCatState()
      : super(
          controller: CatController.count(),
          message: 'message',
          uri: Uri(
            scheme: 'https',
            host: 'api.sefinek.net',
            path: 'api/v2/random/animal/cat',
          ),
        );

  /// Supply a 'splash screen' while the FutureBuilder is processing.
  @override
  Widget? onSplashScreen(BuildContext context) {
    // Return if possibly running in Testing
    if (WidgetsBinding.instance is! WidgetsFlutterBinding) {
      return null;
    }
    return const SplashScreen();
  }
}
