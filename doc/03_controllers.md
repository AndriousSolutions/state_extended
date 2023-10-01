When first learning Flutter, you've likely encountered one particular warning message over and over again (see below).
That's because you're not taking full advantage of Flutter’s declarative approach to programming.
In the screenshot, the keyword, <i>final</i>, was removed from the instance variable, <i>title</i>,
allowing that variable's value to possibly be 'changed' during the runtime of that particular StatefulWidget.

<a id="immutable" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/aa306774-cf4e-437c-a048-b05cc90d7edf"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/aa306774-cf4e-437c-a048-b05cc90d7edf" width="48%" height="60%"></a>

<table>
  	<caption>Contents</caption>
    <tbody>
    <tr>
       <td><a href="#state">State</a></td>
       <td><a href="#control">Control</a></td>
       <td><a href="#example">Example</a></td>
       <td><a href="#setState">Set Control</a></td>
       <td><a href="#functions">Functions</a></td>
       <td><a href="#events">Events</a></td>
       <td><a href="#which">Which State</a></td>
       <td><a href="#context">Context</a></td>
       <td><a href="#app">App</a></td>
     </tr>
    </tbody>
</table>

<h2 id="inevitable">It's Inevitably Immutable</h2>

Your app's StatelessWidgets and StatefulWidgets are to contain unchanging (immutable) instance fields and properties.
If not, you're actually impeding Flutter’s general functionality and degrading its overall performance.
The less that changes, the better.
Use the keyword, <i>final</i>, for variables assigned only once.
Better still, use the keyword, <i>const</i>, if you know the property's value 
before compile-time will never change.
As your app runs, Flutter is calling those widgets over and over again.

<b>“There is no imperative changing of the UI itself (like widget.setText)—you change the state,
and the UI rebuilds from scratch.”</b>
<br />
— flutter.dev <a href="https://docs.flutter.dev/data-and-backend/state-mgmt/declarative">Start thinking declaratively</a>

Now, I suspect in the beginning, all your ‘mutable’ code was going into your State class. 
A reasonable idea at first glance. 
After all, you always want ready access to the State object and its <b>setState</b>() function. 
However, that can make for a rather large and unmanageable Dart file
placing all the business logic and such under one State class.
I quickly found, more often than not, placing such code in a separate Dart file in a separate class made for a better approach.
You're explicitly separating the app's interface from its business rules.
Looking how Flutter implemented such an approach already using Controllers in widgets,
I created the 'State Object Controller' class.

