// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

// ignore: unused_element
const _location = '========================== test_example_app.dart';

Future<void> testInheritedWidgetApp(WidgetTester tester) async {
  /// Go to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  /// InheritedWidget example
  await tester.tap(find.byKey(const Key('InheritedWidget example')));
  await tester.pumpAndSettle(const Duration(seconds: 3));

  /// New Dogs
  await tester.tap(find.byKey(const Key('New Dogs')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  /// New Cats
  await tester.tap(find.byKey(const Key('New Cats')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  /// New Foxes
  await tester.tap(find.byKey(const Key('New Foxes')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  /// New Birds
  await tester.tap(find.byKey(const Key('New Birds')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  /// Press the 'back button'
  await tester.tap(find.byType(IconButton));
  await tester.pumpAndSettle();
}
