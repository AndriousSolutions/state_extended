## _Inherit The State_

The InheritedWidget is fundamental to supplying efficient performance.
Although Flutter has made great strides in being as efficient as possible, 
it's declarative approach will, in most cases, rebuild the whole screen
whereas an InheritedWidget allows you to rebuild only what's changed on the screen.
When it comes down to it, the less that's rebuilt, the better the performance.
The more immutable (less mutable) your app, the faster it is.

<table>
  	<caption>Contents</caption>
    <tbody>
      <tr>
        <td><a href="#change">Build Change</a></td>
        <td><a href="#spontaneous">Spontaneous Rebuilds</a></td>
        <td><a href="#root">The Root of Inheritance</a></td>
        <td><a href="#notify">Notify of Change</a></td>
        <td><a href="control">Control Events</a></td>
        <td><a href="time">Time to Initialise</a></td>
        <td><a href="pause">Pause for Time</a></td>
      </tr>
    </tbody>
</table>

<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/5f488187-a79f-4a7b-a39e-67075999a2bf"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/5f488187-a79f-4a7b-a39e-67075999a2bf" width="171" height="357"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/3cd09f28-675a-4cbc-acfd-14437f25335a"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/3cd09f28-675a-4cbc-acfd-14437f25335a" width="171" height="357"></a>
The 'Home!' example app is demonstrated in the video on your the right.
With every press of the button, indeed the whole screen is rebuilt.
This is just like the traditional Counter app that's created with every new Flutter project.
The <b>build</b>() function for the <i>_HomePageState</i> class is called again and again with every tap.
However, in this example app, the items displayed in red are updated independently of the whole screen rebuilds.
They are updated only when changed leaving the rest of the screen untouched (highlighted in second screenshot).

<h2 id="change">Build Change</h2>
The series of greetings, for example, change with every five taps of the button.
Only that area of the screen changes. 
Further, as the count increments, you'll notice the red counter also increments to keep up with the current count.
It then starts over when the current count is reached.
Stop pressing the button, and the red counter continues the loop. 
Again, only that region of the screen is updated. 
The rest of the screen is left unchanged. Very efficient!
There is no 'rebuilding of the whole screen.'
The less the interface is changed at any point in time, the better the performance.
Updating the app's interface, in most instances, is the most 'expensive' operation.

<h2 id="spontaneous">Spontaneous Rebuilds</h2>
The first screenshot below highlights the two widgets that displays those two items in red. 
The widget, `timer.counter`, involves a timer incrementing up to the current count.
The StatelessWidget, `SetState`, supplies a builder callback routine that's called again only if the App's 'InheritedWidget' is called again.
That's because this `SetState` widget has been assigned as a 'dependent' to that InheritedWidget.
This is a powerful aspect of using InheritedWidgets allowing for sporadic and spontaneous rebuilds of only parts of the interface
(see: <a rel="noopener noreferrer" href="https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html">dependOnInheritedWidgetOfExactType</a>()).
The second screenshot is a closer look at the `SetState` builder passing the current greeting using the property, <i>dataObject</i>. 
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/d7030e72-77ce-492f-bb0f-9e46e740f7d0"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/d7030e72-77ce-492f-bb0f-9e46e740f7d0" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/fee7413f-32de-4791-b0f8-7f1c0c1fb287"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/fee7413f-32de-4791-b0f8-7f1c0c1fb287" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/view/home/home_page.dart#L55) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/view/home/home_page.dart#L68) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="depend">Depend On Time</h2>
The first screenshot below highlights the timer class being instantiated and then added to the StateX object, <i>_HomePageState</i>.
The second screenshot conveys the getter, `counter`, found in that timer class. Depending on whether the current count is an odd number or not, another `SetState` widget is utilized when incrementing the count.
Otherwise, a StatelessWidget called, <i>_TheCounter</i>, is called to demonstrate how the App's InheritedWidget
assigns a widget as a 'dependent' using the AppStateX's function, <b>dependOnInheritedWidget</b>().
<div>
<a id="HomePage" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/fccdcead-a581-485a-b379-2fd544376e52"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/fccdcead-a581-485a-b379-2fd544376e52" width="48%" height="60%"></a>
<a id="counter_timer" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b6fb62f2-6cb8-42ec-b2d2-3321c066be82"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b6fb62f2-6cb8-42ec-b2d2-3321c066be82" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/view/home/home_page.dart#L10) | [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L102) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="root">The Root of Inheritance</h2>
The <i>_TheCounter</i> StatelessWidget is displayed in the first screenshot below.
Highlighted is the 'root' State object taking in this widget as a dependent through its context.
Now, every time that InheritedWidget is called again, the <b>build</b>() function below is also called.
Note, the timer class extends the <b>StateXController</b> class, and so has the <b>rootState</b> property
with its <b>dependOnInheritedWidget</b>() function.

