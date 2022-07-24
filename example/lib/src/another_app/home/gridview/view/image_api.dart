// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  Manages the API request for specifically 'image' public API's
///

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// The State object allows for a web service to be called.
class ImageAPIStateX<T extends StatefulWidget> extends StateX<T>
    implements ImageAPIState {
  ///
  ImageAPIStateX({
    required this.uri,
    this.message,
    StateXController? controller,
  }) : super(controller) {
    //
    final id = add(ImageAPIController());
    // Retrieve the Controller by its unique id.
    _con = controllerById(id) as ImageAPIController;
    // or Simply by its type.
    _con = controllerByType<ImageAPIController>()!;
  }

  ///
  @override
  final Uri? uri;

  ///
  @override
  final String? message;

  late ImageAPIController _con;

  /// Supply the widget to the FutureBuilder. Don't implement an InheritedWidget
  @override
  Widget buildWidget(context) {
    controller?.dependOnInheritedWidget(context);
    return GestureDetector(
      onTap: _con.onTap,
      onDoubleTap: _con.onTap,
      child: Card(
        child: _con.image ?? const SizedBox(),
      ),
    );
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  @override
  bool onAsyncError(FlutterErrorDetails details) => false;
}

///
abstract class ImageAPIState {
  ///
  ImageAPIState({required this.uri, required this.message});

  ///
  final Uri? uri;

  ///
  final String? message;
}
