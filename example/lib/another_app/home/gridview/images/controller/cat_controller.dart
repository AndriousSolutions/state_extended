///
///
///

import '/src/controller.dart';

import '/src/view.dart';

///
class CatController extends InheritController {
  ///
  factory CatController() => _this ??= CatController._();

  /// Count the number of calls
  factory CatController.count() {
    _catCount++;
    return CatController();
  }
  CatController._();
  static CatController? _this;

  // Number of instances
  static int _catCount = 0;
  // Process count
  static int _runningCount = 0;

  /// Call initAsync() all the time if returns true.
  /// Conditional calls initAsync() creating a Future with every rebuild
  @override
  bool runInitAsync() {
    _runInit = _catRun ?? false;
    _runningCount++;
    if (_runningCount == _catCount) {
      _runningCount = 0;
      _catRun = false;
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
    _catRun = true;
    _runningCount = _catCount - 1;
  }

  ///
  static bool? _catRun;

  /// Run the initAsync() function again or not
  bool _runInit = false;
}
