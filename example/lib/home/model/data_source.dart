// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '/src/view.dart';

/// This separate class represents 'the Model' (the data) of the App.
class Model extends StateXController {
  ///
  Model([super.state]);

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