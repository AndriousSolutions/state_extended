// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///
///

import '/src/controller.dart';

/// This SOC is associated with the Bird images and works with
/// InheritBird StatefulWidget and the InheritedWidget, _BirdInherited
class BirdController extends InheritController {
  /// Singleton pattern
  factory BirdController() => _this ??= BirdController._();

  /// Count the number of calls
  factory BirdController.count() {
    _birdCount++;
    return BirdController();
  }
  BirdController._();
  static BirdController? _this;

  // Number of instances
  static int _birdCount = 0;
  // Process count
  static int _runningCount = 0;

  /// Call initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @override
  bool runInitAsync() {
    _runInit = _birdsRun ?? false;
    _runningCount++;
    if (_runningCount == _birdCount) {
      _runningCount = 0;
      _birdsRun = false;
    }
    final run = _runInit;
    _runInit = false; // reset
    return run;
  }

  /// Rebuild the InheritedWidget to also rebuild its dependencies.
  @override
  void newAnimals() {
    onTap();
    _runningCount = 0;
    super.newAnimals();
  }

  @override
  void onDoubleTap() => onTap();

  @override
  void onTap() {
    _birdsRun = true;
    _runningCount = _birdCount - 1;
  }

  ///
  static bool? _birdsRun;

  /// Run the initAsync() function again or not
  bool _runInit = false;
}
