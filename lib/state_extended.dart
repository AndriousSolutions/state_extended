library;
// Copyright 2023 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The extension of the State class.
///
/// dartdoc:
/// {@category Get started}
import 'dart:async' show Future;

import 'dart:math' show Random;

import 'dart:ui' show AppExitResponse;

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart'
    show
        CupertinoActivityIndicator,
        CupertinoLocalizations,
        CupertinoUserInterfaceLevel,
        DefaultCupertinoLocalizations;

import 'package:flutter/foundation.dart';

/// Note when routes are pushed n popped
import 'route_observer_states.dart';

/// For testing
import 'package:flutter_test/flutter_test.dart' show TestFailure;

/// Supply to user
export 'route_observer_states.dart';

/// part files /////////////////////////////////////////////////////////////

/// class StateX controllerByType(), controllerById(), initAsync(), didChangeAppLifecycleState()
part 'part01_statex.dart';

/// on State: controllerByType(), controllerById(), firstCon, lastCon
part 'part02_controllers_by_type.dart';

/// on State: onError(), logErrorDetails()
part 'part03_statex_on_error_mixin.dart';

/// 27 event trigger methods
part 'part04_state_listener.dart';

/// on State: nSplashScreen(), initAsync(), onAsyncError(),
part 'part05_futurebuilder_state_mixin.dart';

/// on State: buildF(), updateShouldNotify(), dependOnInheritedWidget(), notifyClients()
part 'part06_inherited_widget_state_mixin.dart';

/// class StateXInheritedWidget // The InheritedWidget used by StateX
part 'part07_statex_inheritedwidget.dart';

/// class AppStateX: dependOnInheritedWidget(), notifyClients(), stateSet(), onError(), onStateError()
part 'part08_app_statex.dart';

/// Called in AppStateX.buildF(): StateXInheritedWidget()
part 'part09_inheritedwidget_statefulwidget.dart';

/// _BuilderStatefulWidget extends StatefulWidget
part 'part10_builder_statefulwidget.dart';

/// mixin on State: stateByType(), stateById(), rootCon, firstState, lastState
part 'part11_map_of_states.dart';

/// class SetState: builder(context, rootState?._dataObj);
part 'part12_set_state.dart';

/// class StateXController: dependOnInheritedWidget(), notifyClients()
part 'part13_statex_controller.dart';

/// Implemented [Listenable] class
part 'part14_impl_change_notifier_mixin.dart';

/// [Listenable] widget builder
part 'part15_listenable_widget_builder.dart';

/// For StateXController, setState(), stateOf(), ofState(), firstState, and lastState
part 'part16_set_state_mixin.dart';

/// State object's controllerByType(), controllerById(), rootCon
part 'part17_controllers_by_id_mixin.dart';

/// The 'Root' State object: lastContext, dataObject and inDebugMode
part 'part18_app_state_mixin.dart';

/// Record an exception in a State object
part 'part19_record_exception_mixin.dart';

/// Supply the Async API: initAsync() and onAsyncError()
part 'part20_async_ops_mixin.dart';

/// A UUID generator, useful for generating unique IDs.
part 'part21_uuid.dart';