Thr second screenshot is the <b>SetState</b> widget.
It too has the 'root' State object in its <b>build</b>() function calling the <b>dependOnInheritedWidget</b>() function.
And so, when the app's InheritedWidget is called again, the <b>builder</b> callback routine is called again.
See how that works?
<div>
<a id="_thecounter" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ae8f7737-acae-40dd-9a4d-182175560527"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ae8f7737-acae-40dd-9a4d-182175560527" width="48%" height="60%"></a>
<a id="setstate_build" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ae8d7cc0-40c9-4447-bb2d-80d58244a09a"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ae8d7cc0-40c9-4447-bb2d-80d58244a09a" width="48%" height="60%"></a>
</div>

| [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L190) | [state_extended.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/lib/state_extended.dart#L2586) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="notify">Notify of Change</h2>
The screenshots below depicts how the Timer object is instantiated and set up. 
Note the <b>_increment</b>() function in the second screenshot calls the 'root' State object's <b>notifyClients</b>() function,
and this means the app's InheritedWidget is called again as well as all its dependent widgets. 
<div>
<a id="inittimer" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/1ba3a07c-1285-4122-ab61-58e0541c52b2"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/1ba3a07c-1285-4122-ab61-58e0541c52b2" width="48%" height="60%"></a>
<a id="_increment" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/5d673297-2f41-4b37-8da7-a088b86450fd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/5d673297-2f41-4b37-8da7-a088b86450fd" width="48%" height="60%"></a>
</div>

| [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L170) | [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L126) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6f23fb71-2dab-4015-bcf7-71a6ad099c3d"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6f23fb71-2dab-4015-bcf7-71a6ad099c3d" width="171" height="357"></a>
<h2 id="control">Control Events</h2>
Adding controllers to StateX objects allows those controllers to react appropriately when the app is placed in the background,
for example, or when the app is terminated. It is especially important in this "Hello!" example app as a Timer is involved in the operation.
Such a timer would continuously run even when its not necessary.
For example, this Flutter app can easily be found running on a mobile phone.
With that, such an app can routinely be interrupted by the user switching to another app,
answering a phone call for example, and then return to the app.

The StateX class has some twenty-six (26) event handling functions available to you
to take into account the many external events that can affect your running app.
In the case of the "Hello!" example app, there is a ready means to stop the Timer when the app is 
placed in th background as well as start the Timer up again when the user returns and the app resumes its operations (see right). 
This is great news since Timers and operations like it simply take up resources, 
and if you don't do anything about it in the first place,
your app will soon be labeled a 'memory hog.'

<h2 id="time">Time to Initialise</h2>
In the screenshots below, we have the screenshot again of the Timer class being instantiated
and then added to the StateX object, <i>_HomePageState</i>.
Adding that controller now means, when the State object's <b>initState</b>() function is called, 
the <b>initState</b>() function in the controller, <i>CounterTimer</i>, is also called.
Every controller added to the StateX object will have its <b>initState</b>() function called.

The second screenshot is that of the CounterTimer class.
You can see it's in its <b>initState</b>() where the Timer is first initialised with the <b>initTimer</b>() function.
It's there where the Timer begins keeping tabs on the current count. When that count increments, the Timer will keep in-step.
<div>
<a id="_homepagestate" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/fccdcead-a581-485a-b379-2fd544376e52"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/fccdcead-a581-485a-b379-2fd544376e52" width="48%" height="60%"></a>
<a id="counter_init" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/70679283-117a-4c2a-93d5-9255c34bcf2a"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/70679283-117a-4c2a-93d5-9255c34bcf2a" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/home_page.dart#L10) | [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L34) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="pause">Pause for Time</h2>
Now in the screenshots below, you see how the timer is stopped and started again depending on the circumstance.
A controller class is provided an assortment of functions to address particular events.
As you can readily see in the first screenshot below of the CounterTimer class, when the running app is placed in the background, for example,
the <b>pausedLifecycleState</b>() function is called. There, the Timer is turned off.
When the app is returned focus, the <b>resumedLifecycleState</b>() function is called and the Timer is turned on again.

The second screenshot displays the <b>didChangeAppLifecycleState</b>() function in the StateX class.
As you see, the <b>didChangeAppLifecycleState</b>() functions of any and all the controllers it may contain are also called.
Next, however, functions dedicated to specific cycle events are then called.
You can see where the <b>pausedLifecycleState</b>() function and the <b>resumedLifecycleState</b>() function are situated.
<div>
<a id="pausedLifecycleState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6928309e-c573-4866-ad72-b3b1d8fc7f12"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6928309e-c573-4866-ad72-b3b1d8fc7f12" width="48%" height="60%"></a>
<a id="didChangeAppLifecycleState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c9004149-3a7b-46ae-bb2a-3d69ee05b1af"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c9004149-3a7b-46ae-bb2a-3d69ee05b1af" width="48%" height="60%"></a>
</div>

| [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L78) | [state_extended.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/lib/state_extended.dart#L487) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------:|