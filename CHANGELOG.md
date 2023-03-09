
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
