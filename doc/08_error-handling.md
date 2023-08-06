## _It's Essential Yet Ignored_

Any errors that may occur in a StateX object is directed to its function, <b>onError</b>().
Depending on whether it's a particular exception that can be handled, or an unanticipated error
that will cause the app to terminate, the <b>onError</b>() will first receive the details.
This is an opportunity for you to close any critical resources or service and 'fail gracefully'
before the error is then recorded in the device logs.
```Dart
  /// This function is called when an error occurred.
  void onError(FlutterErrorDetails details) {}
```

<table>
  	<caption>Contents</caption>
    <tbody>
      <tr>
        <td><a href="#state">Error In State</a></td>
        <td><a href="#count">Count On Errors</a></td>
        <td><a href="#firebasecrashlytics">Use FirebaseCrashlytics</a></td>
        <td><a href="#seeing">Seeing Red</a></td>
      </tr>
    </tbody>
</table>
<img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e5ccb8a5-6f25-441e-8daa-3fcd7ab3466d" width="171" height="357">
When starting up the example app that accompanies the <b>state_extended</b> package,
you're presented with a variation of the counter app.
It's three pages of counter apps each highlighting particular functions and features.
With the first page, for example, one feature demonstrated is the handling of an error every time you press the '+' button.
The error is caught and yet the count incremented regardless. 
Because the error was anticipated, it's recorded and then the app increments as intended.
The State object, <i>Page1State</i>, catches this particular error in its <b>onError</b>() function.

In the first screenshot below, is of the <b>FloatingActionButton</b> widget containing the error.
As you see, an <b>Exception</b> is deliberately thrown when the button is tapped.
(Note, the error is not thrown when running in a test environment.)
Such an error would normally cause Flutter's default handler, <a href="https://api.flutter.dev/flutter/foundation/FlutterError/dumpErrorToConsole.html">dumpErrorToConsole</a>, 
to record the error in the device's error logs.
If the error had occurred while attempting to display a widget,
it would further present a description of the error on a 'red screen' when in development,
and a gray screen when in production.

In this case, the error logs are written to, but the count still incremented. Flutter's
<a href="https://api.flutter.dev/flutter/foundation/FlutterError/onError.html">FlutterError.onError</a>
was assigned an error handler that allows the State object to possibly address its errors.
In the second screenshot below, the <b>onError</b>() function determines the incrementation was interrupted
and so attempts once again. This is a very simple example, but you can see the potential to better handle
certain circumstances in your own app.
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/1d5e0dce-4e6a-4974-9a5d-9815a80b6fcc"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/1d5e0dce-4e6a-4974-9a5d-9815a80b6fcc" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b6ec9861-dacb-4e18-ac8b-3be8e63781f9"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b6ec9861-dacb-4e18-ac8b-3be8e63781f9" width="48%" height="60%"></a>
</div>

| [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/8e706d0751db51c9da77b87b036b4a98ae4bb1a7/example/lib/src/view/home/page_01.dart#L89) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/8e706d0751db51c9da77b87b036b4a98ae4bb1a7/example/lib/src/view/home/page_01.dart#L184) |
|:-------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|

The <b>onError</b>() function is supplied by the mixin, <a href="https://github.com/AndriousSolutions/state_extended/blob/096993bab8d13790af065b94f0bdf32e1967904e/lib/state_extended.dart#L2643">StateXonErrorMixin</a>.
The <b>StateX</b> class utilizes it, but the <b>StateXController</b> does not. However, it can if the need arises.
Care must be taken when implementing the <b>onError</b>() function in Controllers as one may catch an error
intended for another. But if used judiciously, there may be instances where a controller should catch and handle any failed operation of its own doing.

The first screenshot below demonstrates how you might seek out such controllers when the '+' button error occurred.
The StateX object goes through its controllers and calls those with a <b>onError</b>() function of their own.
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6aa1d170-631d-4bc2-b372-2f263f2b796d"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6aa1d170-631d-4bc2-b372-2f263f2b796d" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ea64ab79-a43a-45a2-afd5-d4eefbca4be5"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ea64ab79-a43a-45a2-afd5-d4eefbca4be5" width="48%" height="60%"></a>
</div>

| [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/8e706d0751db51c9da77b87b036b4a98ae4bb1a7/example/lib/src/view/home/page_01.dart#L192) | [yet_another_controller.dart](https://github.com/AndriousSolutions/state_extended/blob/096993bab8d13790af065b94f0bdf32e1967904e/example/lib/src/controller/home/yet_another_controller.dart#L7) |
|:-------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
