///
import 'dart:ui' as i
    show
        //ErrorCallback,
        ParagraphBuilder,
        ParagraphConstraints,
        ParagraphStyle,
        TextStyle;

import 'package:flutter/cupertino.dart' show CupertinoPageRoute;

import 'package:flutter/foundation.dart'
    show
        DiagnosticPropertiesBuilder,
        DiagnosticsTreeStyle,
        ErrorDescription,
        StringProperty;

import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        Colors,
        EdgeInsets,
        ErrorWidget,
        ErrorWidgetBuilder,
        FlutterError,
        FlutterErrorDetails,
        FontWeight,
        Icons,
        Key,
        LeafRenderObjectWidget,
        MaterialPageRoute,
        Route,
        RouteSettings,
        Size,
        TextAlign,
        TextBaseline,
        TextDirection,
        Widget;

import 'package:flutter/rendering.dart'
    show
        DiagnosticPropertiesBuilder,
        DiagnosticsTreeStyle,
        Offset,
        Paint,
        PaintingContext,
        PaintingStyle,
        Rect,
        RenderBox,
        RenderObjectWithChildMixin;

import '/src/controller.dart' show StateXController;

import '/src/view.dart' show MyApp, State, StateX;

///
class BuildErrorWidget extends StateXController {
  ///
  factory BuildErrorWidget({
    Key? key,
    String? header,
    String? appName,
    String? message,
    bool? showStackTrace,
    i.ParagraphStyle? paragraphStyle,
    i.TextStyle? textStyle,
    EdgeInsets? padding,
    double? minimumWidth,
    Color? backgroundColor,
  }) =>
      _this ??= BuildErrorWidget._(
        key,
        header,
        appName,
        message,
        showStackTrace,
        paragraphStyle,
        textStyle,
        padding,
        minimumWidth,
        backgroundColor,
      );

  BuildErrorWidget._(
    this.key,
    this.header,
    this.appName,
    this.message,
    this.showStackTrace,
    this.paragraphStyle,
    this.textStyle,
    this.padding,
    this.minimumWidth,
    this.backgroundColor,
  );

  static BuildErrorWidget? _this;

  ///
  Key? key;

  /// Header of the text
  String? header;

  /// App name and or info
  String? appName;

  /// The message to display.
  String? message;

  /// retrieve Stack Trace if any
  bool? showStackTrace;

  ///
  i.ParagraphStyle? paragraphStyle;

  ///
  i.TextStyle? textStyle;

  ///
  EdgeInsets? padding;

  ///
  double? minimumWidth;

  ///
  Color? backgroundColor;

  @override
  void initState() {
    //
    super.initState();
    // Allow only the first instance to make changes
    if (ErrorWidget.builder != displayBuildErrorWidget) {
      _errorWidgetBuilder = ErrorWidget.builder;
      ErrorWidget.builder = displayBuildErrorWidget;
    }
  }

  @override
  void dispose() {
    // Good practice to nullify static instance reference.
    // Flutter's garbage collection does its best, but why not if no longer used
    _this = null;

    if (_errorWidgetBuilder != null) {
      // Return to original Error Builder widget
      ErrorWidget.builder = _errorWidgetBuilder!;
    }
    super.dispose();
  }

  // Record the original Error Builder widget
  ErrorWidgetBuilder? _errorWidgetBuilder;

  /// Called by every [StateX] object associated with it.
  /// Override this method to perform initialization,
  @override
  void stateInit(covariant State state) {
    //
    // If in testing, you will need to return to original Error Builder widget
    if (!inWidgetsFlutterBinding) {
      if (state.widget is MyApp) {
        // Allow only the first instance to make changes
        if (ErrorWidget.builder != displayBuildErrorWidget) {
          _errorWidgetBuilder = ErrorWidget.builder;
          ErrorWidget.builder = displayBuildErrorWidget;
        }
      }
    }
  }

