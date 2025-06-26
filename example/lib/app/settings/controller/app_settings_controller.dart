//
import '/src/view.dart';

///
class AppSettingsController extends StateXController
    with TabsScaffoldController {
  // TwoTabScaffoldController {
  /// Singleton Pattern
  factory AppSettingsController() => _this ??= AppSettingsController._();

  AppSettingsController._();

  static AppSettingsController? _this;

  ///
  @override
  Future<bool> initAsync() async {
    await super.initAsync();
    final settings = await _getPreferences();
    return settings;
  }

  ///
  @override
  Future<void> deactivate() async {
    await _setPreferences();
  }

  /// Device
  @override
  void inactiveAppLifecycleState() {
    _setPreferences();
  }

  /// Called during hot reload.
  @override
  void reassemble() {
    _setPreferences();
  }

  ///
  @override
  void deactivateTabsScaffold() => _setPreferences();

  ///
  @override
  void tabSwitchBack() => _setPreferences();

  /// Delay the initAsync() for a time
  bool get initAsyncDelay => _initAsyncDelay;
  bool _initAsyncDelay = false;

  set initAsyncDelay(bool? delay) {
    if (delay != null) {
      _initAsyncDelay = delay;
    }
  }

  /// Error in push button
  bool get errorButton => _errorButton;
  bool _errorButton = false;

  set errorButton(bool? error) {
    if (error != null) {
      _errorButton = error;
    }
  }

  /// Error in builder()
  bool get errorInBuilder => _errorInBuilder;
  bool _errorInBuilder = false;

  set errorInBuilder(bool? error) {
    if (error != null) {
      _errorInBuilder = error;
    }
  }

  /// Error in the App's initAsync()
  bool get initAppAsyncError => _initAppAsyncError;
  bool _initAppAsyncError = false;

  set initAppAsyncError(bool? error) {
    if (error != null) {
      _initAppAsyncError = error;
    }
  }

  /// Error in initAsync()
  bool get initAsyncError => _initAsyncError;
  bool _initAsyncError = false;

  set initAsyncError(bool? error) {
    if (error != null) {
      _initAsyncError = error;
    }
  }

  /// initAsync() return false for failure to initialize successfully
  bool get initAsyncFailed => _initAsyncFailed;
  bool _initAsyncFailed = false;

  set initAsyncFailed(bool? error) {
    if (error != null) {
      _initAsyncFailed = error;
    }
  }

  /// Error in errorCatchAsyncError()
  bool get errorCatchAsyncError => _errorCatchAsyncError;
  bool _errorCatchAsyncError = false;

  set errorCatchAsyncError(bool? error) {
    if (error != null) {
      _errorCatchAsyncError = error;
    }
  }

  /// Use Material 3 or Material 2
  bool get useMaterial3 => _useMaterial3;
  bool _useMaterial3 = false;

  set useMaterial3(bool? use) {
    if (use != null) {
      _useMaterial3 = use;
    }
  }

  /// Use debugPrint to print out to the console when events fire
  bool get printoutEvents => _printoutEvents;
  bool _printoutEvents = false;

  set printoutEvents(bool? use) {
    if (use != null) {
      _printoutEvents = use;
    }
  }

  ///
  Future<bool> _getPreferences() async {
    //
    var preferences = true;

    /// Any error will be caught and returns false;
    try {
      // Access the device's persistent store
      final prefs = MyApp.prefs;

      _initAsyncDelay = await prefs.getBool('initAsyncDelay') ?? false;

      _initAppAsyncError = await prefs.getBool('initAppAsyncError') ?? false;

      _initAsyncError = await prefs.getBool('initAsyncError') ?? false;

      _errorInBuilder = await prefs.getBool('errorInBuilder') ?? false;

      _errorButton = await prefs.getBool('errorButton') ?? false;

      _useMaterial3 = await prefs.getBool('useMaterial3') ?? true;

      _printoutEvents = await prefs.getBool('printoutEvents') ?? false;
      //
    } catch (e) {
      preferences = false;
    }
    return preferences;
  }

  ///
  Future<bool> _setPreferences() async {
    //
    var set = true;

    /// Any error will be caught and returns false;
    try {
      // Access the device's persistent store
      final prefs = MyApp.prefs;

      await prefs.setBool('initAsyncDelay', _initAsyncDelay);

      await prefs.setBool('initAppAsyncError', _initAppAsyncError);

      await prefs.setBool('initAsyncError', _initAsyncError);

      await prefs.setBool('errorInBuilder', _errorInBuilder);

      await prefs.setBool('errorButton', _errorButton);

      await prefs.setBool('useMaterial3', _useMaterial3);

      await prefs.setBool('printoutEvents', _printoutEvents);
      //
    } catch (e) {
      set = false;
    }
    return set;
  }
}
