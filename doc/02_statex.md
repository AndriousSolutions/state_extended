## _The State Class Extended_

Extend the capabilities of Flutter’s own State class.
This class allows you to use
a [State Object Controller](https://pub.dev/documentation/state_extended/latest/topics/State%20Object%20Controller-topic.html)
(SOC) to reliably call the State object's **setState**() function from outside its class — a very
powerful capability!

This class provides the <b>initAsync</b>() function to perform any asynchronous operations before
displaying its contents. It also provides the <b>dependOnInheritedWidget</b>() function to assign a
widget as a 'dependency'
to the StateX's built-in InheritedWidget. It then uses its <b>notifyClients</b>() function to
spontaneously rebuilt only those widgets. Very
powerful!

<table>
  	<caption>Contents</caption>
    <tbody>
    <tr>
       <td><a href="#code">Code</a></td>
       <td><a href="#page">State Pattern</a></td>
       <td><a href="#sync">Sync</a></td>
       <td><a href="#control">Sync</a></td>
       <td><a href="#interface">Interface?</a></td>
       <td><a href="#inherit">Inherit</a></td>
      </tr>
    </tbody>
</table>
The StateX class gives you five new functions and features:


<ul>
   <li>The State Object Controller separates the interface (i.e. the State object's <b>build</b>() function) from everything else:
   <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/StateXController-class.html">StateXController</a></b></li>
   <li>A function to perform any necessary asynchronous operations before displaying the interface:
   <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/AsyncOps/initAsync.html">initAsync</a></b>()</li>
   <li>A means to update only <i>particular</i> widgets in the interface and not the whole screen improving performance:
   <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/InheritedWidgetStateMixin/dependOnInheritedWidget.html">dependOnInheritedWidget</a></b>()
, <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/StateX/didChangeDependencies.html">didChangeDependencies</a></b>()
, <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/InheritedWidgetStateMixin/notifyClients.html">notifyClient</a></b>()
, <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/InheritedWidgetStateMixin/setBuilder.html">setBuilder</a></b>()
, <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/InheritedWidgetStateMixin/updateShouldNotify.html">updateShouldNotify</a></b>()</li>
   <li>A function that runs if any error occurs. Allows you to 'clean up' and fail gracefully:
   <b><a href="https://pub.dev/documentation/state_extended/latest/state_extended/StateXonErrorMixin/onError.html">onError</a></b>()</li>
</ul>


<h3 id="code">Control Your Code</h3>
All your ‘mutable’ code should go into your State Object Controller.
It would contain the ‘business logic’ involved in a given app as well as address any event handling.
Controllers are not new to Flutter.
Two popular widgets that use a controller, for example, is the
<a href="https://github.com/flutter/flutter/blob/66cda5917daacd5e600221be0259b62115078486/packages/flutter/lib/src/material/text_field.dart#L246C13-L246C13">
TextField</a>
widget and
the <a href="https://github.com/flutter/flutter/blob/66cda5917daacd5e600221be0259b62115078486/packages/flutter/lib/src/widgets/single_child_scroll_view.dart#L139">
SingleChildScrollView</a>
widget.

However, unlike those two widgets, a StateX object can have any number of controllers.
This promotes more modular development where each controller is dedicated to a particular
responsibility independent of
other controllers. This further relieves any 'controller bloat' common when involving a controller
(
see [State Object Controller](https://pub.dev/documentation/fluttery_framework/latest/topics/State%20Object%20Controller-topic.html)).

<h3 id="page">State Pattern</h3>
A common pattern seen when implementing a controller for use by a StateX object will have the
controller object
instantiated right in the State object and then referenced here and there in the State object’s <b>
build</b>() function.
Thus providing the data and the event handling. For example, the first screenshot below is of the '
counter example app'
that uses this package. The second screenshot shows how a number of
controllers can be added.

###### (A controller and its use are highlighted by red arrows.)

<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/user-attachments/assets/b3284020-dddb-4bd6-b2fb-638853c6bc15"><img src="https://github.com/user-attachments/assets/b3284020-dddb-4bd6-b2fb-638853c6bc15" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="(https://github.com/user-attachments/assets/0215aa49-282c-49b1-b567-0cfda9325473"><img align="right" src="(https://github.com/user-attachments/assets/0215aa49-282c-49b1-b567-0cfda9325473" width="48%" height="60%"></a>
</div>

| [_MyHomePageState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L26) | [Page1State](https://github.com/AndriousSolutions/state_extended/blob/cbd2af6383e0226c7013cf205cc0a7f0bf6216a8/example/lib/home/view/page_01.dart#L19) |
|:------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h3 id="sync">Sync The State</h3>

There's now a means to deal with asynchronous operations in the State object before rendering its
interface. A common approach has been to execute such operations even before the app
begins---a disjointed approach. The operation is not done by the actual State object (the actual
screen) where it's relevant or required. However, Flutter has always had the FutureBuilder widget to
make this
possible. A FutureBuilder widget is built into the StateX class, and has its <b>initAsync</b>()
function to
then perform such asynchronous operations. As a result, when such a State object is called,
it can wait for its asynchronous operations to complete before proceeding. As easy as that.

Below are three gif files. The first one depicts what a user will see more often than not when
starting up an app written with this package. There's always a remote database to open or web
services to connect to and this takes a little time. You don't want your user staring at a blank
screen. They'll think the app is frozen! A spinner is displayed indicating the app is indeed
running. The second gif
file depicts twelve separate StateX objects waiting to continue. Each has its own individual
asynchronous operation loading a animal graphic from some REST api somewhere. The last gif file
shows the whole startup process for this particular app.
It carry's on and shows you they are indeed individual operations ending with a different picture.

<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/6ccff53b-da0e-41b9-aace-81dc95111254"><img src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/6ccff53b-da0e-41b9-aace-81dc95111254" width="171" height="357"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/25ab69de-b9eb-4c8c-a2d0-9598152bf360"><img src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/25ab69de-b9eb-4c8c-a2d0-9598152bf360" width="171" height="357"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/009afbfb-40a3-4c69-8813-7d7e71e21888"><img src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/009afbfb-40a3-4c69-8813-7d7e71e21888" width="171" height="357"></a>
</div>
In this case, since they're running on an Android emulator, those spinners are from the 
<a href="https://github.com/flutter/flutter/blob/e1702a96f679772847459650670bbe9f04480840/packages/flutter/lib/src/material/progress_indicator.dart#L554">CircularProgressIndicator</a> widget.
If they were running on an iOS phone, the 
<a href="https://github.com/flutter/flutter/blob/e1702a96f679772847459650670bbe9f04480840/packages/flutter/lib/src/cupertino/activity_indicator.dart#L32">CupertinoActivityIndicator</a>
widget would produce the iOS-style activity indicators instead. Flutter is a cross-platform SDK after all.
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/1e846262-a0a5-47e3-891f-1ed7d0308962"><img src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/1e846262-a0a5-47e3-891f-1ed7d0308962" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/e4b9c1ee-803a-4b53-b393-027a510599df"><img align="right" src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/e4b9c1ee-803a-4b53-b393-027a510599df" width="48%" height="60%"></a>
</div>

| [image_api_controller.dart](https://github.com/AndriousSolutions/fluttery_framework/blob/512093984b404e4f2216521a5f95bd6418ea6054/example/lib/src/home/grid_app_example/gridview/controller/image_api_controller.dart#L38) | [working_memory_app.dart](https://github.com/Andrious/workingmemory/blob/master/lib/src/app/controller/working_memory_app.dart#L77) |
|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------:|

<h3 id="control">Control The Sync</h3>

Those three screens above are from the example app supplied with this package.
Yes, there are twelve separate StateX objects on that one screen each loading an animal image.
Actually its their own individual State Object Controller that's performing the
asynchronous download. Above, is a screenshot of that controller's own <b>initAsync</b>() function.
While each controller is calling its <b>_loadImage</b>() function, its associated StateX object will
quietly wait with its indicator spinning away on the screen. Very nice.

The screenshot on the right is another **initAsync**() function from another app altogether.
It demonstrates there can be a number of asynchronous operations performed before an app can
continue. This particular app involves the authentication of the user for example.
If not already logged in a login screen will appear. This function is in another controller
and that controller calls yet another controller to run its own **initAsync**().
See how you're able to separate distinct asynchronous operations
each prefixed with an **await** operator and returning a boolean value to the variable, *init*.
It's all easy to read and all in the right location to be implemented.

It's suggested you implement such operations in a Controller, and not directly in a StateX object.
Besides, the StateX object's own <b>initAsync</b>() function is already implemented:
It's calling all the <b>initAsync</b>() functions from its associated State Object Controllers.
When they're all complete, only then does the StateX object call its <b>build</b>() function.
Since most asynchronous operations have no direct relation to an app’s interface,
you’ll likely have your asynchronous stuff running in a State Object Controller anyway
with the rest of the app’s business logic. See how that works?

There can be individual controllers running their own **initAsync**() function. Very clean. Very
modular.

<h3 id="inherit">Inherit The State</h3>

<p>You've may have been introduced to the InheritedWidget, 
and how it allows you to repel down the widget tree any piece of data you've designated. 
However, a more intriguing feature is whenever you call an already instantiated InheritedWidget, 
any widgets assigned as its dependents are rebuilt (their <b>build</b>() functions run again)---as if their <b>setState</b>()
functions were explicitly called.Now that allows for improved performance with the refresh of only specific areas of the interface.
</p>
Even the efficiency of the humble 'counter app' is greatly improved. Instead of refreshing 
the whole screen (including the StatelessWidget with its 'You have pushed the button this many times')
, when the 'Use the built-in InheritedWidget' switch is on, only the lone widget displaying the
current count is then ever rebuilt. The rest of the screen would now be left alone with every 
press of that button. Granted this is a very simple interface and possibly a bad example,
but look how easy this is implemented in the screenshot below.
<div>
  <a href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/12dccbda-b8e6-46ca-b1d2-ddc8a134f0da"><img src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/12dccbda-b8e6-46ca-b1d2-ddc8a134f0da" width="45%" height="50%"></a>
  <img align="right" src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/bfb0c949-f15a-4a84-b4e9-d3e789a3e92b" width="171" height="357">
  <img align="right" src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/9557a498-2a8b-40a4-8d49-189b5120bde4" width="171" height="357">
</div>

| [counter_app.dart](https://github.com/AndriousSolutions/fluttery_framework/blob/4dc676193914808583f111006334a91a08475b7f/example/lib/src/home/view/counter_app.dart#L41) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<p>The <b>setBuilder</b>() function found will allow for this immediate
improvement in efficiency. When it comes to interfaces, the less that's rebuilt, the better.
</p>
<p>Back to the app with its grid of animal pictures, you can see above when the 'new dogs' text button
is pressed, only the three 'dog pictures' are downloaded again. What your seeing are only
three portions of the screen being updated---only three widgets being rebuilt. If the whole screen was
rebuilt, all the pictures would change. Not very effective.</p>

<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/fa7f226f-7624-49a0-9d5d-598bdb936ed8"><img src="https://github.com/AndriousSolutions/fluttery_framework/assets/32497443/fa7f226f-7624-49a0-9d5d-598bdb936ed8" width="50%" height="60%"></a>

| [counter_app.dart](https://github.com/AndriousSolutions/fluttery_framework/blob/4dc676193914808583f111006334a91a08475b7f/example/lib/src/home/grid_app_example/gridview/view/image_api.dart#L38) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

The screenshot above depicts one of the three widgets being assigned as a dependent to
a State object's InheritedWidget using the <b>dependOnInheritedWidget</b>() function.
In fact, the State object's controller with its own <b>dependOnInheritedWidget</b>() function
is actually used.
