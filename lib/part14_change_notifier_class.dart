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

  // Initialize the Change Notifier
  void initChangeNotifier() {
    implChangeNotifier ??= ImplNotifyListenersChangeNotifier();
  }

  /// Don't forget to call dispose() function!
  void disposeChangeNotifier() {
    implChangeNotifier?.dispose();
    implChangeNotifier = null;
  }

  // Implementation of the ChangeNotifier
  ImplNotifyListenersChangeNotifier? implChangeNotifier;

  /// Returns a widget from builder assuming the current object is a [Listenable]
  /// const SizedBox.shrink() otherwise
  Widget setBuilder(MaybeBuildWidgetType? builder) {
    // Ensure the ChangeNotifier is initialized
    initChangeNotifier();

    if (builder != null) {
      _widgetBuilderUsed = true;
    }
    return ListenableWidgetBuilder(
      listenable: implChangeNotifier,
      builder: builder,
    );
  }

  /// A flag. Noting if the function above is ever used.
  bool get setBuilderUsed => _widgetBuilderUsed;
  bool _widgetBuilderUsed = false;

  /// Whether any listeners are currently registered.
  bool get hasListeners => implChangeNotifier?.hasListeners ?? false;

  /// Call all the registered listeners.
  bool notifyListeners()  {
    final notify = implChangeNotifier != null;
    if (notify) {
      implChangeNotifier?.notifyListeners();
    }
    return notify;
  }

  /// Register a closure to be called when the object changes.
  bool addListener(VoidCallback listener) {
    final add = implChangeNotifier != null;
    if (add) {
      implChangeNotifier?.addListener(listener);
    }
    return add;
  }

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  bool removeListener(VoidCallback listener) {
    final remove = implChangeNotifier != null;
    if (remove) {
      implChangeNotifier?.removeListener(listener);
    }
    return remove;
  }
}

/// Implementing ChangeNotifier
class ImplNotifyListenersChangeNotifier with ChangeNotifier {
  /// Whether any listeners are currently registered.
  @override
  // ignore: unnecessary_overrides
  bool get hasListeners => super.hasListeners;

  /// Call all the registered listeners.
  @override
  // ignore: unnecessary_overrides
  void notifyListeners() => super.notifyListeners();

// The 'unnecessary overrides' prevent the Dart Analysis warning:
// The member 'hasListeners' can only be used within instance members of
// subclasses of 'package: change_notifier.dart'.
}
