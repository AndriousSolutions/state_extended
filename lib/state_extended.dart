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

import 'dart:ui' show AppExitResponse, ViewFocusEvent;

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart'
    show
        CupertinoActivityIndicator,
        CupertinoLocalizations,
        CupertinoUserInterfaceLevel,
        DefaultCupertinoLocalizations;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart' show PredictiveBackEvent;
export 'package:flutter/services.dart' show PredictiveBackEvent;

/// For testing
// import 'package:flutter_test/flutter_test.dart' show TestFailure;

import 'package:test/test.dart' show TestFailure;

/// part files /////////////////////////////////////////////////////////////

/// class StateX controllerByType(), controllerById(), initAsync(), didChangeAppLifecycleState()
part 'part01_statex.dart';

/// class StateXController: dependOnInheritedWidget(), notifyClients()
part 'part02_statex_controller.dart';

/// 27 event trigger methods
part 'part03_statex_event_handlers.dart';

/// class AppStateX: dependOnInheritedWidget(), notifyClients(), stateSet(), onError(), onStateError()
part 'part04_app_statex.dart';

/// on State: nSplashScreen(), initAsync(), onAsyncError(),
part 'part05_futurebuilder_state_mixin.dart';

/// on State: buildF(), updateShouldNotify(), dependOnInheritedWidget(), notifyClients()
part 'part06_inherited_widget_state_mixin.dart';

/// class StateXInheritedWidget // The InheritedWidget used by StateX
part 'part07_statex_inheritedwidget.dart';

/// Called in AppStateX.buildF(): StateXInheritedWidget()
part 'part08_inheritedwidget_statefulwidget.dart';

/// _BuilderStatefulWidget extends StatefulWidget
part 'part09_builder_statefulwidget.dart';

/// mixin on State: stateByType(), stateById(), rootCon, firstState, lastState
part 'part10_map_of_states.dart';

/// class SetState: builder(context, rootState?._dataObj);
part 'part11_set_builder.dart';

/// Implemented [Listenable] class
part 'part12_rebuild_controller_states_mixin.dart';

/// [Listenable] widget builder
part 'part13_listenable_widget_builder.dart';

/// For StateXController, setState(), stateOf(), ofState(), firstState, and lastState
part 'part14_set_state_mixin.dart';

/// on State: controllerByType(), controllerById(), firstCon, lastCon
part 'part15_controllers_by_type.dart';

/// State object's controllerByType(), controllerById(), rootCon
part 'part16_controllers_by_id_mixin.dart';

/// The 'Root' State object: lastContext, dataObject and inDebugMode
part 'part17_app_state_mixin.dart';

/// Record an exception in a State object
part 'part18_error_in_error_handler_mixin.dart';

/// Supply the Async API: initAsync() and onAsyncError()
part 'part19_async_ops_mixin.dart';

/// on State: onError(), logErrorDetails()
part 'part20_statex_error_mixin.dart';

/// WidgetsBinding.instance indicators
part 'part21_widgets_binding_mixin.dart';

/// Make every StateX and StateXController a [RouteAware] object
part 'part22_route_observer_states.dart';

/// A UUID generator, useful for generating unique IDs.
part 'part23_uuid.dart';
