
## Flutter tests your code

You'll get a real appreciation of the <a href="https://pub.dev/packages/state_extended" rel="noopener noreferrer">state_extended</a> 
package if you review the testing it goes through with every release.
All of what it can do is run in a series of tests to confirm their proper functionality.
Review these tests, and you'll quickly learn what this package can do for you.

In the first screenshot below, these tests begin with the example app itself starting up.
It renders its UI, in moments, it settles down its animation, and is then ready to receive input.
The <i>WidgetTester</i> object, <i>tester</i>, allows the test environment to programmatically
interact with the widgets you're testing.

The second screenshot continues down the code highlighting those functions performing the integration and unit testing. 
Since in this example app, there is one and only one <i>AppStateX</i> object deemed the 'first' State object
of the app (see <a href="https://pub.dev/documentation/state_extended/latest/topics/AppStateX%20class-topic.html" rel="noopener noreferrer">AppStateX class</a>), 
the function, <i>tester.firstState<AppStateX>()</i>, can reliably retrieve that instance 
to allow for more refined testing.
For example, in the second screenshot below, attaining that State object allows access to 
its controller with properties used to direct the testing.

<div>
<a id="testMyApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49" width="48%" height="60%"></a>
<a id="resetPage1CountTester" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6538eb66-cf5f-4515-a7f4-aef52ea800cd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6538eb66-cf5f-4515-a7f4-aef52ea800cd" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L20) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L43) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|

As we progress, you can see further features available to you when testing.
The <b>reassembleApplication</b>() function, for example, literally performs a hot reload
(see first screenshot below).
In this case, doing so allows some error handling to be tested when the app goes to 'Page 2.'
Error handling has to be tested too, 
and so an accompanying example app with its State object controllers can assist in that effort.
For example, you can explicitly call the <b>Exception</b>() function in such an app to test the error handling.
<div>
<a id="reassembleApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/622028b8-d9cd-417f-b32f-645c6a509e80"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/622028b8-d9cd-417f-b32f-645c6a509e80" width="48%" height="60%"></a>
<a id="testScaleFactor" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/013cb75c-9925-4ad2-a47a-907d4ae66bf7"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/013cb75c-9925-4ad2-a47a-907d4ae66bf7" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L58) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L80) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------:|

Further along in the testing, there's a means to change the physical size of the text displayed or
even the size of the device's screen when calling the functions highlighted in the second screenshot above.
Specifically, you can change the scaling factor used when rendering text.
Do so at runtime, and the event handler, <b>didChangeTextScaleFactor</b>(), in the StateX object and its controllers will fire.
This is tested in the <b>testScalefactor</b>() function presented in the first screenshot below.
The second screenshot below of the <b>testDidChangeMetrics</b>() function actually adjusts the screen size
causing the <b>didChangeMetrics</b>() function of any State objects and their controllers to of course fire.
You may never ever need to consider such events until one day you do.
<div>
<a id="textScaleFactorValue" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/9e277c32-d6c6-4415-87e9-415ed3d97340"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/9e277c32-d6c6-4415-87e9-415ed3d97340" width="48%" height="60%"></a>
<a id="testDidChangeMetrics" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/a94ca994-92b2-44e9-a509-8ffcb1bd43b7"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/a94ca994-92b2-44e9-a509-8ffcb1bd43b7" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L58) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L80) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------:|

An <a rel="noopener noreferrer" href="https://docs.flutter.dev/testing/integration-tests#overview">integration test</a> 
(also called end-to-end testing or GUI testing) runs the full app.
The video below, 
we see the integration test putting the example app through its paces testing many aspects of the app in real time.
The screenshot beside the video is the beginning on the Integration test function.
There, you see the first activity is incrementing the count up to nine.
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/e8357e8e-05fe-4acc-9eea-fb366d013f9c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e8357e8e-05fe-4acc-9eea-fb366d013f9c" width="171" height="357"></a>
<a id="integrationTesting" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/af37188a-6cf6-4de5-aae9-0d5688257569"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/af37188a-6cf6-4de5-aae9-0d5688257569" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L58) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L80) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------:|

Another advantage of factory constructors in your State object controllers,
you simple instantiate a controller in your testing,
and you have the direct means to perform unit or widget testing.
A controller will have access to any number of State objects at some point in the testing.

<div>
<a id="testMyApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49" width="48%" height="60%"></a>
<a id="firstState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/8843075a-fb36-439d-af03-0c5ca43cea88"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/8843075a-fb36-439d-af03-0c5ca43cea88" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L20) | [test_statex.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/test_statex.dart#L19) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
