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

  final appCon = appState.controller;

  if (appCon != null && appCon is AppController) {
    // Allow for errors to be thrown.
    appCon.allowErrors = true;
  }

  final con = AnotherController();

  con.tripError = true;

  // hot reload
  await binding.reassembleApplication();

  // pumpAndSettle() waits for all animations to complete.
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();
}