  @override
  void deactivateState(covariant State state) {
    //
    // If in testing, you will need to return to original Error Builder widget
    if (!inWidgetsFlutterBinding) {
      if (state.widget is MyApp) {
        if (_errorWidgetBuilder != null) {
          // Return to original Error Builder widget
          ErrorWidget.builder = _errorWidgetBuilder!;
        }
      }
    }
    super.deactivateState(state);
  }

  /// Use low-level primitives to return a simple Widget.
  /// Used primarily as a substitute when a Widget fails in error to build.
  /// The system may now be unstable.
  Widget displayBuildErrorWidget(
    FlutterErrorDetails details, {
    Key? key,
    String? header,
    String? appName,
    String? message,
    Object? error,
    bool? showStackTrace,
    i.ParagraphStyle? paragraphStyle,
    i.TextStyle? textStyle,
    EdgeInsets? padding,
    double? minimumWidth,
    Color? backgroundColor,
  }) {
    //
    String? message;
    //
    try {
      //
      message = '\n\n${details.exception}\n\n';

      if (details.stack != null &&
          (showStackTrace ?? this.showStackTrace ?? true)) {
        //
        final stack = details.stack.toString().split('\n');

        final length = stack.length > 5 ? 5 : stack.length;

        final buffer = StringBuffer()..write(message);

        for (var i = 0; i < length; i++) {
          buffer.write('${stack[i]}\n');
        }
        message = buffer.toString();
      }
    } catch (e) {
      message = null;
    }
    // Parameters take priority
    return _ErrorRenderObjectWidget(
      key: key ?? this.key,
      header: header ?? this.header,
      appName: appName ?? this.appName,
      message: message ?? this.message,
      error: error ?? details.exception,
      paragraphStyle: paragraphStyle ?? this.paragraphStyle,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      minimumWidth: minimumWidth ?? this.minimumWidth,
      backgroundColor: backgroundColor ??
          this.backgroundColor ??
          const Color(
            0xFFFFFFFF,
          ),
    );
  }

  /// Using the low-level primitives to avoid an unstable state
  Route<dynamic>? onUnknownRoute(
    RouteSettings settings, {
    Key? key,
    FlutterErrorDetails? details,
    String? header,
    String? message,
    StackTrace? stack,
    String? library,
    String? description,
    i.ParagraphStyle? paragraphStyle,
    i.TextStyle? textStyle,
    EdgeInsets? padding,
    double? minimumWidth,
    Color? backgroundColor,
  }) {
    //
    if (details == null) {
      //
      message ??= 'Route "${settings.name}" not found!';
      description ??=
          'The onUnknownRoute callback returned this screen instead.';
      details = FlutterErrorDetails(
        exception: Exception(message),
        stack: stack,
        library: library,
        context: ErrorDescription(description),
      );
    }
    final widget = displayBuildErrorWidget(
      details,
      header: header ?? '404',
      paragraphStyle: paragraphStyle,
      textStyle: textStyle,
      padding: padding,
      minimumWidth: minimumWidth,
      backgroundColor: backgroundColor,
    );
    Route<dynamic> route;
    if (MyApp.app.useMaterial) {
      route = MaterialPageRoute<dynamic>(
          builder: (_) => widget, settings: settings);
    } else {
      route = CupertinoPageRoute<dynamic>(
          builder: (_) => widget, settings: settings);
    }
    return route;
  }
}

/// A low-level widget to present instead of the failed widget.
class _ErrorRenderObjectWidget extends LeafRenderObjectWidget {
  /// Supply an error message to display and or a Error object.
  const _ErrorRenderObjectWidget({
    super.key,
    this.header,
    this.appName,
    this.message,
    this.error,
    this.paragraphStyle,
    this.textStyle,
    this.padding,
    this.minimumWidth,
    this.backgroundColor,
  });

  /// Header of the text
  final String? header;

  /// App name and or info
  final String? appName;

  /// The message to display.
  final String? message;

  ///
  final Object? error;

  ///
  final i.ParagraphStyle? paragraphStyle;

  ///
  final i.TextStyle? textStyle;

  ///
  final EdgeInsets? padding;

  ///
  final double? minimumWidth;

  ///
  final Color? backgroundColor;

