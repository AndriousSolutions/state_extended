// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

class TestStateController extends StateXController with EventsControllerMixin {
  factory TestStateController() => _this ??= TestStateController._();
  TestStateController._();
  static TestStateController? _this;
}
