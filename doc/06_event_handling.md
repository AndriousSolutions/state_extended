
## Documentation coming soon...


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