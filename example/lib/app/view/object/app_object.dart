// Copyright 2019 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  09 Feb 2019
//
//
import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

/// This class is available throughout the app
/// readily supplies static properties about the App.
///
/// dartdoc:
/// {@category Get started}
/// {@category App object}
class AppObject
    with
        AppObjectBindingMixin,
        AppObjectContextMixin,
        AppObjectStateXMixin,
        AppThemeDataMixin,
        StateXonErrorMixin {
  ///
  factory AppObject() => _this ??= AppObject._();

  AppObject._()
      : prefs = SharedPreferencesAsync(),
        appSettings = AppSettingsController();

  static AppObject? _this;

  /// Stores App's Preferences
  // https://pub.dartlang.org/packages/shared_preferences/
  final SharedPreferencesAsync prefs;

  /// Supply the App's settings
  final AppSettingsController appSettings;

  //  bool get useMaterial => MyApp.app.appState?.useMaterial ?? MyApp.app.inAndroid;
  @override
  bool get useMaterial => MyApp.app.inAndroid;

  // Use Cupertino UI when explicitly specified or even when running in Android
  /// Indicates if the App is running the Cupertino interface theme.
  @override
  bool get useCupertino => MyApp.app.iniOS;

  /// Dispose the App properties.
  @override
  void dispose() {
    _appState = null; // Remove local reference
  }

  /// The App State object.
// Not yet gp  @Deprecated('Should not be an exposed property')
  AppStateX? get appState => _appState;

  // Reference the App's State object
  static AppStateX? _appState;

  set appState(AppStateX? state) {
    if (state != null && (_appState == null || _hotReload)) {
      _appState = state;
    }
  }

  /// Determine if the App initialized successfully.
  // ignore: unnecessary_getters_setters
  bool get isInit => _isInit ?? false;

  /// Set the init only once.
  // ignore: unnecessary_getters_setters
  set isInit(bool? init) => _isInit ??= init;
  bool? _isInit;

  /// Determine if this app is running alone
  bool? get standAloneApp => _standAlone;

  set standAloneApp(bool? alone) {
    if (!_standAlone) {
      if (alone != null && alone) {
        _standAlone = true;
      }
    }
  }

  bool _standAlone = false;

  /// Flag to set hot reload from now on.
  // ignore: unnecessary_getters_setters
  bool get hotReload => _hotReload;

  /// Once set, it will always hot reload.
  // ignore: unnecessary_getters_setters
  set hotReload(bool hotReload) {
    // It doesn't accept false. i.e. Once true, it stays true.
    if (hotReload) {
      _hotReload = hotReload;
    }
  }

  /// Flag indicating there was a 'hot reload'
  bool _hotReload = false;

  /// Show a snack bar when appropriate
  void showSnackBar([String? tip]) {
    if (inMobile) {
      final content = tip ?? '';
      if (content.isNotEmpty) {
        // Displays a snack bar.
        snackBar(message: content.trim());
      }
    }
  }
}
