// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/view.dart';

/// Yet another Controller for demonstration purposes.
/// Includes the mixin, StateXonErrorMixin, to supply an error handler
class YetAnotherController extends StateXController
    with StateXonErrorMixin, EventsControllerMixin {
  /// It's practical at times to make Controllers using the Singleton pattern
  factory YetAnotherController() => _this ??= YetAnotherController._();

  YetAnotherController._() : super();
  static YetAnotherController? _this;

  /// Called when its [StateX] object is itself disposed of.
  @override
  void dispose() {
    // Good practice to nullify static instance reference.
    // Flutter's garbage collection does its best, but why not if no longer used
    _this = null;
    super.dispose();
  }
}
