///
///
///

import '/src/controller.dart';

///
class DogController extends InheritController {
  ///
  factory DogController() => _this ??= DogController._();

  /// Count the number of calls
  factory DogController.count() {
    _dogCount++;
    return DogController();
  }
  DogController._();
  static DogController? _this;

  // Number of instances
  static int _dogCount = 0;
  // Process count
  static int _runningCount = 0;

  /// Call initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @override
  bool runInitAsync() {
    _runInit = _dogRun ?? false;
    _runningCount++;
    if (_runningCount == _dogCount) {
      _runningCount = 0;
      _dogRun = false;
    }
    final run = _runInit;
    _runInit = false; // reset
    return run;
  }

  /// Rebuild the InheritedWidget to also rebuild its dependencies.
  @override
  void newAnimals() {
    onTap();
    _runningCount = 0; // All to change
    super.newAnimals();
  }

  @override
  void onDoubleTap() => onTap();

  @override
  void onTap() {
    _dogRun = true;
    _runningCount = _dogCount - 1; // One to change
  }

  ///
  static bool? _dogRun;

  /// Run the initAsync() function again or not
  bool _runInit = false;
}
