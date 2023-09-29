
## Flutter tests code
Right out of the box, Flutter offers the tools so you can test your app.<br/>
Automated testing can easily be performed on every aspect of your app.<br />
Such tests fall into some particular categories:
<ul>
  <li>A <a href="https://docs.flutter.dev/testing/overview#unit-tests">unit test</a> tests a single function, method, or class.</li>
  <li>A <a href="https://docs.flutter.dev/testing/overview#widget-tests">widget test</a> (in other UI frameworks referred to as component test) tests a single widget.</li>
  <li>An <a href="https://docs.flutter.dev/testing/overview#integration-tests">integration test</a> tests a complete app or a large part of an app.</li>
</ul>
As always, the Flutter website has abundant documentation on the subject:
<ul>
  <li><a href="https://docs.flutter.dev/testing/overview">Testing Flutter apps</a></li>
  <li><a href="https://docs.flutter.dev/cookbook/testing/unit/introduction">An introduction to unit testing</a></li>
  <li><a href="https://docs.flutter.dev/cookbook/testing/widget/introduction">An introduction to widget testing</a></li>
  <li><a href="https://docs.flutter.dev/cookbook/testing/integration/introduction">An introduction to integration testing</a></li>
  <li><a href="https://codelabs.developers.google.com/codelabs/flutter-app-testing">Codelab: How to test a Flutter app</a></li>
</ul>
<br />
<table>
  	<caption>Contents</caption>
    <tbody>
      <tr>
        <td><a href="#assemble">Assemble</a></td>
        <td><a href="#size">Size</a></td>
        <td><a href="#integrate">Integrate</a></td>
      </tr>
    </tbody>
</table>
Here, I'll introduce some of these tools and present how they're applied to this package.
You'll get a real appreciation of the <a href="https://pub.dev/packages/state_extended" rel="noopener noreferrer">state_extended</a> 
package if you review the testing it goes through before every release.
All of what it can do is run in a series of tests to confirm their proper function.
Review these tests, and you'll quickly learn what this package can do for you.

In the first screenshot below, the tests begin with the example app itself starting up.
It renders its UI, and after it settles down, is ready to receive input.
This is so to begin an integration test.
The <i>WidgetTester</i> object, <i>tester</i>, allows the test environment to programmatically
interact with the widgets being tested.
`tester.pumpWidget(app);` actually calls the <b>runApp</b>() function to start up the example app.

The second screenshot continues down the <b>widget_test.dart</b> file highlighting those functions performing the integration and unit testing. 
Since in this example app, there is one and only one <i>AppStateX</i> object deemed the 'first' State object
of the app (see <a href="https://pub.dev/documentation/state_extended/latest/topics/AppStateX%20class-topic.html" rel="noopener noreferrer">AppStateX class</a>), 
the function, <i>tester.firstState<AppStateX>()</i>, can reliably retrieve that instance 
to allow for more refined testing.
For example, in the second screenshot below, attaining that State object allows access to 
its controller. As it happens, that controller has properties used to direct the testing.

<div>
<a id="testMyApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49" width="48%" height="60%"></a>
<a id="resetPage1CountTester" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6538eb66-cf5f-4515-a7f4-aef52ea800cd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6538eb66-cf5f-4515-a7f4-aef52ea800cd" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L20) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L43) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="assemble">Assemble Your Test</h2>

