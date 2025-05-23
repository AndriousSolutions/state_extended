// Copyright 2025 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  28 April 2025
//

import '/src/view.dart';

///
mixin AppObjectStateXMixin {
  // Use Material UI when explicitly specified or even when running in iOS
  /// Indicates if the App is running the Material interface theme.
//  bool get useMaterial => MyApp.app.appState?.useMaterial ?? MyApp.app.inAndroid;
  bool get useMaterial => MyApp.app.inAndroid;

  // Use Cupertino UI when explicitly specified or even when running in Android
  /// Indicates if the App is running the Cupertino interface theme.
  // bool get useCupertino => MyApp.app.appState?.useCupertino ?? MyApp.app.iniOS;
  bool get useCupertino => MyApp.app.iniOS;

  /// Determines if running in an IDE or in production.
  bool get inDebugMode => MyApp.app.appState?.inDebugMode ?? false;

  /// Refresh the root State object with the passed function.
  void setState(VoidCallback fn) => MyApp.app.appState?.setState(fn);

  /// Link a widget to a InheritedWidget in the root State object.
  void dependOnInheritedWidget(BuildContext? context) =>
      MyApp.app.appState?.dependOnInheritedWidget(context);

  /// Rebuild dependencies to the root State object's InheritedWidget
  void notifyClients() => MyApp.app.appState?.notifyClients();

  /// Catch and explicitly handle the error.
  void catchError(
    Object? ex, {
    StackTrace? stack,
    String? library,
    DiagnosticsNode? context,
    IterableFilter<String>? stackFilter,
    InformationCollector? informationCollector,
    bool? silent,
  }) {
    //
    if (ex is! Exception) {
      ex = Exception(ex.toString());
    }

    MyApp.app.appState?.catchError(
      ex,
      stack: stack,
      // Supply the app's name instead.
      library: library,

      ///?? App.packageInfo?.appName,
      context: context,
      stackFilter: stackFilter,
      informationCollector: informationCollector,
      silent: silent ?? false,
    );
  }

  /// Retrieve the 'latest' context
  BuildContext? get context => MyApp.app.appState?.lastContext;
}
