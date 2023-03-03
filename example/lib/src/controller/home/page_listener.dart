import 'package:example/src/view.dart';

/// A 'listener' that's assigned to Page 2
/// Really only necessary because of the widget_test
/// and get a higher percentage on Codecov.
class PageStateListener with StateListener {
  /// Singleton Pattern
  factory PageStateListener() => _this ??= PageStateListener._();
  PageStateListener._();
  static PageStateListener? _this;
}
