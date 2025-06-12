// Uuid
// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this Uuid function is governed by the M.I.T. license that can be found
// in the LICENSE file under Uuid.
//

part of 'state_extended.dart';

/// Implements [inWidgetsFlutterBinding] and [inFlutterTest]
/// for both [StateX] and [StateXController]
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin class WidgetsBindingInstanceMixin {
  /// Indicating app is running in the Flutter engine and not in
  /// the `flutter_test` framework with TestWidgetsFlutterBinding for example
  bool get inWidgetsFlutterBinding => _inWidgetsFlutterBinding ??=
      WidgetsBinding.instance is WidgetsFlutterBinding;
  static bool? _inWidgetsFlutterBinding;

  /// Indicate if running under a 'Flutter Test' environment
  bool get inFlutterTest =>
      _inFlutterTest ??= WidgetsBinding.instance is! WidgetsFlutterBinding;
  static bool? _inFlutterTest;
}
