// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'test_controller.dart';
import 'test_statex.dart';

Future<void> unitTesting(WidgetTester tester) async {
//
  /// Tests StateMVC class
  await testsStateX(tester);

  /// Tests ControllerMVC class
  testsController(tester);
}