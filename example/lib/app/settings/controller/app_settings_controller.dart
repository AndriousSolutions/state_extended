//
import '/src/controller.dart' show BuildErrorWidget;

import '/src/view.dart';

///
class AppSettingsController extends StateXController
    with TabsScaffoldController {
  /// It's practical at times to make Controllers using the Singleton pattern
  factory AppSettingsController() => _this ??= AppSettingsController._();

  AppSettingsController._();

  static AppSettingsController? _this;

  /// Called when it's [StateX] object is itself disposed of.
  @override
  void dispose() {
    // Good practice to nullify static instance reference.
    // Flutter's garbage collection does its best, but why not if no longer used
    _this = null;
    super.dispose();
  }

  ///
  @override
  Future<bool> initAsync() async {
    await super.initAsync();
    final settings = await _getPreferences();
    // Enable or disable the Custom error screen
    BuildErrorWidget().disabled = !_customErrorScreen;
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

  /// Custom Error Screen
  bool get customErrorScreen => _customErrorScreen;
  bool _customErrorScreen = false;

  set customErrorScreen(bool? error) {
    if (error != null) {
      _customErrorScreen = error;
    }
  }

  /// Toggle the Custom Error Screen
  // ignore: avoid_positional_boolean_parameters
  void toggleErrorScreen(bool value) {
    //
    customErrorScreen = value;
    //
    if (value) {
      BuildErrorWidget().disabled = false;
    } else {
      BuildErrorWidget().disabled = true;
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

  /// Catch error in initAsync()
  bool get catchInitAppAsyncError => _catchInitAppAsyncError;
  bool _catchInitAppAsyncError = false;

  set catchInitAppAsyncError(bool? error) {
    if (error != null) {
      _catchInitAppAsyncError = error;
    }
  }

  /// Error in initAsync()
  bool get anotherInitAsyncError => _anotherInitAsyncError;
  bool _anotherInitAsyncError = false;

  set anotherInitAsyncError(bool? error) {
    if (error != null) {
      _anotherInitAsyncError = error;
    }
  }

  /// Catch error in another initAsync()
  bool get catchAnotherInitAsyncError => _catchAnotherInitAsyncError;
  bool _catchAnotherInitAsyncError = false;

  set catchAnotherInitAsyncError(bool? error) {
    if (error != null) {
      _catchAnotherInitAsyncError = error;
    }
  }

  /// initAsync() return false for failure to initialize successfully
  bool get initAsyncReturnsFalse => _initAsyncReturnsFalse;
  bool _initAsyncReturnsFalse = false;

  set initAsyncReturnsFalse(bool? error) {
    if (error != null) {
      _initAsyncReturnsFalse = error;
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

  /// Catch error in errorCatchAsyncError()
  bool get catchErrorCatchAsyncError => _catchErrorCatchAsyncError;
  bool _catchErrorCatchAsyncError = false;

  set catchErrorCatchAsyncError(bool? error) {
    if (error != null) {
      _catchErrorCatchAsyncError = error;
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
      // Access the device's persistent storage
      final prefs = MyApp.prefs;

      _initAsyncDelay = await prefs.getBool('initAsyncDelay') ?? false;

      _initAppAsyncError = await prefs.getBool('initAppAsyncError') ?? false;

      _initAsyncReturnsFalse =
          await prefs.getBool('initAsyncReturnsFalse') ?? false;

      _anotherInitAsyncError = await prefs.getBool('initAsyncError') ?? false;

      _catchInitAppAsyncError =
          await prefs.getBool('catchInitAsyncError') ?? false;

      _errorInBuilder = await prefs.getBool('errorInBuilder') ?? false;

      _customErrorScreen = await prefs.getBool('customErrorScreen') ?? true;

      _catchAnotherInitAsyncError =
          await prefs.getBool('catchAnotherInitAsyncError') ?? false;

      _errorButton = await prefs.getBool('errorButton') ?? false;

      _catchErrorCatchAsyncError =
          await prefs.getBool('catchErrorCatchAsyncError') ?? false;

      _errorCatchAsyncError =
          await prefs.getBool('errorCatchAsyncError') ?? false;

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
      // Access the device's persistent storage
      final prefs = MyApp.prefs;

      await prefs.setBool('initAsyncDelay', _initAsyncDelay);

      await prefs.setBool('initAppAsyncError', _initAppAsyncError);

      await prefs.setBool('initAsyncReturnsFalse', _initAsyncReturnsFalse);

      await prefs.setBool('initAsyncError', _anotherInitAsyncError);

      await prefs.setBool('catchInitAsyncError', _catchInitAppAsyncError);

      await prefs.setBool('errorInBuilder', _errorInBuilder);

      await prefs.setBool('customErrorScreen', _customErrorScreen);

      await prefs.setBool(
          'catchAnotherInitAsyncError', _catchAnotherInitAsyncError);

      await prefs.setBool('errorButton', _errorButton);

      await prefs.setBool(
          'catchErrorCatchAsyncError', _catchErrorCatchAsyncError);

      await prefs.setBool('errorCatchAsyncError', _errorCatchAsyncError);

      await prefs.setBool('useMaterial3', _useMaterial3);

      await prefs.setBool('printoutEvents', _printoutEvents);
      //
    } catch (e) {
      set = false;
    }
    return set;
  }
}