  @override
  RenderBox createRenderObject(BuildContext context) => _ErrorBox(
        header: header,
        appName: appName,
        message: _errorMessage(message, error),
        paragraphStyle: paragraphStyle,
        textStyle: textStyle,
        padding: padding,
        minimumWidth: minimumWidth,
        backgroundColor: backgroundColor,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (error == null || error is! FlutterError) {
      properties.add(StringProperty('message', _errorMessage(message, error),
          quoted: false));
    } else {
      final FlutterError flutterError = error as FlutterError;
      properties.add(flutterError.toDiagnosticsNode(
          style: DiagnosticsTreeStyle.whitespace));
    }
  }

  /// Compose an error message to be displayed.
  /// An empty string if no message was provided.
  String _errorMessage(String? message, Object? error) {
    String message0;

    if (message == null || message.isEmpty) {
      //
      if (error == null) {
        message0 = '';
      } else {
        message0 = error.toString();
      }
    } else {
      message0 = message;
    }
    return message0;
  }
}

class _ErrorBox extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  ///
  /// A message can optionally be provided. If a message is provided, an attempt
  /// will be made to render the message when the box paints.
  _ErrorBox({
    this.header,
    this.appName,
    String? message,
    i.ParagraphStyle? paragraphStyle,
    // ignore: avoid_unused_constructor_parameters
    i.TextStyle? textStyle,
    EdgeInsets? padding,
    double? minimumWidth,
    Color? backgroundColor,
  }) {
    // Supply a style if not explicitly provided.
    _paragraphStyle = paragraphStyle ??
        i.ParagraphStyle(
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        );

    // _textStyle = textStyle ?? _initTextStyle();  // Not used??

    _padding = padding ?? const EdgeInsets.fromLTRB(34, 96, 34, 12);

    _minimumWidth = minimumWidth ?? 200;

    _backgroundColor = backgroundColor ?? _initBackgroundColor();

    _message =
        message == null || message.isEmpty ? 'Unknown Error!' : message.trim();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    try {
      //
      context.canvas.drawRect(offset & size, Paint()..color = _backgroundColor);

      _drawWordERROR(context, 0, text: header ?? 'Oops!');

      _drawIcon(context, 50);

      if (appName != null && appName!.isNotEmpty) {
        _drawAppName(context, 100, text: appName ?? '');
      }
      _drawMessage(context, 150);

      _drawErrorMessage(context, 200, offset);

      // Draw a rectangle around the screen
      _drawRect(context);
    } catch (ex) {
      // If an error happens here we're in a terrible state, so we really should
      // just forget about it and let the developer deal with the already-reported
      // errors. It's unlikely that these errors are going to help with that.
    }
  }

  /// Header beginning the test displayed
  String? header;

  /// App name and or version number
  String? appName;

  /// The message to attempt to display at paint time.
  String? _message;

//  late i.Paragraph _paragraph;  // Not used??

  /// The paragraph style to use when painting [RenderBox] objects.
  late i.ParagraphStyle _paragraphStyle;

  /// The text style to use when painting [RenderBox] objects.
  /// a dark gray sans-serif font.
