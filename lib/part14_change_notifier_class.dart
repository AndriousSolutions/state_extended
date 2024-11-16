// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'state_extended.dart';

/// Allows you to use a ChangeNotifier as a Mixin
///
/// setBuilder(WidgetBuilder? builder) rebuilds with every setState() call.
///
/// *IMPORTANT* Important to call the ChangeNotifier's dispose() function.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
mixin ImplNotifyListenersChangeNotifierMixin {
  //

  // Instantiate the Change Notifier
  void initChangeNotifier() {
    _implChangeNotifier ??= ImplNotifyListenersChangeNotifier();
  }

  /// A flag. Instantiated Change Notifier
  bool get hasChangeNotifierImpl => _implChangeNotifier != null;

  /// Don't forget to call dispose() function!
  void disposeChangeNotifier() {
    _implChangeNotifier?.dispose();
    _implChangeNotifier = null;
  }

  // Implementation of the ChangeNotifier
  ImplNotifyListenersChangeNotifier? _implChangeNotifier;

  /// Returns a widget from builder assuming the current object is a [Listenable]
  /// const SizedBox.shrink() otherwise
  Widget setBuilder(MaybeBuildWidgetType? builder) {
    // Ensure the ChangeNotifier is initialized
    initChangeNotifier();

    if (builder != null) {
      _widgetBuilderUsed = true;
    }
    return ListenableWidgetBuilder(
      listenable: _implChangeNotifier,
      builder: builder,
    );
  }

  /// A flag. Noting if the function above is ever used.
  bool get setBuilderUsed => _widgetBuilderUsed;
  bool _widgetBuilderUsed = false;

  /// Whether any listeners are currently registered.
  bool get hasChangeListeners => _implChangeNotifier?.hasChangeListeners ?? false;

  /// Call all the registered listeners.
  bool notifyListeners()  {
    final notify = _implChangeNotifier != null;
    if (notify) {
      _implChangeNotifier?.notifyListeners();
    }
    return notify;
  }

  /// Register a closure to be called when the object changes.
  bool addListener(VoidCallback listener) {
    final add = _implChangeNotifier != null;
    if (add) {
      _implChangeNotifier?.addListener(listener);
    }
    return add;
  }

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  bool removeListener(VoidCallback listener) {
    final remove = _implChangeNotifier != null;
    if (remove) {
      _implChangeNotifier?.removeListener(listener);
    }
    return remove;
  }
}

/// Implementing ChangeNotifier
class ImplNotifyListenersChangeNotifier with ChangeNotifier {
  /// Whether any listeners are currently registered.
  bool get hasChangeListeners => super.hasListeners;

  /// Call all the registered listeners.
  @override
  // ignore: unnecessary_overrides
  void notifyListeners() => super.notifyListeners();

// The 'unnecessary overrides' prevent the Dart Analysis warning:
// The member 'hasListeners' can only be used within instance members of
// subclasses of 'package: change_notifier.dart'.
}
