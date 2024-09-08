// Copyright 2024 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

///
class RunFutureBuilderStateMixin extends StatefulWidget {
  ///
  const RunFutureBuilderStateMixin({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

/// Calling the 'default' functions without a subclass.
class _State extends State<StatefulWidget>
    with FutureBuilderStateMixin, InheritedWidgetStateMixin {
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  Widget build(BuildContext context) {
    buildF(context);
    builder(context);
    dependOnInheritedWidget(context);
    stateSet(null);
    return const SizedBox.shrink();
  }
}
