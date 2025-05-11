// Copyright 2025 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  28 April 2025
//

import 'dart:ui' as ui show FlutterView;

import '/src/view.dart';

///
mixin class AppObjectContextMixin {
  /// Display the SnackBar
  void snackBar({
    Key? key,
    Widget? content,
    String? message,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    Duration? duration,
    Animation<double>? animation,
    VoidCallback? onVisible,
    DismissDirection? dismissDirection,
    Clip? clipBehavior,
    int? durationMillis,
    int? animationDurationMillis,
  }) {
    //
    final context = MyApp.app.context;

    if (MyApp.app.useMaterial) {
      //
      if (content == null) {
        if (message != null) {
          message = message.trim();
          if (message.isNotEmpty) {
            content = Text(message);
          }
        }
        if (content == null) {
          return; // Nothing to display
        }
      }

      ScaffoldMessengerState? state;

      if (context != null) {
        state = ScaffoldMessenger.maybeOf(context);
      }

      state?.showSnackBar(
        SnackBar(
          key: key,
          content: content,
          backgroundColor: backgroundColor,
          elevation: elevation,
          margin: margin,
          padding: padding,
          width: width,
          shape: shape,
          behavior: behavior,
          action: action,
          duration: duration ?? const Duration(milliseconds: 4000),
          animation: animation,
          onVisible: onVisible,
          dismissDirection: dismissDirection ?? DismissDirection.down,
          clipBehavior: clipBehavior ?? Clip.hardEdge,
        ),
      );
    } else {
      //
      if (context == null) {
        return;
      }

      if (message == null) {
        return; // Nothing to display
      }

      message = message.trim();

      if (message.isEmpty) {
        return; // Nothing to display
      }

      animationDurationMillis ??= 200;
      durationMillis ??= 3000;

      final overlayEntry = OverlayEntry(
        builder: (context) => _CupertinoSnackBar(
          key: key,
          message: message!,
          animationDurationMillis: animationDurationMillis!,
          waitDurationMillis: durationMillis!,
        ),
      );

      Future.delayed(
        Duration(milliseconds: durationMillis + 2 * animationDurationMillis),
        overlayEntry.remove,
      );
      Overlay.of(context).insert(overlayEntry);
    }
  }

  // /// Catch and explicitly handle the error.
  // static void catchError(Object ex) {
  //   if (ex is! Exception) {
  //     ex = Exception(ex.toString());
  //   }
  //   _appState?.catchError(ex);
  // }
  //
  // /// Retrieve the 'lastest' context
  // static BuildContext? get context => _appState?.lastContext;

  /// The Scaffold object for this App's View.
  ScaffoldState? get scaffold =>
      MyApp.app.context == null ? null : Scaffold.maybeOf(MyApp.app.context!);

  /// The Physical width of the screen
  double get screenPhysicalWidth {
    double physicalWidth;
    final context = MyApp.app.context;
    if (context == null) {
      physicalWidth = mainWindow.physicalSize.width;
    } else {
      final media = MediaQuery.of(context);
      physicalWidth = media.size.width * media.devicePixelRatio;
    }
    return physicalWidth;
  }

  /// The 'logical' width of the screen
  double get screenWidth {
    double logicalWidth;
    final context = MyApp.app.context;
    if (context == null) {
      final size = mainWindow.physicalSize / mainWindow.devicePixelRatio;
      logicalWidth = size.width;
    } else {
      logicalWidth = MediaQuery.of(context).size.width;
    }
    return logicalWidth;
  }

  /// The Physical height of the screen
  double get screenPhysicalHeight {
    double physicalHeight;
    final context = MyApp.app.context;
    if (context == null) {
      physicalHeight = mainWindow.physicalSize.height;
    } else {
      final media = MediaQuery.of(context);
      physicalHeight = media.size.height * media.devicePixelRatio;
    }
    return physicalHeight;
  }

  /// The 'Logical' height of the screen
  double get screenHeight {
    double logicalHeight;
    final context = MyApp.app.context;
    if (context == null) {
      final size = mainWindow.physicalSize / mainWindow.devicePixelRatio;
      logicalHeight = size.height;
    } else {
      final media = MediaQuery.of(context);
      logicalHeight = media.size.height -
          media.padding.top -
          kToolbarHeight -
          kBottomNavigationBarHeight;
    }
    return logicalHeight;
  }

  /// Set whether the app is to use a 'small screen' or not.
  bool get asSmallScreen => MyApp.app.inDebugMode && false;

  /// Return the bool value indicating if running in a small screen or not.
  bool get inSmallScreen {
    bool smallScreen;

    // May be manually assigned.
    smallScreen = asSmallScreen;

    if (!smallScreen) {
      smallScreen = screenSize.width < 800;
    }
    return smallScreen;
  }

  /// Current Screen Size
  Size get screenSize => MediaQueryData.fromView(mainWindow).size;

  /// The running platform
  TargetPlatform? get platform {
    if (_platform == null && MyApp.app.context != null) {
      _platform = Theme.of(MyApp.app.context!).platform;
    }
    return _platform;
  }

  //
  TargetPlatform? _platform;

  ///
  bool get inMobile =>
      _inMobile ??= MediaQuery.of(MyApp.app.context!).size.shortestSide < 600;

  //
  bool? _inMobile;

  ///
  bool get inAndroid => platform != null && _platform == TargetPlatform.android;

  ///
  bool get inWeb => kIsWeb;

  ///
  bool get iniOS => platform != null && _platform == TargetPlatform.iOS;

  ///
  bool get inFuchsia => platform != null && _platform == TargetPlatform.fuchsia;

  ///
  bool get inLinux => platform != null && _platform == TargetPlatform.linux;

  ///
  bool get inWindows => platform != null && _platform == TargetPlatform.windows;

  /// Flutter application's main window.
  ui.FlutterView get mainWindow {
    if (_window == null) {
      if (MyApp.app.context == null) {
        _window = WidgetsBinding.instance.platformDispatcher.views.first;
      } else {
        _window = View.of(MyApp.app.context!);
      }
    }
    return _window!;
  }

  ui.FlutterView? _window;
}

//
class _CupertinoSnackBar extends StatefulWidget {
  //
  const _CupertinoSnackBar({
    super.key,
    required this.message,
    required this.animationDurationMillis,
    required this.waitDurationMillis,
  });

  final String message;
  final int animationDurationMillis;
  final int waitDurationMillis;

  @override
  State<_CupertinoSnackBar> createState() => _CupertinoSnackBarState();
}

//
class _CupertinoSnackBarState extends State<_CupertinoSnackBar> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _show = true));
    Future.delayed(
      Duration(
        milliseconds: widget.waitDurationMillis,
      ),
      () {
        if (mounted) {
          setState(() => _show = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: _show ? 8.0 : -50.0,
      left: 8,
      right: 8,
      curve: _show ? Curves.linearToEaseOut : Curves.easeInToLinear,
      duration: Duration(milliseconds: widget.animationDurationMillis),
      child: CupertinoPopupSurface(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Text(
            widget.message,
            style: const TextStyle(
              fontSize: 14,
              // color: CupertinoColors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
