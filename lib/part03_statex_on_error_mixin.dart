// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Supply an 'error handler' routine if something goes wrong.
/// It need not be implemented, but it's their for your consideration.
///
/// dartdoc:
/// {@category StateX class}
/// {@category Error handling}
mixin StateXonErrorMixin {
  /// Offer an error handler
  void onError(FlutterErrorDetails details) {}

  /// Logs 'every' error as the error count is reset.
  void logErrorDetails(FlutterErrorDetails details) {
    // Don't when in DebugMode.
    if (!kDebugMode) {
      // Resets the count of errors to show a complete error message not an abbreviated one.
      FlutterError.resetErrorCount();
    }
    // https://docs.flutter.dev/testing/errors#errors-caught-by-flutter
    // Log the error.
    FlutterError.presentError(details);
  }
}
