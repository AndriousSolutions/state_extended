
## Flutter tests your code

You'll get a real appreciation of the <a href="https://pub.dev/packages/state_extended" rel="noopener noreferrer">state_extended</a> 
package if you review the testing it goes through with every release.
All of what it can do is run in a series of tests to confirm their functionality.
You'll quickly learn what it can do for you too.

In the first screenshot below, these tests begin with the example app itself being started up.
it renders its UI, settles down its animation, and is then ready to receive input.
The <i>WidgetTester</i> object, <i>tester</i>, allows the test environment to programmatically
interact with the widgets you're testing.

The second screenshot continues down the code highlighting those functions performing the integration and unit testing. 
Since in this example app, there is one and only one <i>AppStateX</i> object deemed the 'first' State object
of the app (see <a href="https://pub.dev/documentation/state_extended/latest/topics/AppStateX%20class-topic.html" rel="noopener noreferrer">AppStateX class</a>), 
the function, <i>tester.firstState<AppStateX>()</i>, can reliably retrieve that instance 
to allow for more refined testing.
For example, in the second screenshot below, attaining that State object allows access to 
its controller with properties used to direct testing.

<div>
<a id="testMyApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/88b83615-63c6-4c8b-98c5-7f7841c6cb49" width="48%" height="60%"></a>
<a id="resetPage1CountTester" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6538eb66-cf5f-4515-a7f4-aef52ea800cd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6538eb66-cf5f-4515-a7f4-aef52ea800cd" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L20) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L43) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|

As we process, you can see further features available to you when testing.
The <b>reassembleApplication</b>() function, for example, literally performs a hot reload.
In this case, doing so allows some error handling to be tested when the app goes to 'Page 2.'
You don't purposely place errors in your code, but error handling has to be tested too.
An accompanying example app, and its State object controllers can assist in that effort.
You can call the <b>Exception</b>() function in such an app to test the erroe handling.
<div>
<a id="reassembleApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/622028b8-d9cd-417f-b32f-645c6a509e80"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/622028b8-d9cd-417f-b32f-645c6a509e80" width="48%" height="60%"></a>
<a id="testScaleFactor" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/005a1830-8037-4dc3-bd28-1034e4955146"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/005a1830-8037-4dc3-bd28-1034e4955146" width="48%" height="60%"></a>
</div>

| [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L58) | [widget_test.dart](https://github.com/AndriousSolutions/state_extended/blob/8cde590752621c6dc72e372a7265944520de5b5d/example/test/widget_test.dart#L58) |
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
