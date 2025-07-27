library;

// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a 2-clause BSD License.
// The main directory contains that LICENSE file.
//
//          Created  19 September 2024
//

//
import '/src/view.dart';

///
class CaughtErrorRadioButtons extends RadioButtons<bool> {
  ///
  CaughtErrorRadioButtons({
    super.key,
    bool? initialValue,
    bool? disabled,
    super.inChanged,
  }) : super(
          controller: CaughtErrorController(
            initialValue: initialValue ?? true,
            disabled: disabled,
          ),
        );

  // ///
  // factory CaughtErrorRadioButtons({
  //   Key? key,
  //   // ignore: avoid_positional_boolean_parameters
  //   void Function(bool v)? inChanged,
  // }) =>
  //     _this ??= CaughtErrorRadioButtons._(
  //       key: key,
  //       controller: CaughtErrorController(),
  //       inChanged: inChanged,
  //     );
  //
  // ///
  // const CaughtErrorRadioButtons._({
  //   super.key,
  //   required super.controller,
  //   super.inChanged,
  // });
  //
  // static CaughtErrorRadioButtons? _this;

  ///
  @override
  Widget radioButtons(BuildContext context) {
    //
    final textTheme = Theme.of(context).textTheme;

    final textStyle = textTheme.labelSmall;

    final radios = radioButtonsBuilder<bool>(
      {'Yes': true, 'No': false},
      controller,
      style: textStyle,
      mainAxisSize: MainAxisSize.min,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Catch Error', style: textStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: radios,
        ),
      ],
    );
  }
}

///
class CaughtErrorController extends RadioButtonsController<bool> {
  ///
  CaughtErrorController({super.initialValue, super.disabled});
}