As we progress, you can see further features available to you when testing.
The <b>reassembleApplication</b>() function, for example, literally performs a hot reload
(see first screenshot below).
In this case, doing so allows some error handling to be tested when the app goes to 'Page 2.'
In the second screenshot below, the <b>Exception</b>() function is explicitly called to invoke an error and test the error handling.
<div>
<a id="reassembleApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/622028b8-d9cd-417f-b32f-645c6a509e80"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/622028b8-d9cd-417f-b32f-645c6a509e80" width="48%" height="60%"></a>
<a id="buildIn" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c4c6bf57-1d3a-4e90-9d1d-d4d1b3fadce4"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c4c6bf57-1d3a-4e90-9d1d-d4d1b3fadce4" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L58) | [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/lib/src/view/app/my_app.dart#L71) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="size">Size Your Test</h2>

Further along in the testing, there's a means to change the physical size of the text displayed
when calling the <b>testScalefactor</b>() function highlighted in the first screenshot above.
Specifically, you can change the scaling factor used when rendering text (see the second screenshot below).
Do so at runtime, and the event handler, <b>didChangeTextScaleFactor</b>(), in the StateX object and its controllers will fire.
<div>
<a id="testScaleFactor" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ff465416-bc8b-4faf-8ca9-f5727ec9f16c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ff465416-bc8b-4faf-8ca9-f5727ec9f16c" width="48%" height="60%"></a>
<a id="textScaleFactorValue" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/9e277c32-d6c6-4415-87e9-415ed3d97340"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/9e277c32-d6c6-4415-87e9-415ed3d97340" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L80) | [test_event_handling.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/test_event_handling.dart#L57) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------:|

In the first screenshot below, the <b>testDidChangeMetrics</b>() function actually changes the screen size of the device.
The second screenshot displays how that is done in that very function. 
Doing so causes the <b>didChangeMetrics</b>() function of any State object and their controllers to fire.
Granted, you may never ever need to consider such events... until one day you do.
<div>
<a id="testDidChangeMetrics" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/09b52e6e-3581-449a-8ab6-79371f4b6b94"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/09b52e6e-3581-449a-8ab6-79371f4b6b94" width="48%" height="60%"></a>
<a id="testDidChangeFunc" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/a94ca994-92b2-44e9-a509-8ffcb1bd43b7"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/a94ca994-92b2-44e9-a509-8ffcb1bd43b7" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L87) | [test_event_handling.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/test_event_handling.dart#L64) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="integrate">Integrate Your Test</h2>

Let's return back up the <b>widget_test.dart</b> file, and look inside the <b>integrationTesting</b>() function. 
An <a rel="noopener noreferrer" href="https://docs.flutter.dev/testing/integration-tests#overview">integration test</a> 
(also called end-to-end testing or GUI testing) runs the full app.
In the video below, 
we see the integration test putting the example app through its paces testing many aspects of the app in real time.
The screenshot beside the video is the beginning of that function.
There, you see the first activity is incrementing the count up to nine.
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/e8357e8e-05fe-4acc-9eea-fb366d013f9c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e8357e8e-05fe-4acc-9eea-fb366d013f9c" width="171" height="357"></a>
<a id="integrationTesting" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/af37188a-6cf6-4de5-aae9-0d5688257569"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/af37188a-6cf6-4de5-aae9-0d5688257569" width="48%" height="60%"></a>
</div>

| [test_example_app.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/integration_test/test_example_app.dart#L15) | 
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<div>
<a id="unitTesting" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6e458c8b-17f4-43ec-b42d-a7db5b1c3d09"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6e458c8b-17f4-43ec-b42d-a7db5b1c3d09" width="48%" height="60%"></a>
<a id="textScaleFactorValue" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/9e277c32-d6c6-4415-87e9-415ed3d97340"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/9e277c32-d6c6-4415-87e9-415ed3d97340" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L80) | [test_event_handling.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/test_event_handling.dart#L57) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------:|

Again, I would suggest you examine the many test files that are downloaded with the
<a href="https://pub.dev/packages/state_extended" rel="noopener noreferrer">state_extended</a> package under the <b>pub.dev</b> folder
and get a better idea how things work in this package and in Flutter.

<a id="pubDev" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/5a4dd7d1-074a-4b6a-a716-9f8ac00071ab"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/5a4dd7d1-074a-4b6a-a716-9f8ac00071ab" width="60%" height="48%"></a>

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
