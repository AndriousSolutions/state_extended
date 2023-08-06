// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'test_controller.dart';
import 'test_statex.dart';

Future<void> unitTesting(WidgetTester tester) async {
//
  /// Tests StateX class
  await testsStateX(tester);

  /// Tests StateXController class
  testsController(tester);
}
