// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

Future<void> errorHandling(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
) async {
  // Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateX>(find.byType(MyApp));

  // ignore: unused_local_variable
  final appCon = appState.controller;

  final con = AnotherController();

  con.initAsyncError = true;

  // hot reload
  await binding.reassembleApplication();

  // pumpAndSettle() waits for all animations to complete.
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}
