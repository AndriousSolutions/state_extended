// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import '_test_imports.dart';

Future<void> unitTesting(WidgetTester tester) async {
//
  /// Tests AppStateX class
  await testsAppStateX(tester);

  /// Tests StateX class
  await testsStateX(tester);

  /// Tests StateXController class
  testsStateXController(tester);
}
