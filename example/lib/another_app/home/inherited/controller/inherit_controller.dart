// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  The 'Animal' Controller to call the appropriate InheritedWidget.
///

import '/src/controller.dart';

import '/src/view.dart';

///
abstract class InheritController extends StateXController
    with EventsControllerMixin {
  /// Link this Controller's Widget to a specific InheritedWidget
  /// The InheritedWidget is the first State object it registered with.
  @override
  bool dependOnInheritedWidget(BuildContext? context) =>
      firstState?.dependOnInheritedWidget(context) ?? false;

  /// Calls initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @override
  bool runInitAsync();

  /// Rebuild the InheritedWidget to also rebuild its dependencies.
  void newAnimals() {
    LogController.log(
        ':::::::::::: newAnimals() in ${eventStateClassNameOnly(toString())}');
    firstState?.notifyClients();
  }

  /// Change the single image
  void onTap();

  /// Change all three images
  void onDoubleTap();
}
