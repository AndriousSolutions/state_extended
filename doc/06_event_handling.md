
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6f23fb71-2dab-4015-bcf7-71a6ad099c3d"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6f23fb71-2dab-4015-bcf7-71a6ad099c3d" width="171" height="357"></a>
<h2 id="control">Control Events</h2>
Adding controllers to StateX objects allows those controllers to react appropriately when the app is placed in the background
or when the app is terminated. 
It is especially important in this "Hello!" example app (see video) as a Timer is involved in the operation.
Such a timer would continuously run even when its not necessary.
If it was running on a mobile phone, such an app can routinely be interrupted by the user switching to another app,
answering a phone call, etc.
In those instances, it's very good practice to pause the app's operation whenever possible so not to be a 'memory hog'.
Resume only when the user returns to the app.
<br />
<br />
The StateX class has some twenty-two (22) event handling functions available to you
to take into account the many external events that can affect your app.
In the case of the "Hello!" example app, there is a ready means to stop the Timer when the app is
placed in th background as well as start the Timer up again when the user to resume its operations.
This is great news since Timers and operations like it simply take up resources.

<h2 id="time">Time to Initialise</h2>
In the screenshots below, we have the screenshot again of the Timer class being instantiated
and then added to the StateX object, <i>_HomePageState</i>.
Adding that controller now means, when the State object's <b>initState</b>() function is called,
the <b>initState</b>() function in the controller, <i>CounterTimer</i>, is also called.
Every controller added to the StateX object will have its <b>initState</b>() function called.

The second screenshot is that of the CounterTimer class.
You can see we're in its <b>initState</b>() where the Timer is first initialised with the <b>initTimer</b>() function.
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
Next, however, functions dedicated to specific lifecycle events are then called.
You can see where the <b>pausedLifecycleState</b>() function and the <b>resumedLifecycleState</b>() function are situated.
<div>
<a id="pausedLifecycleState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6928309e-c573-4866-ad72-b3b1d8fc7f12"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6928309e-c573-4866-ad72-b3b1d8fc7f12" width="48%" height="60%"></a>
<a id="didChangeAppLifecycleState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/9837452e-a086-4e6a-9f8d-1334b1d97a20"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/9837452e-a086-4e6a-9f8d-1334b1d97a20" width="48%" height="60%"></a>
</div>

| [counter_timer.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/example/lib/src/controller/home/counter_timer.dart#L78) | [state_extended.dart](https://github.com/AndriousSolutions/state_extended/blob/c1e4ec00acc904842731f78adfb9c167f6e2a0ab/lib/state_extended.dart#L487) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------:|

Here is a further list of event-handling functions available to you:
<div>
<a id="initstate" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ec5052af-5259-475a-be2f-32e320d30d71"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ec5052af-5259-475a-be2f-32e320d30d71" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="deactivate" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/09cef3e0-3b66-471d-9792-aff2593ee6ba"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/09cef3e0-3b66-471d-9792-aff2593ee6ba" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="activate" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/8fc956f2-5906-4eb6-898a-252e91caa389"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/8fc956f2-5906-4eb6-898a-252e91caa389" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="dispose" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b4bc6809-0114-4fde-921b-42e5ee6d30b3"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b4bc6809-0114-4fde-921b-42e5ee6d30b3" style="border:1px solid white;" width="50%" height="35%"></a>
<a id="didUpdateWidget" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c0575d1a-0618-48c7-b31b-98420b9a1286"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c0575d1a-0618-48c7-b31b-98420b9a1286" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didChangeDependencies" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6cd32354-430e-4909-8558-357444fd6d0c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6cd32354-430e-4909-8558-357444fd6d0c" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="reassemble" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/e614e0f8-0b89-473d-898e-abb8b0b96663"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e614e0f8-0b89-473d-898e-abb8b0b96663" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didPopRoute" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/efbf0091-8f72-49e1-8b55-2d9c3ef2ee7c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/efbf0091-8f72-49e1-8b55-2d9c3ef2ee7c" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didPushRoute" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/0ca8a049-c2a2-4448-b64b-5ba2fa77e19e"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/0ca8a049-c2a2-4448-b64b-5ba2fa77e19e" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didPushRouteInformation" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/06312d78-3467-4501-8de0-598b2c4b4ddb"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/06312d78-3467-4501-8de0-598b2c4b4ddb" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didPopNext" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/a369a598-26b7-40d5-9879-eb3f7fce4d22"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/a369a598-26b7-40d5-9879-eb3f7fce4d22" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didPush" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ea10e8e9-351e-449f-ae6d-d43dddca1ee7"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ea10e8e9-351e-449f-ae6d-d43dddca1ee7" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didPop" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/971f347b-e3a1-4853-b9ba-eab08f06b446"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/971f347b-e3a1-4853-b9ba-eab08f06b446" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didPushNext" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/afb57bfd-ff51-4e90-9331-09e4e72ec7dd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/afb57bfd-ff51-4e90-9331-09e4e72ec7dd" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didChangeMetrics" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/87bff0ca-b1ed-4b9a-9cde-1de2c5f5cf9e"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/87bff0ca-b1ed-4b9a-9cde-1de2c5f5cf9e" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didChangeTextScaleFactor" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/f9104e89-a3e7-493d-9d63-8d3770ccb5ca"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/f9104e89-a3e7-493d-9d63-8d3770ccb5ca" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didChangePlatformBrightness" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6ab62b99-f41f-4e4d-bc5c-60f2b69cada4"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6ab62b99-f41f-4e4d-bc5c-60f2b69cada4" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didChangeLocale" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/75064c9c-8545-434e-95a3-eb178a96e4df"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/75064c9c-8545-434e-95a3-eb178a96e4df" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didChangeAppLifecycleState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/29733ec4-90a2-489a-89ab-1d68f67b8a1c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/29733ec4-90a2-489a-89ab-1d68f67b8a1c" style="border:1px solid white;" width="50%" height="45%"></a>
<a id="didHaveMemoryPressure" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/679c7081-ad83-47fc-9db4-3ef82c4ea777"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/679c7081-ad83-47fc-9db4-3ef82c4ea777" style="border:1px solid white;" width="50%" height="30%"></a>
<a id="didChangeAccessibilityFeatures" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7b1d2dd3-725f-4969-81bc-54cf74f0abb8"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7b1d2dd3-725f-4969-81bc-54cf74f0abb8" style="border:1px solid white;" width="50%" height="25%"></a>
<a id="didRequestAppExit" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/8afdb9bf-560e-4071-860c-ad7637755705"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/8afdb9bf-560e-4071-860c-ad7637755705" style="border:1px solid white;" width="50%" height="25%"></a>
</div>