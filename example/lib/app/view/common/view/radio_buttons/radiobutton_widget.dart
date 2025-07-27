library;

// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  19 September 2024
//

///
import 'dart:ui' as ui show TextHeightBehavior;

///
import 'package:flutter/material.dart';

///  Example:
///
// class MaterialVersionRadioButtons extends RadioButtons<bool> {
//
//   const MaterialVersionRadioButtons({
//     super.key,
//     required super.controller,
//     super.inChanged,
//   });
//
//   @override
//   Widget radioButtons(BuildContext context) {
//     final radios = radioButtonsBuilder<bool>(
//       {'3': true, '2': false},
//       MaterialController(),
//       mainAxisSize: MainAxisSize.min,
//     );
//     List<Widget> widgets = [Text('Material Ver.'.tr)];
//     widgets.addAll(radios);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       mainAxisSize: MainAxisSize.min,
//       children: widgets,
//     );
//   }
// }
///
///
abstract class RadioButtons<T> extends StatefulWidget {
  ///
  const RadioButtons({
    super.key,
    required this.controller,
    this.inChanged,
  });

  /// The controller that
  final RadioButtonsController<T> controller;

  /// Optional method called when radio button is changed
  final void Function(T v)? inChanged;

  /// Compose the radio widgets in this function.
  Widget radioButtons(BuildContext context);

  /// Optional function called when radio button is changed
  void onChanged(T v) {}

  @override
  State createState() => _RadioButtonsState<T>();
}

///
class _RadioButtonsState<T> extends State<RadioButtons<T>> {
  @override
  Widget build(BuildContext context) {
    // Placed in build() in case controller is instantiated again and again
    widget.controller._assignState(this);
    return widget.radioButtons(context);
  }
}

