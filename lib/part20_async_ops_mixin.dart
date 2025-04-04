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

  /// initAsync() has failed and a 'error' widget instead will be displayed.
  /// This takes in the snapshot.error details.
  void onAsyncError(FlutterErrorDetails details) {}

  ///
  void _initAsyncError(Object e, StateXController con, {StackTrace? stack}) {
    //
    final details = FlutterErrorDetails(
      exception: e,
      stack: stack ?? (e is Error ? e.stackTrace : null),
      library: 'state_extended.dart',
      context: ErrorDescription('${con.runtimeType}.initAsync'),
    );
    try {
      // To cleanup and recover resources.
      con.onAsyncError(details);
    } catch (e) {
      // Record error in log
      _logPackageError(
        e,
        library: 'part18_async_ops_mixin.dart',
        description: 'Exception in ${con.runtimeType}.onAsyncError()',
      );
    }
  }
}
