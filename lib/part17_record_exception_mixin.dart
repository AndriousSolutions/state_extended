// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Record an exception
///
/// dartdoc:
/// {@category StateX class}
/// {@category Error handling}
mixin RecordExceptionMixin on State {
  /// Return the 'last' error if any.
  Exception? recordException([Object? error, StackTrace? stack]) {
    // Retrieved the currently recorded exception
    var ex = _recException;
    if (error == null) {
      // Once retrieved, empty this of the exception.
      _recException = null;
      _stackTrace = null;
    } else {
      if (error is! Exception) {
        _recException = Exception(error.toString());
      } else {
        _recException = error;
      }
      // Return the current exception
      ex = _recException;
      _stackTrace = stack;
    }
    return ex;
  }

  // Store the current exception
  Exception? _recException;

  /// Simply display the exception.
  String get errorMsg {
    String message;
    if (_recException == null) {
      message = '';
    } else {
      message = _recException.toString();
      final colon = message.lastIndexOf(': ');
      if (colon > -1 && colon + 2 <= message.length) {
        message = message.substring(colon + 2);
      }
    }
    return message;
  }

  /// Indicate if an exception had occurred.
  bool get hasError => _recException != null;

  /// The StackTrace
  StackTrace? get stackTrace => _stackTrace;
  StackTrace? _stackTrace;

  /// Copy particular properties from the 'previous' StateX
  // ignore: unused_element
  void _copyOverStateException([StateX? oldState]) {
    //
    if (oldState == null) {
      return;
    }
    _recException = oldState._recException;
  }
}