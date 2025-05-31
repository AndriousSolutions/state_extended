//
import 'dart:async';

import 'package:english_words/english_words.dart';

import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

///
class WordPairsTimer extends StateXController
    with StateXonErrorMixin, EventsControllerMixin {
  /// Only one instance of the class is necessary and desired.
  factory WordPairsTimer({
    int? seconds,
    Duration? duration,
    void Function()? callback,
    int? count,
    StateX? state,
  }) =>
      _this ??= WordPairsTimer._(seconds, duration, callback, count, state);

  WordPairsTimer._(
      this.seconds, this.duration, this.callback, this.count, StateX? state)
      : model = WordPairsModel(),
        super(state);

  static WordPairsTimer? _this;

  ///
  final int? seconds;

  ///
  final Duration? duration;

  ///
  final void Function()? callback;

  ///
  final int? count;

  ///
  final WordPairsModel model;

  ///
  Timer? _timer;

  ///
  final suggestions = <WordPair>[];

  ///
  int index = 0;

  /// Called by every [StateX] object associated with this Controller.
  /// Override this method to perform initialization,
  @override
  void stateInit(StateX state) {
    /// Initialize the timer.
    _initTimer();
    model.addState(state);
  }

  /// In case the Widget is return to the Widget tree
  @override
  void activate() {
    super.activate();
    // Create the Timer again.
    _initTimer();
  }

  /// In case this State object is unmounted from the widget tree.
  @override
  void deactivate() {
    // Cancel the timer
    _cancelTimer();
    super.deactivate();
  }

  /// IMPORTANT dispose() runs late and will cancel the *new* timer
  /// deactivate() is more reliable.
  // @override
  // void dispose() {
//  //   _appStateObject = null;
//  //   cancelTimer();
//  //   super.dispose();
  // }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  // Alternatively, use the function, pausedLifecycleState()
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //
    if (state != AppLifecycleState.resumed) {
      /// AppLifecycleState.paused (may enter the suspending state at any time)
      /// AppLifecycleState.inactive (may be paused at any time)
      /// AppLifecycleState.suspending (Android only)
      _cancelTimer();
    }
  }

  /// Called when app returns from the background
  @override
  void resumedAppLifecycleState() {
    super.resumedAppLifecycleState();
    // Create the Timer again.
    _initTimer();
  }

  /// The application is running in the background.
  @override
  void pausedAppLifecycleState() {
    super.pausedAppLifecycleState();
    // Cancel the timer
    _cancelTimer();
  }

  /// The next route has been popped off, and back to this route.
  @override
  void didPopNext() {
    super.didPopNext();

    /// Initialize the timer.
    _initTimer();
  }

  /// The next route has been pushed
  @override
  void didPushNext() {
    super.didPushNext();
    // Cancel the timer
    _cancelTimer();
  }

  /// An error has occurred
  @override
  void onError(FlutterErrorDetails details) {
    _cancelTimer();
    super.onError(details);
  }

  /// If the value of the object, obj, changes, this builder() is called again
  /// This allows spontaneous rebuilds here and there and not the whole screen.
  Widget get wordPair {
    return SetBuilder(builder: (context, obj) {
      Widget widget;
      if (obj is String) {
        widget = Text(
          obj,
          style: TextStyle(
            color: Colors.red,
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          ),
        );
      } else {
        widget = const SizedBox(height: 6);
      }
      return widget;
    });
  }

  // /// Alternate approach. See class _WordPair
  // Widget get wordPair => _WordPair(this);

  String _wordPair = '';

  // Assigning a value to dataObject will cause a rebuild
  void _getWordPair() {
    //
    try {
      final WordPair twoWords;

      if (model.saved.isNotEmpty) {
        twoWords = model.getWordPair();
      } else {
        twoWords = getWordPair();
      }

      /// Alternate approach uses inheritWidget() and setStatesInherited() functions.
      _wordPair = twoWords.asString;

      /// Change dataObject will rebuild the InheritedWidget
      /// Changing the 'dataObject' will call the SetState class implemented above
      /// and only that widget.
      appStateX?.dataObject = _wordPair;
    } catch (ex) {
      /// Stop the timer.
      /// Something is not working. Don't have the timer repeat it over and over.
      _cancelTimer();

      // Rethrow the error so to get processed by the App's error handler.
      rethrow;
    }
  }

  /// Supply a set of word pairs
  /// Generate a certain number of word pairs
  /// and when those are used, generate another set.
  WordPair getWordPair() {
    index++;
    if (index >= suggestions.length) {
      index = 0;
      suggestions.clear();
      suggestions.addAll(generateWordPairs().take(count ?? 10));
    }
    return suggestions[index];
  }

  bool _timerInit = false;

  /// Cancel the timer
  void _cancelTimer() {
    _timer?.cancel();
    _timerInit = false;
    LogController.log(
        ':::::::::::: _cancelTimer() in ${eventStateClassNameOnly(toString())}');
  }

  /// Create a Timer to run periodically.
  void _initTimer() {
    // Initialize once.
    if (_timerInit) {
      return;
    }

    _timerInit = true;

    Duration duration;
    void Function()? callback;

    /// Supply a 'default' duration if one is not provided.
    if (this.duration == null) {
      int seconds;
      if (this.seconds == null) {
        seconds = 5;
      } else {
        seconds = this.seconds!;
      }
      duration = Duration(seconds: seconds);
    } else {
      duration = this.duration!;
    }

    /// Supply a 'default' callback function
    if (this.callback == null) {
      callback = _getWordPair;
    } else {
      callback = callback;
    }

    _timer = Timer.periodic(duration, (timer) => callback!());

    LogController.log('_initTimer() in ${eventStateClassNameOnly(toString())}');
  }
}

/// Alternate approach to spontaneous rebuilds using the framework's InheritedWidget.
/// This class is assigned to the getter, wordPair.
// ignore: unused_element
class _WordPair extends StatelessWidget {
  const _WordPair(this.con);
  final WordPairsTimer con;
  @override
  Widget build(BuildContext context) {
    /// This is where the magic happens.
    /// This Widget becomes a dependent of an InheritedWidget deep in the framework.
    con.appStateX?.dependOnInheritedWidget(context);
    return Text(
      con._wordPair, //data,
      style: TextStyle(
        color: Colors.red,
        fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
      ),
    );
  }
}