/// Returns the 'Radio' widgets
/// Use in abstract function, Widget radioButtons(BuildContext context);
List<Widget> radioButtonsBuilder<T>(
  // Radio
  dynamic items,
  RadioButtonsController<dynamic> controller, {
  double? space,
  MouseCursor? mouseCursor,
  bool? toggleable,
  Color? activeColor,
  WidgetStateProperty<Color?>? fillColor,
  MaterialTapTargetSize? materialTapTargetSize,
  VisualDensity? visualDensity,
  Color? focusColor,
  Color? hoverColor,
  WidgetStateProperty<Color?>? overlayColor,
  double? splashRadius,
  FocusNode? focusNode,
  bool? autofocus,
  bool? useCupertinoCheckmarkStyle,
  bool? textFirst,
  // Text
  TextStyle? style,
  StrutStyle? strutStyle,
  TextAlign? textAlign,
  TextDirection? textDirection,
  Locale? locale,
  bool? softWrap,
  TextOverflow? overflow,
  TextScaler? textScaler,
  int? maxLines,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  ui.TextHeightBehavior? textHeightBehavior,
  Color? selectionColor,
  // Flexible
  int? flex,
  FlexFit? fit,
  // Flex
  Axis? direction, // Axis.vertical or Axis.horizontal
  MainAxisAlignment? mainAxisAlignment,
  MainAxisSize? mainAxisSize,
  CrossAxisAlignment? crossAxisAlignment,
  VerticalDirection? verticalDirection,
  TextBaseline? textBaseline,
  Clip? clipBehavior,
}) {
  //
  Radio<T> buildRadioButton(T value) => Radio<T>.adaptive(
        value: value,
        groupValue: controller.groupValue,
        onChanged: controller.disabled ? null : controller.onChanged,
        mouseCursor: mouseCursor,
        toggleable: toggleable ?? false,
        activeColor: activeColor,
        fillColor: fillColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        materialTapTargetSize: materialTapTargetSize,
        visualDensity: visualDensity,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle ?? false,
      );

  space ??= 0;

  final List<Widget> radioButtons = [];

  assert(() {
    if (controller.type != T) {
      debugPrint(
          '############ controller.type == T fails in radiobutton_widget.dart');
    }
    return true;
  }());

  if (controller.type == T) {
    //
    if (items is List<String>) {
      //
      assert(() {
        if (items.runtimeType != T) {
          debugPrint(
              '############ items.runtimeType == T fails in radiobutton_widget.dart');
        }
        return true;
      }());

      if (items.runtimeType == T) {
        //
        for (final value in items) {
          //
          var radioItems = [
            Flexible(
              fit: fit ?? FlexFit.loose,
              child: buildRadioButton(value as T),
            ),
            if (space > 0) SizedBox(width: space),
            Text(
              value,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textDirection: textDirection,
              locale: locale,
              softWrap: softWrap,
              overflow: overflow,
              textScaler: textScaler,
              maxLines: maxLines,
              semanticsLabel: semanticsLabel,
              textWidthBasis: textWidthBasis,
              textHeightBehavior: textHeightBehavior,
              selectionColor: selectionColor,
            ),
          ];

          if (textFirst ?? false) {
            radioItems = radioItems.reversed.toList(growable: false);
          }

          radioButtons.add(
            Flexible(
              flex: flex ?? 1,
              fit: fit ?? FlexFit.loose,
              child: Flex(
                  direction: direction ?? Axis.horizontal,
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.start,
                  mainAxisSize: mainAxisSize ?? MainAxisSize.max,
                  crossAxisAlignment:
                      crossAxisAlignment ?? CrossAxisAlignment.center,
                  textDirection: textDirection,
                  verticalDirection:
                      verticalDirection ?? VerticalDirection.down,
                  textBaseline: textBaseline,
                  clipBehavior: clipBehavior ?? Clip.none,
                  children: radioItems),
            ),
          );
        }
      }
    } else if (items is Map<String, T>) {
      //
      items.forEach((String key, T value) {
        //
        var radioItems = [
          Flexible(
            fit: fit ?? FlexFit.loose,
            child: buildRadioButton(value),
          ),
          if (space! > 0) SizedBox(width: space),
          Text(
            key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
          ),
        ];

        if (textFirst ?? false) {
          radioItems = radioItems.reversed.toList(growable: false);
        }

        radioButtons.add(
          Flexible(
            flex: flex ?? 1,
            fit: fit ?? FlexFit.loose,
            child: Flex(
              direction: direction ?? Axis.horizontal,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              textDirection: textDirection,
              verticalDirection: verticalDirection ?? VerticalDirection.down,
              textBaseline: textBaseline,
              clipBehavior: clipBehavior ?? Clip.none,
              children: radioItems,
            ),
          ),
        );
      });
    }
  }

  // Nothing to show.
  if (radioButtons.isEmpty) {
    //
    assert(() {
      if (radioButtons.isEmpty) {
        debugPrint(
            '############ items should be a List or a Map in radiobutton_widget.dart');
      }
      return true;
    }());
    radioButtons.add(const SizedBox.shrink());
  }
  return radioButtons;
}

///
class RadioButtonsController<T> {
  /// Supply the initial value of the Radio buttons
  RadioButtonsController({this.initialValue, bool? disabled}) {
    this.disabled = disabled ?? false;
    groupValue = initialValue;
  }

  /// The radio button initial selected
  final T? initialValue;

  /// Explicitly return the 'type'
  Type get type => T;

  /// If the radio buttons are disabled or not
  bool disabled = false;

  /// The current value
  T? groupValue;

  /// Determine if changed from the initial value
  bool get isChanged => groupValue != initialValue;

  /// Call in State's initState()
  void _assignState(_RadioButtonsState<T> state) {
    _state = state;
    statefulWidget = state.widget;
  }

  /// Reference the State object
  _RadioButtonsState<T>? _state;

  /// The StatefulWidget used.
  RadioButtons<T>? statefulWidget;

  /// Called when a button is changed.
  @mustCallSuper
  void onChanged(T? v) {
    if (v != null) {
      groupValue = v;
      statefulWidget?.inChanged?.call(v);
      statefulWidget?.onChanged(v);
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      _state?.setState(() {});
    }
  }
}