//  late i.TextStyle _textStyle;  // Not used??

  /// The distance to place around the text.
  ///
  /// This is intended to ensure that if the [RenderBox] is placed at the top left
  /// of the screen, under the system's status bar, the error text is still visible in
  /// the area below the status bar.
  ///
  /// The padding is ignored if the error box is smaller than the padding.
  ///
  /// See also:
  ///
  ///  * [_minimumWidth], which controls how wide the box must be before the
  //     horizontal padding is applied.
  late EdgeInsets _padding;

  /// The width below which the horizontal padding is not applied.
  ///
  /// If the left and right padding would reduce the available width to less than
  /// this value, then the text is rendered flush with the left edge.
  late double _minimumWidth;

  /// The color to use when painting the background of [RenderBox] objects.
  /// a red from a light gray.
  late Color _backgroundColor;

  @override
  double computeMaxIntrinsicWidth(double height) => 100000;

  @override
  double computeMaxIntrinsicHeight(double width) => 100000;

  // 'RenderBox subclasses need to either override performLayout() to '
  // 'set a size and lay out any children, or, set sizedByParent to true '
  // 'so that performResize() sizes the render object.',
  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performResize() {
    size = constraints.constrain(const Size(100000, 100000));
  }

  /// Light gray in production; Red in development.
  Color _initBackgroundColor() {
    var result = const Color(0xF0C0C0C0);
    assert(() {
      result = const Color(0xF0900000);
      return true;
    }());
    return result;
  }

  void _drawWordERROR(PaintingContext context, double top, {String? text}) {
    text ??= 'ERROR';
    final builder = i.ParagraphBuilder(i.ParagraphStyle(
      textAlign: TextAlign.center,
    ))
      ..pushStyle(i.TextStyle(
        color: Colors.red,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        textBaseline: TextBaseline.alphabetic,
      ))
      ..addText(text);
    final paragraph = builder.build();
    paragraph.layout(i.ParagraphConstraints(width: _minimumWidth));
    context.canvas.drawParagraph(
      paragraph,
      Offset(
        (size.width - paragraph.width) * 0.5,
        _padding.top + top, //(size.height - paragraph.height) * 0.5,
      ),
    );
  }

  void _drawIcon(PaintingContext context, double top) {
    const icon = Icons.error;
    final builder = i.ParagraphBuilder(i.ParagraphStyle(
      fontFamily: icon.fontFamily,
    ))
      ..addText(String.fromCharCode(icon.codePoint));
    final paragraph = builder.build();
    paragraph.layout(i.ParagraphConstraints(width: size.width * 0.5));
    context.canvas.drawParagraph(
      paragraph,
      Offset(
        (size.width - paragraph.width) * 0.5,
        _padding.top + top,
      ),
    );
  }

  void _drawAppName(PaintingContext context, double top, {String? text}) {
    final builder = i.ParagraphBuilder(i.ParagraphStyle(
      textAlign: TextAlign.center,
    ))
      ..pushStyle(i.TextStyle(
        color: Colors.black,
        fontSize: 18,
        textBaseline: TextBaseline.alphabetic,
      ))
      ..addText(text?.trim() ?? '');
    final paragraph = builder.build();
    paragraph.layout(
        i.ParagraphConstraints(width: (size.width - paragraph.width) * 0.5));
    context.canvas.drawParagraph(
      paragraph,
      Offset(
        (size.width - paragraph.width) * 0.5,
        _padding.top + top,
      ),
    );
  }

  void _drawMessage(PaintingContext context, double top) {
    const text = 'An error has occurred in this app.\n';
    final builder = i.ParagraphBuilder(i.ParagraphStyle(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    ))
      ..pushStyle(i.TextStyle(
        color: Colors.black,
        fontSize: 24,
        textBaseline: TextBaseline.alphabetic,
      ))
      ..addText(text);
    final paragraph = builder.build();
    paragraph
        .layout(i.ParagraphConstraints(width: size.width - _padding.right));
    context.canvas.drawParagraph(
      paragraph,
      Offset(
        _padding.left,
        _padding.top + top,
      ),
    );
  }

  void _drawErrorMessage(PaintingContext context, double top, Offset offset) {
    //
    final builder = i.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(i.TextStyle(color: Colors.black, fontSize: 18))
      ..addText(_message!);

    final paragraph = builder.build();

    //
    var width = size.width;
    if (width > _padding.left + _minimumWidth + _padding.right) {
      width -= _padding.left + _padding.right;
    }

    paragraph.layout(i.ParagraphConstraints(width: width));

    context.canvas.drawParagraph(
        paragraph, offset + Offset(_padding.left, _padding.top + top));
  }

  // Draw a rectangle around the screen
  void _drawRect(PaintingContext context) {
    final right = size.width - _padding.right / 2;
    final bottom = size.height - _padding.bottom;
    final rect =
        Rect.fromLTRB(_padding.left / 2, _padding.top / 2, right, bottom);
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    context.canvas.drawRect(rect, paint);
  }
}
