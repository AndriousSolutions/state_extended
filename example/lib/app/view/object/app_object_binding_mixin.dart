// Copyright 2025 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  28 April 2025
//

import '/src/view.dart';

///
mixin class AppObjectBindingMixin {
  /// Indicating app is running in the Flutter engine and not in
  /// the `flutter_test` framework with TestWidgetsFlutterBinding for example
  bool get inWidgetsFlutterBinding => _inWidgetsFlutterBinding ??=
      WidgetsBinding.instance is WidgetsFlutterBinding;
  bool? _inWidgetsFlutterBinding;

  /// Indicate if running under a 'Flutter Test' environment
  bool get inFlutterTest =>
      _inFlutterTest ??= WidgetsBinding.instance is! WidgetsFlutterBinding;
  bool? _inFlutterTest;
}
