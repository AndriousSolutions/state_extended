
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
