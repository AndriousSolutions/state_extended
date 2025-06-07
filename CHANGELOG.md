
## 6.2.3
June 07, 2025
- Corrected _pushStateToSetter with if(_stateXSet.add(stateX);

## 6.2.2
June 07, 2025
- static AppStateX._instance deprecated and no longer to be used.
- _pushStateToSetter rewrite with _stateXSet.contains(stateX) || _stateXSet.add(stateX);
- Using runZonedGuarded<void>(() { was not advantageous and removed.
- AppStateMixin now has the abstract getter, appStateX
- appStateX getter includes _appStateX = lastContext?.findAncestorStateOfType<AppStateX>();
- Rewrite of class SetBuilder with
  appState = context.findAncestorStateOfType<AppStateX>();
- In part14_set_state_mixin.dart: StateX? get state => _stateX;
                                  set state(covariant StateX? state) => _stateX = state;
- Deprecated getter recHasError. Use hasErrorInErrorHandler instead
- class _PrivateGlobalKey no longer used

## 6.2.1+1
June 02, 2025
- Introduced WidgetsBindingInstanceMixin with static boolean inWidgetsFlutterBinding
- detachedAppLifecycleState() removed from AppStateX
- if (state.mounted && !state._deactivated) removed from forEachState() 
- In StateX, deactivate() called in inactiveAppLifecycleState(); activate() called in resumedAppLifecycleState()
  dispose() called in detachedAppLifecycleState()
- _removeFromMapOfStates(this); and WidgetsBinding.instance.removeObserver(this); now in StateX.dispose()
- _instance = null; now in AppStateX.dispose()
- runZonedGuarded() now in dispose(), inactiveAppLifecycleState(), resumedAppLifecycleState()
- default clause is commented out

## 6.2.0+2
May 31, 2025
- Renamed RecordExceptionMixin to ErrorInErrorHandlerMixin
- // If State prints events, so does its Controllers
  in StateX constructor and in initAsyncState()
- Deprecated recordException() for recordErrorInHandler()
- Additional test scripts
  tester.binding.handleAppLifecycleStateChanged();
  .initAppAsyncError = true;.initAsyncFailed = true;.errorCatchAsyncError = true;.initAsyncError = true;

## 6.1.1+4
May 28, 2025
- con._popStateFromSetter(); before con.deactivate(); in part01_state.dart
- Deprecated printEvents with debugPrintEvents
- To pass static analysis in  part12_rebuild_controller_states_mixin.dart:110:34
  // ignore: deprecated_member_use_from_same_package
- Using flutter_test.dart:TestFailure in part04_app_statex.dart
- Test stateObj.useInherited in test_statex.dart
- // ignore_for_file: unused_local_variable in test_statex.dart
- Resolved doc reference [pausedAppLifecycleState] in mixin, StateXEventHandlers
- // ignore: deprecated_member_use_from_same_package for both
  part12_rebuild_controller_states_mixin.dart and part17_app_state_mixin.dart

## 6.1.0+1
May 19, 2025
- Replaced mixin, StateListener, with StateXEventHandlers
  used now by both StateX and StateXController
- Optionally use debugPrint() in every event handler
- Both StateX and StateXController now use onError()
- Rewrite of Example app with MultiTabsScaffold
- Removed unused local variables and format files

## 6.0.0
May 04, 2025
- AppStateX now has static AppStateX? _instance
- AppStateX parameter, bool? notifyClientsInBuild, no longer offered.
- AppStateX stateSet() renamed setBuilder()
  built-in InheritedWidget is always called with every setState((){});
- Renamed RootStateMixin to AppStateMixin (rootState to appState)
- @Deprecated('Use appCon instead.')
  StateXController? get rootCon => appCon;
- StateXController's initAsync(), initState(), dispose() are now only called once.
  initAsyncState(), stateInit() and disposeState() now called with evey new State.
- StateXController's deactivate() and activate() are now only called once.
  deactivateState() and activateState() now called with evey State.
- mixin StateListener revamped and renamed StateXEventHandlers
- bool get inDebugMode {
- class SetState renamed class SetBuilder
  _key = _PrivateGlobalKey<_SetBuilderState>(_SetBuilderState(builder));
- lastContext in a StateXController is the 'latest' State object it's associated with.
- Removed universal_platform: ^1.0.0
- Updated Example app
- Reorganized the files and directories

## 5.11.0
March 31, 2025
- Future<bool> catchAsyncError(Object error)  // Catch errors in initAsync() throws an error
- getter caughtAsyncError // Error is caught and handled accordingly
- bool onStateError() rethrow error while in developing
- getter recErrorException gives the  recorded error or exception
- getter recHasError indicates if an exception had occurred.
- getter recStackTrace returns recorded Stack Trace

## 5.10.0+1
February 28, 2025
- In StateX class:  catch (e) { to catch (e, stack) {
- In InheritedWidgetStateMixin: Replace stateSet() with setBuilder(WidgetBuilder? builder)
- New getter in AppStateX class: inErrorRoutine
- Rewrite of class _BuilderState
- Renamed mixin RootState to RootStateMixin
- Update: universal_platform: ^1.0.0 -> ^1.1.0

## 5.9.0
December 14 ,2024
- in part13_statex_controller.dart, call all listeners in both
  notifyClients(); and setState(); using notifyListeners();
- 
## 5.8.0
November 20, 2024
- Allow the setState() function call in a number of event handlers
  // _setStateAllowed = false;

## 5.7.0
November 16, 2024
- Make ChangeNotifier private in mixin, ImplNotifyListenersChangeNotifierMixin

## 5.6.1
November 15,2024
- Removed mixin, ChangeNotifier, from class StateXController to be accessed indirectly
  using a new mixin, ImplNotifyListenersChangeNotifierMixin, that contains it as a property.
  This is because ChangeNotifier has no, super.dispose(), in its dispose() function.

## 5.6.0+1
November 14, 2024
- Introduce setBuilder() in every Controller. Will rebuild with every setState() call.
- Replacing stateSet(WidgetBuilder? builder) with the name, setBuilder in class, StateX and AppStateX
- class StateXController now includes mixin, ChangeNotifier and ListenableWidgetBuilderMixin
- Updated example app

## 5.5.0
October 14, 2024
- AppStateX class now has the notifyClientsInBuild parameter. Defaults to true.
  This then notifies any dependencies when calling for a rebuild.
- The runInitAsync() function in every StateX object
  now allows their initAsync() functions to be conditionally called with every rebuild.

## 5.4.0
October 07, 2024
- Built-in InheritedWidget is now called with AppState's setState() function

## 5.3.0
October 06, 2024
- getter, lastErrorMessage, in AppState class in part08_app_statex.dart

## 5.2.4
October 05, 2024
- Class, AppState, has lastFlutterError() to record and return 
  the 'last' Flutter error.

## 5.2.3
October 04, 2024
- *BUGFIX* Removed 'default' Error Handler mistakenly left in Production.
- *BUGFIX* Removed 'default' Error Widget Builder mistakenly left in Production.
- User Error Handler, onError(), in part08_app_statex.dart.
- If onError() is not overridden, Flutter's own Error Handler is called.
- New getter, stateErrorHandled, can be set true by user.
- Function, handledStateError(), reads getter value and resets to false.

## 5.2.2
September 26, 2024
- Replace print() with debugPrint() functions
- if (mounted) {  // Special case: Test if already disposed
    super.dispose();

## 5.2.1+1
September 25, 2024
- Introduce getters, deactivated and disposed in part01_statex.dart
  if (_deactivated) and if (_disposed || !_deactivated) in part01_statex.dart
- Provide test_run_mixins.dart with more tests.

## 5.2.0+1
September 23, 2024
- Parameter, 'showBinding', renamed 'printEvents'
- catchAsyncError() with try..catch in FutureBuilderStateMixin
- con.onAsyncError() with try..catch  in part18_async_ops_mixin.dart
- appState.builder() with try..catch in part10_builder_statefulwidget.dart
- Call a group of tests: group('Test state_extended', testStateExtended);

## 5.1.0
September 20, 2024
- catchAsyncError() for mixin FutureBuilderStateMixin

## 5.0.0+3
September 04, 2024
- Remove all deprecated properties, functions, and methods
- Introduce RouteObserverStates.subscribeRoutes(this); in route_observer_states.dart
- Print in triggered events with showBinding == true.
- Remove updateNewStateX() from StateX. Not necessary.
- detachedAppLifecycleState() in mixin StateListener
- Remove all commented out code
- Replace runAsync(); with intiAsync();
- Replace buildIn() with builder();
- Introduce _BuilderState and _InheritedWidgetState to AppState.buildF()
  Calls both builder() and built-in InheritedWidget separately
- Rename bool forEach() to bool forEachState()
- mixin RecordExceptionMixin to mixin RecordExceptionMixin on State
- Update README Example app
- Separated tests into some Dart files
- Renamed part files
- Commented out mixin StateXRouteAware 
- Commented out void '_copyOver' functions
- Removed InheritedWidgetStateMixin testing in RunFutureBuilderStateMixin Widget

## 4.24.0
August 18, 2024
- AppStateX now has FlutterError.onError = _currentErrorFunc; in deactivate() since removed from dispose()
- AppStateX now has useInherited = false by default
- No longer needed class _StateStatefulWidget or class _InheritedState or class _BuildInState
- if (rootState == null) { WidgetsBinding.instance.removeObserver(this); in deactivate()
- Deprecated state(WidgetBuilder? widgetFunc) {  Use stateSet(WidgetBuilder? widgetFunc) {  instead

## 4.23.0
August 05, 2024
- @Deprecated('Use stateSet() instead.')
  Widget state(WidgetBuilder? widgetFunc) {

## 4.22.1
August 05, 2024
- didUpdateWidget(StatefulWidget oldWidget) { to didUpdateWidget(covariant T oldWidget) {
                                             and didUpdateWidget(covariant StatefulWidget oldWidget) {
## 4.22.0
July 25, 2024
- /// Call the latest SateX object's error routine
  /// Possibly the error occurred there.
  bool onStateError(FlutterErrorDetails details) {
- /// Logs 'every' error as the error count is reset.
  void logErrorDetails(FlutterErrorDetails details) {

## 4.21.0
July 22, 2024
- AppState.errorStateName - String getter naming last State class throwing an error
- isEndState is deprecated, use lastState instead 
- startState is deprecated, use firstState instead

## 4.20.0
July 14, 2024
- AppState class loops through all the app's StateX objects when an event occurs.
  Each StateX class will otherwise register as its own binding observer:
  WidgetsBinding.instance.addObserver(this);
- The getter, didCallChangeEvent, serves as a flag for event handling
  // Already called by another State object currently running.
  if (didCallChangeEvent) {
- didPushRoute(String route) is now deprecated after v3.8.0-14.0.pre

## 4.19.0
July 10, 2024
- AppState.detachedAppLifecycleState() 'attempts' to call State object's deactivate() and dispose()
- AppState.didChangeAppLifecycleState() encompasses life cycle event flags.
- Renamed event flags: inactive, hidden, paused, resumed, detached to
  _inactiveAppLifecycle, _hiddenAppLifecycle, _pausedAppLifecycle, _resumedAppLifecycle, _detachedAppLifecycle
- Renamed the functions:
  inactiveAppLifecycle(), hiddenAppLifecycle(), pausedAppLifecycle(), resumedAppLifecycle(), detachedAppLifecycle()
- Removed @protected from methods to be used outside an instance member's subclasses:

## 4.18.0
June 15, 2024
- getter usingCupertino assigned a local variable
- CupertinoActivityIndicator and CircularProgressIndicator used by default
- Increase test coverage

## 4.17.0
June 06, 2024
- Flag defaults to false: _useInherited = useInherited ?? false;
- Deprecated class StateF. Instead use StateX class with 'runAsync: true'
  Deprecated class StateIn. Instead use StateX class with 'useInherited: true'
- getter, useInherited, is also true if buildIn() id overridden
- Don't ever use build() now. Instead use new function, builder()
  Or use buildIn() to work with the built-in InheritedWidget like 'useInherited: true'
- New getter, builderOverridden

## 4.16.1
May 27, 2024
- Cat and Bird images now come from https:\\api.sefinek.net

## 4.16.0
May 26, 2024
- The function, runAsync(), is *deprecated*.
  Set to true the parameter, runAsync, instead.
- getter, InheritedWidgetStateMixin, moved to InheritedWidgetStateMixin

## 4.15.0
May 18, 2024
- _StateXInheritedWidget() to StateXInheritedWidget()
  making it publicly available.

## 4.14.0
May 17, 2024
- class StateIn, now has abstract method:
  Widget buildIn(BuildContext context);
- Flag defaults to true: _useInherited = useInherited ?? true;
- Call built-in InheritedWidget is buildIn() function is being used:
  _useInherited && _buildInOverridden ? _StateXInheritedWidget(

## 4.13.0
April 15, 2024
- catchError() takes FlutterErrorDetails parameters
- snapshot.stackTrace in _futureBuilder()

## 4.12.0
March 17, 2024
- Deprecated getter, startState. Use getter firstState instead
- Deprecated getter, endState. Use getter lastState instead

## 4.11.0
February 18, 2023
- Deprecated 
  Set<StateX> get states - Set of States is too accessible
- Introduced these getters instead:
  StateX? get startState
  StateX? get endState

## 4.10.0
January 24, 2023
- StateX({StateXController? controller, bool? runAsync, bool? useInherited}) {
  A new optional parameter, runAsync, to run built-in FutureBuilder with every build
- abstract class StateF<T extends StatefulWidget> extends StateX<T>
  A State class to run built-in FutureBuilder with every build

## 4.9.0
December 14, 2023
- getter buildOverridden & buildFOverridden set when 'build' functions are overwritten 
- Notify the developer the 'built-in' InheritedWidget is set for use and yet the buildIn() function is not used.

## 4.8.5
November 26, 2023
- Allow for additional controllers to be added in a previous initAsync()
  while (cnt < controllerList.length) {
  cnt++;

## 4.8.3
November 26, 2023
- Allow for additional controllers to call their initState() if added in a previous initState() call
  while (cnt < controllerList.length) {
- Container() to SizedBox() in splash_screen.dart

## 4.8.2
October 25, 2023
- didUpdateController() in didUpdateWidget() in special cases

## 4.8.1
October 23, 2023
- (state != null && state is StateX) remove necessary cast

## 4.8.0
October 23, 2023
- State? to StateX? for getter startState & endState

## 4.7.0+3
September 27, 2023
- Introduced new event handler: hiddenLifecycleState()
- Fixed class _SetStateWidget with stateX.dependOnInheritedWidget(context);
- if (!mounted) { in event handle functions
- Updating test_statex.dart
- Updated documentation topic testing
- Continue with more documentation

## 4.6.0
August 31, 2023
- Improved StateX onError() routine
- More Error handling in _futureBuilder()
- In development, rethrow errors in error handler
- Function containsType<T>() in StateX
- Splash screen in example app
- Expanded unit testing

## 4.5.1+2
August 28, 2023
- Localizations in FutureBuilderStateMixin
- getter usingCupertino
- notifyClients() has try..catch
- Update didPushRouteInformation()
- rootCon now returns the 'root' controller
- Corrected the test routines and documentation

## 4.4.0+1
August 19, 2023
- Includes an onSplashScreen routine
- onError routine also involves particular libraries
- initAsync() now only ever called once;
- Includes getter snapshot
- Continues with documentation: Get Started

## 4.3.0
August 10, 2023
- Added the contains() function in mixin _ControllersById
- Continue with more documentation

## 4.2.0+4
August 04, 2023
- Introduced onError(details) {} to the StateX class
- _key = ValueKey<StateX>() with the InheritedWidget, _StateXInheritedWidget
- List<StateXController> get controllerList is made available.
- Increase the testing coverage over the source code
- Introduce more documentation

## 4.1.1
August 01, 2023
- Unlike StateX, AppStateX uses both its InheritedWidget and its buildIn() function
  but InheritedWidget can be called separately allowing for only dependencies rebuilds 
- Updated test scripts


## 4.1.0
July 31, 2023
- For the AppStateX, included the option to use the built-in InheritedWidget or not
  AppStateX({StateXController? controller,
    List<StateXController>? controllers,
    bool? useInherited,
    Object? object,
  })

## 4.0.0+2
July 30, 2023
- StateX now has a built-in InheritedWidget
- named parameters now in the its constructor:
  StateX({StateXController? controller, bool? useInherited}) {
- Defaults to not using the built-in InheritedWidget be a subclass uses it:
  abstract class StateIn<T extends StatefulWidget> extends StateX<T> {
- @protected appropriate methods

## 3.5.0+1
June 12, 2023
- New System event: WidgetsBindingObserver.didRequestAppExit()

## 3.4.0
May 27, 2023
- Rename StateSetter to SetStateMixin. Conflicted with latest Flutter

## 3.3.0+1
May 19, 2023
- Record any errors in initAsync()
- Adjusted code for Dart's future multi-window support

## 3.2.2+3
May 14, 2023
- StateX's FutureBuilder will only run once.
  _ranAsync changed the widget tree and so replaced with _future = runAsync();

## 3.2.1
May 08, 2023
- StateX's FutureBuilder should only run once.
  _ranAsync ? buildF(context) : FutureBuilder<bool>( 

## 3.2.0+1
May 07, 2023
- Removed the StateListeners mixin 

## 3.1.0
May 07, 2023
- Introduced runAsync() in FutureBuilderStateMixin to allow initAsync() to run repeatedly.

## 3.0.0
May 01, 2023
- AppStateX can take in multiple instances of the same Controller class
- AppStateX has controllerById() to retrieve such instances. 
- StateX can only take in single instances of a Controller class.
- StateX has controllerByType() to retrieve by class type.
- AppStateX controllers are available to all StateX objects in the app.
- _initAsync() in FutureBuilderStateMixin was incorrect!

## 2.8.0+1
March 26, 2023
- mixin StateListener implements RouteAware
- void didChangeLocales(List<Locale>? locales)
- Include tests for the class RouteAware

## 2.7.1
March 15, 2023
- didChangeAccessibilityFeatures corrected to include _setStateAllowed
- Add further testing of the source code

## 2.7.0+3
March 15, 2023
- Removed bool get inFlutterTester so to be Web compatible
- Introduce void didChangeLocales(List<Locale>? locales) {
- Continued to increase the testing coverage over the source code

## 2.6.0
March 11, 2023
- bool get isEndState now used to determine if the 'latest' State object.
- Only the 'latest' State object is rebuilt with setState() after a system event.

## 2.5.4+1
March 09, 2023
- didChangeLocale(Locale? locales) to didChangeLocales(List<Locale>? locales)
- Introduced system event indicator: bool get hadSystemEvent
- _rebuildRequested removed
- Adjusting further testing

## 2.5.3+4
March 08, 2023
- Bugfix. setState() no longer called in System events. 
- Kept updateNewStateX() as it may be useful in special circumstances.
- Added further testing

## 2.5.2
March 06, 2023
- System events from WidgetsBinding.instance.addObserver(this); destroys current State object!
- Introduced updateNewStateX() to compensate for destroyed current State object.
- Corrected FutureBuilderStateMixin with _initAsync()
- i.e. Run the StateX object's initAsync() until it returns true

## 2.5.1+7
March 04, 2023
- StateX.notifyClients() was corrected.
- Replace buildChild() function with buildIn() function
- Updated example app in README.md
- testEventHandling(tester); in testing
- Added further testing

## 2.5.0+2
February 27, 2023
- RecordExceptionMixin stores the last error
- onAsyncError() no longer returns boolean
- Removed getter, Map<String, StateXController> get map
- bool forEach(void Function(StateXController con) func, {bool? reversed}) {
- bool forEachState(void Function(StateX state) func, {bool? reversed}) {
- startState and endState introduced to the StateX class
- WidgetsBinding.instance in activate() & deactivate()
- Incrementally adding tests for a higher percentage in Codecov

## 2.4.0
February 21, 2023
- Replace buildWidget() function with buildF() function

## 2.3.0
February 17, 2023
- onError(FlutterErrorDetails details) removed from the StateX class
  It was been proven ineffective and instead degraded performance.
- Corrected the 'Hello!' Example App 

## 2.2.0+1
February 15, 2023
- Updated example app
- Deprecated refreshLastState() for rebuildLastState()

## 2.1.1
February 04, 2023
- Corrected getter rootState => RootState._rootStateX;
- refreshLastState() function now in AppStateX

## 2.1.0
January 23, 2023
- class _AppInheritedElement allows for better debugging

## 2.0.0
January 18, 2023
- **BREAKING CHANGE** Renamed remove() to bool removeByKey(String keyId) {
- included void didUpdateWidget(Page1 oldWidget) { in example app
- New function: String remove(StateXController? controller) {

## 1.1.0+01
September 16, 2022
- buildInherited() and refresh() are deprecated.
- Corrected the widget_test.dart. notifyClients() to setState()

## 1.0.0
September 10, 2022
- Production release

## 0.8.0+02
 August 18, 2022
- Removed inappropriate class Swx
- StateSetter from class to mixin
- Updated and corrected README.md

## 0.7.0
 August 16, 2022
- New example app: counter_app.dart
- New: class Swx extends StatefulWidget {

## 0.6.0
 July 24, 2022
- Removed getter inheritedStatefulWidget
- Call initInheritedState() in buildWidget()
- Merged mixin InheritedStateMixin with InheritedStateX

## 0.5.0
 July 22, 2022
- Renamed text from 'mvc_pattern.dart' to 'state_extended.dart'
- Removed void refresh() => setState(() {});
- Enhanced example apps with demonstration code.

## 0.4.0+02
 July 15, 2022
- Removed the refresh() function
- Removed the class, StateXModel
- call _states.clear() in AppStateX
- Updated README.md
- Updated test scripts

## 0.3.0
 July 11, 2022
- Changed keyId to identifier in mixin StateListener

## 0.2.0
 July 10, 2022
- Removed abstract class AppStatefulWidget
- abstract class AppStateX<T extends StatefulWidget>
- if (!notify) {
    /// if the 'object' value has changed. 
    notify = dataObject != oldWidget.dataObject;
  }
  
## 0.1.0
 July 07, 2022
- Initial commit
