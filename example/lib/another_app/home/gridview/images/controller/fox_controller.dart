///
///
///

import '/src/controller.dart';

///
class FoxController extends InheritController {
  ///
  factory FoxController() => _this ??= FoxController._();

  /// Count the number of calls
  factory FoxController.count() {
    _foxCount++;
    return FoxController();
  }
  FoxController._();
  static FoxController? _this;

  // Number of instances
  static int _foxCount = 0;
  // Process count
  static int _runningCount = 0;

  /// Call initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @override
  bool runInitAsync() {
    _runInit = _foxRun ?? false;
    _runningCount++;
    if (_runningCount == _foxCount) {
      _runningCount = 0;
      _foxRun = false;
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
    _foxRun = true;
    _runningCount = _foxCount - 1;
  }

  ///
  static bool? _foxRun;

  /// Run the initAsync() function again or not
  bool _runInit = false;
}
