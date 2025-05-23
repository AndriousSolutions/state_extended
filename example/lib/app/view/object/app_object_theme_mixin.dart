// Copyright 2025 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  29 April 2025
//

import '/src/view.dart';

///
mixin AppThemeDataMixin {
  // Allow it to be assigned null.
  /// The App's current Material theme.
  ThemeData? get themeData => _themeData;

  /// Assign the ThemeData
  set themeData(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is ThemeData) {
      _themeData = value;
    } else if (value is CupertinoThemeData) {
      _themeData =
          CupertinoBasedMaterialThemeData(themeData: value).materialTheme;
    } else if (value is! ColorSwatch) {
      // Ignore the value
    } else if (_themeData == null) {
      _themeData = ThemeData(
        primaryColor: value,
      );
    } else {
      _themeData = _themeData?.copyWith(
        primaryColor: value,
      );
    }
  }

  ThemeData? _themeData;

  /// The app's current Cupertino theme.
  CupertinoThemeData? get iOSThemeData => _iOSThemeData;
  set iOSThemeData(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is CupertinoThemeData) {
      _iOSThemeData = value;
    } else if (value is ThemeData) {
      _iOSThemeData = MaterialBasedCupertinoThemeData(materialTheme: value);
      final context = MyApp.app.context;
      if (context != null) {
        _iOSThemeData = _iOSThemeData?.resolveFrom(context);
      }
    } else if (value is! Color) {
      // Ignore the value
    } else if (_iOSThemeData == null) {
      _iOSThemeData = CupertinoThemeData(
        primaryColor: value,
      );
    } else {
      _iOSThemeData = _iOSThemeData?.copyWith(
        primaryColor: value,
      );
    }
  }

  CupertinoThemeData? _iOSThemeData;

  /// Set the app's general color theme supplying a [Color] value.
  Color? setThemeData({
    ColorSwatch<int?>? swatch,
  }) {
    //
    final value = swatch?.toARGB32();

    /// if (!Prefs.ready()) {
    ///   return value == null ? null : Color(value);
    /// }

    MaterialColor? materialColor;
    Color? color;
    int index = -1;

    if (value != null) {
      color = Color(value);
      materialColor = swatch as MaterialColor;
      index =
          Colors.primaries.indexOf(materialColor); // Returns -1 if not found.
      ///      Prefs.setInt('primaryIndex', index);
    } else {
      ///     index = Prefs.getInt('primaryIndex', -1);
    }

    if (index > -1) {
      //
      materialColor = Colors.primaries[index];

      color ??= Color(materialColor.toARGB32());

      /// Assign the colour to the floating button as well.
      themeData = ThemeData(
        useMaterial3: false,
        primarySwatch: materialColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: color,
        ),
      );
    }
    return color;
  }

  // todo: Fluttery
  ///
  // MaterialColor? getMaterialColor(Color? color) {
  //   //
  //   if (color == null) {
  //     return null;
  //   }
  //
  //   final int red = color.intRed;
  //   final int green = color.intGreen;
  //   final int blue = color.intBlue;
  //
  //   final Map<int, Color> shades = {
  //     50: Color.fromRGBO(red, green, blue, .1),
  //     100: Color.fromRGBO(red, green, blue, .2),
  //     200: Color.fromRGBO(red, green, blue, .3),
  //     300: Color.fromRGBO(red, green, blue, .4),
  //     400: Color.fromRGBO(red, green, blue, .5),
  //     500: Color.fromRGBO(red, green, blue, .6),
  //     600: Color.fromRGBO(red, green, blue, .7),
  //     700: Color.fromRGBO(red, green, blue, .8),
  //     800: Color.fromRGBO(red, green, blue, .9),
  //     900: Color.fromRGBO(red, green, blue, 1),
  //   };
  //   return MaterialColor(color.toARGB32(), shades);
  // }

  ///
  void dispose() {
    _themeData = null;
  }
}
