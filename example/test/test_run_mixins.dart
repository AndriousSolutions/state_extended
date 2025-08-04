// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

// ignore: unused_element
const _location = '========================== test_run_mixins.dart';

Future<void> testRunMixins(WidgetTester tester) async {
  //
  final testMixins = _TestMixins();

  final details = FlutterErrorDetails(
    exception: Exception('fake exception'),
    library: 'test_run_mixins.dart',
    context: ErrorDescription('Used for testing.'),
  );

  testMixins.onAsyncError(details);

  testMixins.detachedAppLifecycleState();

  testMixins.onError(details);

  testMixins.logErrorDetails(details);

  final testStateMixins =
      _TestStateMixins(runAsync: true, useInherited: true, printEvents: true);

  await testStateMixins.initAsync();

  // Find its StatefulWidget first then the 'type' of State object.
  final AppStateX? appState = tester.firstState<AppStateX>(find.byType(MyApp));

  final context = appState?.context;

  if (context != null) {
    //
    testStateMixins.buildF(context);

//    testStateMixins.builder(context);
  }
}

/// Supply the Mixins using this class
class _TestMixins with AsyncOps, StateXEventHandlers, StateXonErrorMixin {
  // Merely call the mixin's functions and methods to satisfy CodeCov
}

/// Supply the Mixins using this class
class _TestStateMixins extends StateX {
  _TestStateMixins({
    // ignore: unused_element_parameter
    super.controller,
    super.runAsync,
    super.useInherited,
    super.printEvents,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
