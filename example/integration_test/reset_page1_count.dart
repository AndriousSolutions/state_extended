// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

const _location = '========================== reset_page1_count.dart';

Future<void> resetPage1Count(WidgetTester tester) async {
  //
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('New Key')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  expect(find.text('0'), findsAtLeast(1), reason: _location);
}
