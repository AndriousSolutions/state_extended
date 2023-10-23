
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
