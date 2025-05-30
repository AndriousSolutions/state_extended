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
mixin _RebuildControllerStatesMixin {
  //
  final Map<State, VoidCallback> _stateListenersMap = {};

  // Instantiate the Change Notifier
  void _initChangeNotifier() {
    // Implement a ChangeNotifier
    _implChangeNotifier ??= ImplNotifyListenersChangeNotifier();
  }

  /// A flag. Instantiated Change Notifier
  @Deprecated('Deemed unnecessary')
  bool get hasChangeNotifierImpl => _implChangeNotifier != null;

  // Implementation of the ChangeNotifier
  ImplNotifyListenersChangeNotifier? _implChangeNotifier;

  /// Returns a widget from builder assuming the current object is a [Listenable]
  /// const SizedBox.shrink() otherwise
  Widget setBuilder(MaybeBuildWidgetType? builder) {
    // Ensure the ChangeNotifier is initialized
    _initChangeNotifier();

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
  bool get hasStateListeners => hasListeners;
  bool get hasListeners => _implChangeNotifier?.hasListeners ?? false;

  /// When notified, setState() is called.
  bool addStateListener([State? state]) {
    var add = _implChangeNotifier != null;
    if (add) {
      add = state != null;
    }
    if (add) {
      _removeOldStates();
      // Don't bother if already added
      if (!_stateListenersMap.containsKey(state!)) {
        //
        listener() {
          if (state.mounted) {
            // ignore: INVALID_USE_OF_PROTECTED_MEMBER
            state.setState(() {});
          } else {
            removeStateListener(state);
          }
        }

        _stateListenersMap.addAll({state: listener});
        _implChangeNotifier?.addListener(listener);
      }
    }
    return add;
  }

  bool removeStateListener([State? state]) {
    var remove = _implChangeNotifier != null;
    if (remove) {
      remove = state != null;
    }
    if (remove) {
      remove = _stateListenersMap.containsKey(state!);
      if (remove) {
        final listener = _stateListenersMap.remove(state);
        remove = listener != null;
        if (remove) {
          // ignore: INVALID_USE_OF_PROTECTED_MEMBER
          _implChangeNotifier?.removeListener(listener);
        }
      }
    }
    return remove;
  }

  /// Don't forget to call this method in the appropriate dispose() function!
  void removeAllStateListeners() {
    _stateListenersMap.forEach(
        (state, listener) => _implChangeNotifier?.removeListener(listener));
    _stateListenersMap.clear();
  }

  /// Call all the registered 'State' listeners.
  bool notifyStateListeners() => notifyStates();
  @Deprecated('Use notifyStateListeners() instead.')
  bool notifyStates() {
    final notify = _implChangeNotifier != null;
    if (notify) {
      _implChangeNotifier?.notifyListeners();
    }
    return notify;
  }

  /// Use the original function name for [ChangeNotifier] as well
  bool notifyListeners() => notifyStateListeners();

  bool _removeOldStates() {
    bool removed = false;
    // Remove any 'stale' State objects
    _stateListenersMap.forEach((state, listener) {
      if (!state.mounted) {
        removed = true;
        _implChangeNotifier?.removeListener(listener);
      }
    });
    if (removed) {
      _stateListenersMap.removeWhere((state, _) => !state.mounted);
    }
    return removed;
  }

  /// Don't forget to call this method in the appropriate dispose() function!
  void _disposeChangeNotifier() {
    removeAllStateListeners();
    _implChangeNotifier?.dispose();
    _implChangeNotifier = null;
  }
}

/// Implementing ChangeNotifier
class ImplNotifyListenersChangeNotifier with ChangeNotifier {
  /// The 'unnecessary overrides' prevent the Dart Analysis warning:
  /// The member 'notifyListeners' can only be used within instance members of
  /// subclasses of 'package: change_notifier.dart'.

  /// Whether any listeners are currently registered.
  @override
  // ignore: unnecessary_overrides
  bool get hasListeners => super.hasListeners;

  /// Call all the registered listeners.
  @override
  // ignore: unnecessary_overrides
  void notifyListeners() => super.notifyListeners();
}

///
@Deprecated('No longer supported')
mixin ImplNotifyListenersChangeNotifierMixin {
  //

  // Instantiate the Change Notifier
  void initChangeNotifier() {
    _implChangeNotifier ??= ImplNotifyListenersChangeNotifier();
  }

  /// A flag. Instantiated Change Notifier
  bool get hasChangeNotifierImpl => _implChangeNotifier != null;

  /// Don't forget to call this method in the appropriate dispose() function!
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
  bool get hasChangeListeners => _implChangeNotifier?.hasListeners ?? false;

  /// Call all the registered listeners.
  bool notifyListeners() {
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
