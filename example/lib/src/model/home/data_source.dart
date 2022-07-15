// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

/// This separate class represents 'the Model' (the data) of the App.
class Model extends StateXController {
  ///
  factory Model([StateX? state]) => _this ??= Model._(state);
  Model._(super.state);
  static Model? _this;

  ///
  int get counter => _counter;
  int _counter = 0;

  ///
  int incrementCounter() => ++_counter;

  ///
  final words = [
    'Hello There!',
    'How are you?',
    'Are you good?',
    'All the best.',
    'Bye for now.'
  ];
  int _index = 0;

  ///
  String sayHello() {
    String say;
    if (_index < words.length) {
      say = words[_index];
      _index++;
    } else {
      say = '';
    }
    return say;
  }
}