Again, however, when working with Flutter, you always need reliable access to a particular State object so to call its <b>setState</b>() function 
(other developer's choose instead the StatefulElement’s <b>markNeedsBuild</b>() function). 
Doing so ‘rebuilds’ that portion of the screen involving that State object and reflects the changes made.
That means the State Object controller would need access to its designated State object.

<a target="_blank" rel="noopener noreferrer" href="https://miro.medium.com/v2/resize:fit:640/format:webp/1*x1qnWzfmhG8Z9WJVNYvL_Q.png"><img  align="right" src="https://miro.medium.com/v2/resize:fit:640/format:webp/1*x1qnWzfmhG8Z9WJVNYvL_Q.png" width="253" height="286"></a>

<h2 id="state">State of Control</h2>

Through the course of an app’s lifecycle,
a controller can be assigned to any number of StateX objects.
A StateXController object works with ‘the last’ State object it’s been assigned to
but keeps a reference of any and all State objects it’s previously worked with in the Widget tree.
When a screen closes (i.e. the current StateX object is disposed of), the controller returns back to the previous StateX it was assigned to.
This allows, for example, for one controller to sustain the app’s business rules for the duration of the running app
conveying that logic across any number of screens (i.e. any number of StateX objects).

<h2 id="control">Control The State</h2>

<a target="_blank" rel="noopener noreferrer" href="https://miro.medium.com/v2/resize:fit:640/format:webp/1*7vctAgGEittQNOJVitNvaw.png"><img align="right" src="https://miro.medium.com/v2/resize:fit:640/format:webp/1*7vctAgGEittQNOJVitNvaw.png" width="253" height="286"></a>
In turn, the StateX object can take in any number of controllers.
You then delegate controllers to specific areas of responsibility.
Each can be independent of the other encouraging modular development.
The State object's <b>build</b>() function produces the interface
while its controllers are concerned with everything else.

<h2 id="example">Show By Example</h2>

Here is a gist file for you to download and follow along: <a href="https://gist.github.com/Andrious/e7d3ce3b8dcd5495978690a24ae5c3d6">statex_counter_app.dart</a>
<br />
As you see in the first screenshot below, the traditional State class has been replaced with the class, StateX, 
and takes in a StateXController object named, <i>YourController</i>. 
In the next screenshot below, 
you can see highlighted with red arrows that the Controller object is referenced here and there in the State object’s <b>build</b>() function. 
This is by design.
The controller is providing the data and the event handling necessary for the app to function properly. 
However, note there’s no <b>setState</b>() function call. 
It’s in the controller and called in the con.<b>onPressed</b>() function.

<div>
<a id="_StateXCounterPageState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/99061be8-b6f2-48b0-a33b-b4e0dc469b3e"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/99061be8-b6f2-48b0-a33b-b4e0dc469b3e" width="48%" height="60%"></a>
<a id="conBuildFunc" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/a72a2131-66b4-420d-a50d-d968933293ad"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/a72a2131-66b4-420d-a50d-d968933293ad" width="48%" height="60%"></a>
</div>

| [statex_counter_app.dart](https://gist.github.com/Andrious/e7d3ce3b8dcd5495978690a24ae5c3d6#file-statex_counter_app-dart-L24) | [statex_counter_app.dart](https://gist.github.com/Andrious/e7d3ce3b8dcd5495978690a24ae5c3d6#file-statex_counter_app-dart-L39) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="setState">Set Control</h2>

Looking at the first screenshot of the controller class below, 
you’ll find the <b>setState</b>() function call. 
Now, that’s a powerful capability! 
You’re in a class that can contain all the mutable properties and business logic you want as well as provide state management! 
It further has access to the State object’s own properties: widget, mounted, and context. 
Imagine what you’re controller can do with access to those properties as well.
The second screenshot is a quick peek into the StateX class itself confirming the Controller is linked to the State object is some fashion. 

<div>
<a id="YourController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/f87d5544-df61-4e05-a5aa-bc626f3675e8"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/f87d5544-df61-4e05-a5aa-bc626f3675e8" width="48%" height="60%"></a>
<a id="StateXConstructor" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/981ec14c-085d-4908-b29d-b1dd787b0987"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/981ec14c-085d-4908-b29d-b1dd787b0987" width="48%" height="60%"></a>
</div>

| [statex_counter_app.dart](https://gist.github.com/Andrious/e7d3ce3b8dcd5495978690a24ae5c3d6#file-statex_counter_app-dart-L60) | [state_extended.dart](https://github.com/AndriousSolutions/state_extended/blob/9ab24a97f236ce47fa9a32da3d276215923017ff/lib/state_extended.dart#L53) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------:|

As an aside, if you don’t want the ‘business side’ of your app dictating the ‘look and feel’ of your app’s interface, 
simply remove the <b>setState</b>() function call from the controller, and return it back to the <b>build</b>() function (see below). 
Let the State object dictate when to call its <b>setState</b>() function instead. 
With the use of such controllers, you have options.
The second screenshot below of our simple example app demonstrates how some additional controller objects can be linked to a StateX object.

<div>
<a id="YourController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/d0884183-a55a-437f-a61e-0ab29addb8dc"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/d0884183-a55a-437f-a61e-0ab29addb8dc" width="48%" height="60%"></a>
<a id="AnotherController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b807c8ca-13fd-4b64-b116-0910ea9930d1"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b807c8ca-13fd-4b64-b116-0910ea9930d1" width="48%" height="60%"></a>
</div>

| [statex_counter_app.dart](https://gist.github.com/Andrious/e7d3ce3b8dcd5495978690a24ae5c3d6#file-statex_counter_app-dart-L38) | [statex_counter_app.dart](https://gist.github.com/Andrious/e7d3ce3b8dcd5495978690a24ae5c3d6#file-statex_counter_app-dart-L24) |
|:------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------:|

<h2 id="functions">Functions and Features</h2>

Listed below are the additional functions and features you gain with the StateXController class:

/// The current StateX object<br />
StateX? get <b>state</b>

/// Associate this StateXController to the specified State object<br />
/// Returns that State object's unique identifier<br />
String <b>addState</b>(StateX? state) 

/// Calls the ‘current’ StateX object’s setState() function<br />
void <b>setState</b>(VoidCallback fn)

/// Retrieve the State object by its StatefulWidget<br />
/// Returns null if not found<br />
StateX? <b>stateOf</b>\<T extends StatefulWidget\>()

/// Retrieve the StateX object by type<br />
/// Returns null if not found<br />
T? <b>ofState</b>\<T extends StateX\>() 

<h2 id="events">Control Events</h2>

Lastly, there are some twenty-two (22) event handlers available to a controller when taken in by its StateX object.
For example, after running its own <b>initState</b>() function, 
a StateX object will then run the <b>initState</b>() function of each and every controller currently 'associated' with it at that moment. 
You see, each controller may have its own operations that need to run before the StateX object can continue. 
Instead of one large messy <b>initState</b>() function in the one State object,
there can be individual controllers running their own <b>initState</b>() functions. 
Very modular.
Very clean.
This process comes about with the other twenty-one system events as well.

/// Called exactly once when the State object is first created<br />
void <b>initState</b>()

/// Called exactly once at the app’s startup to initialize any ‘time-consuming’ operations<br />
/// that need to complete for the app can continue<br />
Future\<bool\> <b>initAsync</b>()

/// When the State object will never build again. Its terminated<br />
void <b>dispose</b>()

/// Override this method to respond when the State object’s accompanying StatefulWidget is destroyed
and a new one recreated<br />
/// — a very common occurrence in the life of a typical Flutter app<br />
void <b>didUpdateWidget</b>(StatefulWidget oldWidget)

/// When a dependency of this State object changes<br />
void <b>didChangeDependencies</b>()

/// Brightness changed<br />
void <b>didChangePlatformBrightness</b>()

/// When the user’s locale has changed<br />
void <b>didChangeLocale</b>(Locale locale)

/// When the application’s dimensions change. (i.e. when a phone is rotated.)<br />
void <b>didChangeMetrics</b>()

/// Called during hot reload. (e.g. reassembled during debugging.)<br />
void <b>reassemble</b>()

/// Called when the system tells the app to pop the current route<br />
void <b>didPopRoute</b>()

/// Called when the app pushes a new route onto the navigator<br />
void <b>didPushRoute</b>(String route)

/// Called when pushing a new RouteInformation and a restoration state<br />
/// onto the router<br />
void <b>didPushRouteInformation</b>(RouteInformation routeInformation)

/// When the State object is removed from the Widget tree<br />
/// Best to close things up in this function and not the dispose() function<br />
/// Like garbage collecting, the dispose() function call is to the discretion of the OS<br />
void <b>deactivate</b>()

/// When the platform’s text scale factor changes<br />
void <b>didChangeTextScaleFactor</b>()

/// When the phone is running low on memory<br />
void <b>didHaveMemoryPressure</b>()

/// When the system changes the set of active accessibility features<br />
void <b>didChangeAccessibilityFeatures</b>()

/// Called when the app’s in the background or returns to the foreground<br />
/// The four following functions use this one to address specific events<br />
void <b>didChangeAppLifecycleState</b>(AppLifecycleState state)

/// The application is in an inactive state and is not receiving user input<br />
void <b>inactiveLifecycleState</b>()

/// The application is not currently visible to the user, not responding to<br />
/// user input, and running in the background<br />
void <b>pausedLifecycleState</b>()

/// Either be in the progress of attaching when the engine is first initializing<br />
/// or after the view being destroyed due to a Navigator pop<br />
void <b>detachedLifecycleState</b>()

/// The application is visible and responding to user input<br />
void <b>resumedLifecycleState</b>()

<h2 id="which">Control Which State</h2>

Let's continue by highlighting some of the functions listed above.
As always, the <a href="https://github.com/AndriousSolutions/state_extended/tree/master/example">example app</a> 
(depicted in video) is a great resource for you to fully understand what this StateX package can do for you.
The sample of code below demonstrates the ready access you have to any particular State object used by a controller. 
It's showing how you can increment the counter displayed in Page 1 from Page 2 of a 3-Page counter app.
You can see how one is given vital access to the appropriate <b>setState</b>() function
from *outside* the State object you're working with! 

<div>
<a id="onPressed" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c7f8c78a-a872-4185-b9a8-c2f2734684d3"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c7f8c78a-a872-4185-b9a8-c2f2734684d3" width="48%" height="60%"></a>
<a id="page1counter" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/247c577c-a998-4184-97e2-448f157e0c0f"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/247c577c-a998-4184-97e2-448f157e0c0f" width="171" height="357"></a>
</div>

| [page_02.dart](https://github.com/AndriousSolutions/state_extended/blob/6eabcf66cf0e78831f791a7cc2dd700bbb3e8b8a/example/lib/src/view/home/page_02.dart#L136) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|

<h2 id="context">Control Context</h2>

The screenshot above is of the State class, <i>Page2State</i>.
Let's take a quick peek of its <b>initState</b>() function displaying for demonstration purposes 
the properties also available to a controller once associated with a State object.
Note, even if the controller as not 'added' to a particular State object, some of these properties are still viable.
For example, in the first screenshot below, every controller has a <b><i>rootState</i></b> property returning the first State object for the app.
In the second screenshot highlighted are additional properties that provide values whether the controller has been assigned a State object or not. 
The latest context object is available to you in a number of ways using a controller.
A 'data object' initially supplied to your app is available to every controller.
It's an object and so can be anything you imagine and or required by available throughout your app.
Lastly, there a bool property indicating whether the app is running in production or not
---a useful indicator during development.

<div>
<a id="rootState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/778fb005-0bff-46f7-8fae-7293ab6a9f25"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/778fb005-0bff-46f7-8fae-7293ab6a9f25" width="48%" height="60%"></a>
<a id="lastContext" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/10afc033-dd05-40b7-90ba-743626dbce8c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/10afc033-dd05-40b7-90ba-743626dbce8c" width="48%" height="60%"></a>
</div>

| [page_02.dart](https://github.com/AndriousSolutions/state_extended/blob/6eabcf66cf0e78831f791a7cc2dd700bbb3e8b8a/example/lib/src/view/home/page_02.dart#L35) | [page_02.dart](https://github.com/AndriousSolutions/state_extended/blob/6eabcf66cf0e78831f791a7cc2dd700bbb3e8b8a/example/lib/src/view/home/page_02.dart#L45) | 
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="app">Control The App</h2>

The example app, <a href="https://github.com/AndriousSolutions/appstatex_example_app">appstatex_example_app</a>, 
was first introduced in the topic, <a href="https://pub.dev/documentation/state_extended/latest/topics/AppStateX%20class-topic.html">AppStateX class</a>.
Let's review the use of controllers in this app, and see how they're involvement only makes for better code.
The first screenshot below is of the App State class, <i>_MyAppState</i>.
At a glance, you can see what controllers are involved in this app, 
and maybe even deduce their individual roles.
Those few actually taken in by the State class, as you know, will have ready access to that State class;
its properties and functions.
Any event functions those controllers may have will be run by the State object at the appropriate time
and circumstance.

In the first screenshot below, we see the instance variable, <i>app</i>, is assigned to the controller,
<i>MyAppController</i>.
You can assume this is the State object's primary controller 
responsible for or at least involved in the app's overall functionality.
In the second screenshot, you see the StateX object's <b>controllerByType</b>() function is used
to retrieve an instance of the controller class, <i>GoogleFontController</i>.
Since it was taken in by the State object earlier, this is one means to retrieve that instance.
Note, the second line there is merely to demonstrate an alternate approach available to you.
Since, the <i>GoogleFontController</i> class will only ever have one instance because of its factory constructor,
it's just as acceptable to call its constructor again and again to instead retrieve that one instance.
<div>
<a id="AppSateControllers" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/977bd3a6-1403-490f-bff9-e3ffb63c145e"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/977bd3a6-1403-490f-bff9-e3ffb63c145e" width="48%" height="60%"></a>
<a id="GooglefontsInitState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c0b00fdb-ed6b-4d67-895d-8ac245c94ec7"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c0b00fdb-ed6b-4d67-895d-8ac245c94ec7" width="48%" height="60%"></a>
</div>

| [myapp_view.dart](https://github.com/AndriousSolutions/appstatex_example_app/blob/a91d2bcdf92cb9b220b845b31080cd25511733a7/lib/app/view/myapp_view.dart#L18) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|

Again, in this example app, the controller, <i>MyAppController</i>, directs the general functionality of the app. 
An example of this is demonstrated in the first screenshot below.
The App State class, <i>_MyAppState</i> will either use the <b>MaterialApp</b> widget or the <b>CupertinoApp</b> widget 
depending on the value of its controller's <i>useMaterial</i> property. 
If the Material design is used, the second screenshot below demonstrates the continued contribution of the State object's controllers.
You can readily see the <i>MyAppController</i> controller also provides the popup menu and the drawer for the Material interface.
Note, however, the <i>MyHomePageController</i> controller is responsible for what happens when the FloatingActionButton widget is tapped.
At a glance, you can see the separation of responsibility: different controllers for different responsibilities.
The <i>MyHomePageController</i> controller is involved with the count and has the appropriate method called, <i>onPressed</i>.
<div>
<a id="useMaterial" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/cdb92aef-8ff3-46ca-b6e8-8d56fb39c56d"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/cdb92aef-8ff3-46ca-b6e8-8d56fb39c56d" width="48%" height="60%"></a>
<a id="ControllersInScaffold" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/dfde3233-efe1-4855-9b35-b7f68c030efe"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/dfde3233-efe1-4855-9b35-b7f68c030efe" width="48%" height="60%"></a>
</div>

| [myapp_view.dart](https://github.com/AndriousSolutions/appstatex_example_app/blob/fb922f37580c471889c44d4d899dfa7a1f96e80c/lib/app/view/myapp_view.dart#L63) |[home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|

The <i>ColorPickerController</i> class is also a controller. 
In other words, it extends the class, <i>StateXController</i>.
However, in this example app, it is never taken in by a State object.
If that's the case, why be a controller?
The first screenshot conveys why. 
A StateXController has properties and functions that are still available even when not taken in by a State object.

<div>
<a id="CololrPickerController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b31c3ffa-1003-43fa-b74e-fd2b9a81a392"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b31c3ffa-1003-43fa-b74e-fd2b9a81a392" width="48%" height="60%"></a>
</div>

| [color_picker_controller.dart](https://github.com/AndriousSolutions/appstatex_example_app/blob/fb922f37580c471889c44d4d899dfa7a1f96e80c/lib/app/controller/color_picker_controller.dart#L13) | 
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
