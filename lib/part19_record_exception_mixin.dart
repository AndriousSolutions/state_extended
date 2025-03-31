// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Record an exception for review by the developer
///
/// dartdoc:
/// {@category StateX class}
/// {@category Error handling}
mixin RecordExceptionMixin on State {
  /// Return the 'last' error if any.
  Object? recordException([Object? error, StackTrace? stack]) {
    // Retrieved the currently recorded exception
    var e = _recErrorException;

    if (error == null) {
      // Once retrieved, empty this
      _recErrorException = null;
      _stackTrace = null;
    } else {
      //
      _recErrorException = error;
      _stackTrace = stack;
    }
    return e;
  }

  /// Simply display the exception.
  String get recErrorMsg => errorMsg;
  @Deprecated('Use recErrorMsg instead.')
  String get exceptionMessage => errorMsg;
  @Deprecated('Use recErrorMsg instead.')
  String get errorMsg {
    String message;
    if (_recErrorException == null) {
      message = '';
    } else {
      message = _recErrorException.toString();
      final colon = message.lastIndexOf(': ');
      if (colon > -1 && colon + 2 <= message.length) {
        message = message.substring(colon + 2);
      }
    }
    return message;
  }

  /// The Error or Exception
  Object? get recErrorException => _recErrorException;
  // Store the current error or exception
  Object? _recErrorException;

  /// Indicate if an exception had occurred.
  bool get recHasError => _recErrorException != null;

  /// The StackTrace
  StackTrace? get recStackTrace => _stackTrace;
  StackTrace? _stackTrace;
}
