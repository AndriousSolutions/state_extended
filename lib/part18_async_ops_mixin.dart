// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Supply the Async API
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin AsyncOps {
  /// Initialize any 'time-consuming' operations at the beginning.
  /// Implement any asynchronous operations needed done at start up.
  Future<bool> initAsync() async => true;

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding runAsync() routine.
  void onAsyncError(FlutterErrorDetails details) {}

  ///
  void _initAsyncError(Object e, StateXController con) {
    //
    final details = FlutterErrorDetails(
      exception: e,
      stack: e is Error ? e.stackTrace : null,
      library: 'state_extended.dart',
      context: ErrorDescription('${con.runtimeType}.initAsync'),
    );
    // To cleanup and recover resources.
    con.onAsyncError(details);
  }
}
