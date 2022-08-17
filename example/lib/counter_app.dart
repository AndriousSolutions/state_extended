import 'package:flutter/material.dart';

import 'package:state_extended/state_extended.dart';

void main() => runApp(MaterialApp(home: MyHomePage()));

/// The main screen
class MyHomePage extends StatelessWidget {
  /// Supply a title to the main screen
  MyHomePage({Key? key, this.title = 'Flutter Demo Home Page'})
      : _con = Controller(),
        super(key: key);

  final Controller _con;

  /// Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Swx(
                (context) => Text(
                  '${_con.data}',
                  style: Theme.of(context).textTheme.headline4,
                ),
                controller: _con,
                initState: () {
                  /// The State object in Swx.
                  final state = _con.state;

                  final controller = state?.controller;

                  final widget = state?.widget;

                  final mounted = state?.mounted;

                  final inDebugger = state!.inDebugger;

                  final firstController = state.rootCon;

                  final context = state.context;

                  final hashCode = state.hashCode;
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _con.onPressed,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}

/// The controller for this app.
class Controller extends StateXController {
  /// Using a factory constructor on Controllers and implementing the Singleton design pattern
  factory Controller() => _this ??= Controller._();
  Controller._()
      : _model = _Model(),
        super();

  static Controller? _this;

  /// Supply the separate 'data source' for this app
  final _Model _model;

  /// Supply the data to be displayed in the app.
  int get data => _model.integer;

  /// The corresponding routine for the event, onPressed.
  void onPressed() => setState(_model._incrementCounter);
}

/// The separate 'data source'. Allow it be switched out in future.
class _Model {
  int get integer => _integer;
  int _integer = 0;
  int _incrementCounter() => ++_integer;
}
