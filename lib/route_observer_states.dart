//
import 'package:flutter/material.dart';

/// Makes every [StateX] and [StateXController] a [RouteAware] object
/// calling [didPop], [didPush], [didPopNext] and [didPushNext]
/// Implemented by default.
///
/// dartdoc:
/// {@category StateX class}
/// {@category State Object Controller}
class RouteObserverStates extends RouteObserver<Route<dynamic>> {
  factory RouteObserverStates() => _this ??= RouteObserverStates._();

  RouteObserverStates._();

  static RouteObserverStates? _this;

  /// Supply to the [MaterialApp] & [CupertinoApp]
  /// eg.  navigatorObservers: RouteObserverStates.list,
  static List<NavigatorObserver> get list =>
      <NavigatorObserver>[RouteObserverStates()];

  static bool subscribeRoutes(RouteAware object) =>
      _this?.subscribeState(object) ?? false;

  static bool unsubscribeRoutes(RouteAware object) =>
      _this?.unsubscribeState(object) ?? false;

  /// Make a State object aware of route changes.
  bool subscribeState(RouteAware? object) {
    //
    var sub = object != null;

    /// DO NOT USE ModalRoute.of()
    ///  I don't want to rebuilt the State objects with every Navigator change
//    route ??= ModalRoute.of(state.context); // InheritedWidget?!

    Route<dynamic>? route;

    if (sub) {
      route = currentRoute;
      sub = route != null;
    }

    if (sub) {
      // So to be informed when there are changes to route.
      subscribe(object!, route!);
    }
    return sub;
  }

  /// Remove the State object as a route observer.
  bool unsubscribeState(RouteAware? object) {
    //
    final un = object != null;

    if (un) {
      unsubscribe(object);
    }
    return un;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = null;
    currentRoute = previousRoute;
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = previousRoute;
    currentRoute = route;
    super.didPush(route, previousRoute);
  }

  ///
  Route<dynamic>? currentRoute;

  ///
  Route<dynamic>? previousRoute;
}

///
// mixin StateXRouteAware {
//   /// Called when the State's current route has been popped off.
//   void didPopOff() {}
// }
