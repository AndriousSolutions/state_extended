

## Documentation coming soon...


<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/fefad575-3b50-445c-80ab-2624ab2205ab"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/fefad575-3b50-445c-80ab-2624ab2205ab" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/fefad575-3b50-445c-80ab-2624ab2205ab"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/fefad575-3b50-445c-80ab-2624ab2205ab" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|

Introduced in the topic, <a href="https://pub.dev/documentation/state_extended/latest/topics/AppStateX%20class-topic.html">AppStateX class</a>,
is the example app, <a href="https://github.com/AndriousSolutions/appstatex_example_app">appstatex_example_app</a>.
Let's review the use of controllers in this app, and see how they're involvement only makes for better code.
The first screenshot below is of the App State class, <i>_MyAppState</i>.
At a glance, you can see what controllers are involved in this app, 
and maybe even deduce their individual roles.
Those few actually taken in by the State class, as you know, will have ready access to that class;
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
it's just as acceptable to call its constructor again and again instead to retrieve that one instance.
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
