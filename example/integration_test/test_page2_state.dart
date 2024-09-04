// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show AppExitResponse;

import 'package:example/src/controller.dart' show Controller;

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

const _location = '========================== test_page2_state.dart';

Future<void> testPage2State(WidgetTester tester) async {
  // Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  // Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Start with the first State object.
  // Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateX>(find.byType(MyApp));

  expect(appState, isA<AppStateX>(), reason: _location);

  // You can retrieve one of the controllers State objects.
  final StateX statePage2 = Controller().stateOf<Page2>()!;

  statePage2.notifyClients();

  statePage2.setState(() {});
}
