// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

/// Yet another Controller for demonstration purposes.
/// Includes the mixin, StateXonErrorMixin, to supply an error handler
class YetAnotherController extends StateXController with StateXonErrorMixin {
  /// It's a good practice to make Controllers using the Singleton pattern
  factory YetAnotherController() => _this ??= YetAnotherController._();
  YetAnotherController._() : super();
  static YetAnotherController? _this;

  /// Supply an error handler
  @override
  void onError(FlutterErrorDetails details) {
    if (inDebugMode) {
      //ignore: avoid_print
      print('############ Event: onError in YetAnotherController for $state');
    }
  }
}
