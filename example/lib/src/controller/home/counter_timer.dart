//
import 'dart:async';

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

///
class CounterTimer extends StateXController {
  /// Only one instance of the class is required.
  factory CounterTimer({
    int? seconds,
    Duration? duration,
    void Function()? callback,
    StateX? state,
  }) =>
      _this ??= CounterTimer._(seconds, duration, callback, state);

  // The underscore 'hides' this constructor. It's only visible in this file.
  CounterTimer._(this._seconds, this._duration, this._callback, StateX? state)
      : _con = Controller(),
        super(state);

  // Save this instance for any future calls to the constructor
  static CounterTimer? _this;

  final int? _seconds;
  final Duration? _duration;
  final void Function()? _callback;

  Timer? _timer;

  final Controller _con;
  int _index = 0;

  @override
  void initState() {
    super.initState();

    /// Initialize the timer.
    initTimer();
  }

  /// In case this State object is unmounted from the widget tree.
  @override
  void deactivate() {
    cancelTimer();
  }

  /// IMPORTANT dispose() runs late and cancels the *new* timer
  /// deactivate() is more reliable.
  // @override
  // void dispose() {
//  //   _appStateObject = null;
//  //   cancelTimer();
//  //   super.dispose();
  // }

  @override
  Future<bool> didPopRoute() {
    cancelTimer();
    return super.didPopRoute();
  }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //
    if (state != AppLifecycleState.resumed) {
      /// AppLifecycleState.paused (may enter the suspending state at any time)
      /// AppLifecycleState.inactive (may be paused at any time)
      /// AppLifecycleState.suspending (Android only)
      cancelTimer();
    }
  }

  /// Called when the app's placed in the background
  @override
  void pausedLifecycleState() {
    cancelTimer();
  }

  /// Called when app returns from the background
  @override
  void resumedLifecycleState() {
    /// Create the Timer again.
    initTimer();
  }

  /// Supply the String equivalent
  String get _counter {
    String counter;
    if (_index > 0) {
      counter = '$_index';
    } else {
      counter = '';
    }
    return counter;
  }

  /// This allows spontaneous rebuilds here and there and not the whole screen.
  Widget get counter {
    Widget counter;

    if (_con.count % 2 == 0) {
      //
      counter = _TheCounter(this);
    } else {
      //
      counter = SetState(builder: (context, _) {
        final widget = Text(
          _counter,
          style: TextStyle(
            color: Colors.red,
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          ),
        );
        return widget;
      });
    }
    return counter;
  }

  /// Increment the count and then display the change
  void _increment() {
    //
    try {
      //
      _index++;

      if (_index > _con.count) {
        _index = 0;
      }
      // Rebuild any 'dependencies'
      rootState?.notifyClients();
    } catch (ex) {
      /// Stop the timer.
      /// Something is not working. Don't have the timer repeat it over and over.
      cancelTimer();

      // Rethrow the error so to get processed by the App's error handler.
      rethrow;
    }
  }

  bool _initTimer = false;

  /// Cancel the timer
  void cancelTimer() {
    _timer?.cancel();
    _initTimer = false;
  }

  /// Create a Timer to run periodically.
  void initTimer() {
    // Initialize once.
    if (_initTimer) {
      return;
    }

    _initTimer = true;

    Duration duration;
    void Function() callback;

    /// Supply a 'default' duration if one is not provided.
    if (_duration == null) {
      int seconds = 1;
      if (_seconds != null && _seconds! > seconds) {
        seconds = _seconds!;
      }
      duration = const Duration(milliseconds: 500);
    } else {
      duration = _duration!;
    }

    if (_callback == null) {
      /// Supply a 'default' callback function
      callback = _increment;
    } else {
      callback = _callback!;
    }

    _timer = Timer.periodic(duration, (timer) => callback());
  }
}

/// Alternate approach to spontaneous rebuilds using the framework's InheritedWidget.
/// This class is assigned to the getter, counter.
class _TheCounter extends StatelessWidget {
  const _TheCounter(this.timer, {Key? key}) : super(key: key);
  final CounterTimer timer;
  @override
  Widget build(BuildContext context) {
    /// This is where the magic happens.
    /// This Widget becomes a dependent of an InheritedWidget deep in the framework.
    timer.rootState?.dependOnInheritedWidget(context);
    return Text(
      timer._counter,
      style: TextStyle(
        color: Colors.red,
        fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
      ),
    );
  }
}
