<div>
<a id="pushed" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/f2122fed-8ff9-49d6-94ab-65e0ed7fb3e8"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/f2122fed-8ff9-49d6-94ab-65e0ed7fb3e8" width="171" height="357"></a>
<a id="counterApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/07962461-efe6-4610-82cb-251b6cf4be80"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/07962461-efe6-4610-82cb-251b6cf4be80" width="171" height="357"></a>
</div>

## The App's State Object

The AppStateX class is designed to be the first state object for your app.
For this role, it has some unique features.
Note the video to the right and the series of changes being made.
The app's overall appearances is being changed with just a tap.
You can turn off the 'debug banner' for example.
You're able to change the color, the font, and even the interface design 
from Material to Cupertino and back again.
You're even able to use some of Flutter's development tools right there at runtime.
You can turn on a graph conveying the general performance of the running app, 
highlight the widgets and other components that make up the presented screen,
and supply an grid over the app's whole interface. All on a whim.
You can even switch back and forth the Material design from version 2 to version 3.

Now, those series of changes doesn't involve the home screen.
What I mean is, as simply as it is, (this app might be to simple an example) 
the string,'You have pushed the button this many times:', isn't rebuilt with every change.
By design, the count is rebuilt with every change and with every tap of the button of course, 
but if the screen was a little more complicated with a few more widgets, in most cases, 
they would be left untouched like that lone Text widget containing the String (see second screenshot).
That makes for an efficient app. 
The less an app's interface is updated, the better they always say.

Flutter does use the declarative approach rebuilding the whole screen from scratch at times,
however in this example app, there are two State objects retaining separate states.
The home page displaying the count and that String in the center of the screen has the State class, <i>_MyHomePageState</i>, 
while the rest of the screen containing the title bar, the popup menu, the drawer, 
and the floating action button (when the Scaffold widget is being used) is all managed by the State class, 
<i>_MyAppState</i>.

<table>
  	<caption>Contents</caption>
    <tbody>
      <tr>
       <td><a href="#control">Control</a></td>
       <td><a href="#prefer">Preferences</a></td>
       <td><a href="#fonts">Fonts</a></td>
       <td><a href="#get">Get Control</a></td>
       <td><a href="#development">Development</a></td>
       <td><a href="#app">Parameters</a></td>
       <td><a href="#face">New Face</a></td>
       <td><a href="#new">New Font</a></td>
      </tr>
    </tbody>
</table>

The example app being examined in this topic can be found in the repository,
<a href="https://github.com/AndriousSolutions/appstatex_example_app">appstatex_example_app</a>,
and is available for you to download. 
As previously stated, this app involves two particular State objects.
Again, one deals with the 'current' screen being displayed.
The other deals with the rest of the app as a whole.
The point is, you will find it's very advantageous to have this separate 'App State' object
dealing with the overall 'look and feel' of the app.
Each subsequent screen displayed then has its own State object.
The State class, <i>_MyAppState</i>, is having its <b>setState</b>() function called
with every tap of a Switch widget for a development tool or with every tap of a menu option
leaving the 'current screen' untouched. 


The first screenshot below is of the State class,<i>_MyAppState</i>.
As you see, it extends the class, <i>AppStateX</i>, which in turn, extends the StateX class.
Being the 'base' or 'root' of the app, 
it's here where a developer would traditionally get things up and running: opening databases, web services, etc.
In particular, as you see highlighted in the first screenshot below, 
it's here where all the necessary controllers that deal with the app's business rules are instantiated.
All the code necessary to run the app as intended is made accessible in instance variables
or taken in by the State object, <i>_MyAppState</i>.
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/977bd3a6-1403-490f-bff9-e3ffb63c145e"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/977bd3a6-1403-490f-bff9-e3ffb63c145e" width="48%" height="60%"></a>
<a id="_MyAppStateDevTools" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/01edf1b4-f5f4-4d93-924a-988e628ee6d5"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/01edf1b4-f5f4-4d93-924a-988e628ee6d5" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<h2 id="control">Control</h2>
At a glance, you can deduce each controller class has a specific responsibility;
a particular role to play in the running of this app.
When instantiated, you can guess they're performing some initiating operation, 
or simply making their code available to the app
as is the case of the three highlighted in the second screenshot above.

Let's take a look at the 'App State' Object's own controller called, <i>MyAppController</i>.
In the first screenshot below, it's passed to the constructor using the named parameter, <i>controller</i>.
It could have just as easily been passed in the List using the named parameter, <i>controllers</i>,
but this is the State object's 'main' controller assigned to the State object's <i>controller</i> property.

In the second screenshot, you can see it has a specific role in the app.
It is used to determine which interface (Material or Cupertino) is to be display at start up.
You can see this controller has its own <b>initAsync</b>() function implemented so to assign the appropriate design.
If you've read <a href="https://pub.dev/documentation/state_extended/latest/topics/Get%20started-topic.html">Get started</a>,
you're aware the <b>initAsync</b>() function in both the State and controller objects
and serves to complete any necessary asynchronous operations before the State object calls its <b>build</b>() function.
And so, before this first screen appears, this example app is going to know which interface design to use.

<div>
<a id="_MyAppStateController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/8f5d1455-bd32-456c-afd8-f3c671eeca6b"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/8f5d1455-bd32-456c-afd8-f3c671eeca6b" width="48%" height="60%"></a>
<a id="MyAppInitAsync" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/e14287cc-8a79-4b12-aabf-8f71227107db"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e14287cc-8a79-4b12-aabf-8f71227107db" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<h2 id="prefer">Preferences</h2>
The static function, <i>getBool</i>(), is called to determine the design and is found in the Prefs class.
As it happens, the Prefs class is another controller (extends StateXController) 
and is used throughout the app so to readily access the popular <a href="https://pub.dev/packages/shared_preferences">shared_preferences</a> plugin.
There's no rule controllers can't call other controllers. 
In fact, it's most advantageous to be able to easily do so.
That simple fact makes for a clean architecture both scalable and adaptive.
The boolean instance variable, <i>useMaterial</i>, is assigned a saved value.
It otherwise defaults to the value, true.

In the first screenshot below, we see the Prefs class is instantiated and also passed to the App's State object.
Doing so, gives it access to the State object, and its lifecycle.
That means its <b>initAsync</b>() function is called after the one in the controller, <i>MyAppController</i>.
It's there in its function where the shared_preferences plugin is initialized and readied.
See how things are coming along?
A pretty uniformed and consistent approach is made available to you when it comes to starting up your app.
Granted, in this case, the Prefs class is accessed by the MyAppController class before its <b>initAsync</b>() is called,
but that's an exception.
That's why the static function, <b>getBoolF</b>(), was used.
Regardless, you'll see things are being set up in a consistent fashion.

<div>
<a id="_MyAppStatePrefs" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7448b144-d142-4bf7-a819-dea8a08b940d"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7448b144-d142-4bf7-a819-dea8a08b940d" width="48%" height="60%"></a>
<a id="PrefsinitAsync" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/a6aeaed1-aabd-48fa-9aa1-dc470e61a40b"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/a6aeaed1-aabd-48fa-9aa1-dc470e61a40b" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<h2 id="fonts">Fonts</h2>
Next one is the GoogleFontsController.
In the first screenshot below, you see it taken in by the App's State object.
In the second screenshot, you see its <b>initAsync</b>() function loading the specified Google fonts.
They are the fonts available to you when you want to change the app's font.
Involved is an asynchronous process of loading them all in. 
Again, this is conveniently accomplished with the consistent approach of using a controller,
and its <b>initAsync</b>() function. 
It's called after the <b>initAsync</b>() function from the Prefs class.
While this is all being done, a black screen is presented to the user
with a circular spinner displayed in the center. 
Optionally, you could have a 'splash screen' displayed instead.

<div>
<a id="_MyAppStateGoogleFonts" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/4c9007e7-0d22-4e45-9d0a-8dc827ecf735"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/4c9007e7-0d22-4e45-9d0a-8dc827ecf735" width="48%" height="60%"></a>
<a id="_initFont" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/35cd3796-c75f-4060-bf10-eeb477d62dfc"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/35cd3796-c75f-4060-bf10-eeb477d62dfc" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<h2 id="get">Get Control</h2>
Ok, there's clearly a separation of responsibility here. 
Separation blocks on code labeled controllers with ready access to State objects.
One deals with changing the app's font,
one works the color of the app, and one changes the interface design.
There's one that works with presenting the development tools, 
there's one that involves the counter in the center of the screen,
and, of course, there's one that works with the app overall. 

Let's continue with the <i>_MyAppState</i> class and look further down at its <b>initState</b>() function
(see the second screenshot below). 
The property variable, <i>googleFonts</i>, is assigned an instance of the <i>GoogleFontsController</i> class.
Note, in the first screenshot, that class was instantiated and passed to the State object.
Because of this, the <b>controllerByType</b>() function can be used to retrieve that instance of the class.
However, a factory constructor was used in this class, 
and so the property variable can just as well be assigned by another constructor call as it will be the same instance
(see the second screenshot below). 
Again, not a hardened rule, but the Singleton pattern appears to be most suitable for State Object Controllers,
and their role.
Regardless, the property variable, <i>googleFonts</i>, is assigned and ready for use.

<div>
<a id="GooglFontsController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/612df305-ab09-4c9f-a698-5ab1bac35c00"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/612df305-ab09-4c9f-a698-5ab1bac35c00" width="48%" height="60%"></a>
<a id="_MyAppStateInitState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/413f6f28-430f-42fa-87fa-d6770033aeb4"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/413f6f28-430f-42fa-87fa-d6770033aeb4" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<h2 id="development">Development</h2>
On the other hand, the property variable, <i>dev</i>, was assigned right away with the App state's constructor.
It's used to convey any selected development tool if and when any of the class, <i>DevTools</i>,  own properties is set to true
(see the second screenshot below).
Also in the first screenshot below, you can see the App State's controller assigned to the variable, <i>app</i>.
It's also seen in the second screenshot determining which interface design to be displayed 
using its property, <i>useMaterial</i>.

Do you see the separation of work here? The State object's 'build' function determines how things are displayed
while its controllers determine what things are displayed.
In many cases, the State object's build function will be dotted with an assortment of its controller objects
performing the event handling and business rules receptive by that particular screen.

<div>
<a id="DevToolsController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ee92d55d-3220-4d89-9c76-7a9ff4905713"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ee92d55d-3220-4d89-9c76-7a9ff4905713" width="48%" height="60%"></a>
<a id="buildInUseMaterial" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/8daf3119-a7eb-43b2-af02-d2195ac63650"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/8daf3119-a7eb-43b2-af02-d2195ac63650" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<h2 id="app">Parameters</h2>
Now we're going to take a look at what's inside the _<b>materialView</b>() and _<b>cupertinoView</b>() functions.
Of course, one utilizes the Material interface design, the other uses widgets for the Cupertino design.
That means one uses the widget, <i>MaterialApp</i>, the other uses the widget, <i>CupertinoApp</i> (see below).
Highlighted in the screenshots below are the controller variables and their properties.
Conceivably, you could have a variable assigned to all 34 named parameters for the MaterialApp widget
---all 27 parameters for the CupertinoApp widget.
Call the <b>setState</b>() function for the AppStateX object, and you'll have a different looking app. 

<div>
<a id="_materialView" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/cc2ececa-1eaa-484f-8ea8-70fc057efced"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/cc2ececa-1eaa-484f-8ea8-70fc057efced" width="48%" height="60%"></a>
<a id="CupertinoApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/68a22daf-b037-498d-9613-fd9e4923fa26"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/68a22daf-b037-498d-9613-fd9e4923fa26" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
<a id="switchInterface" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c70e2f15-a639-49f8-8916-17c6e2f94a76"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c70e2f15-a639-49f8-8916-17c6e2f94a76" width="171" height="357"></a>
<h2 id="face">New Face</h2>

When the interface design is switched from Material to Cupertino (see video), 
all the business involved to make this happen can be found in the controller, <i>MyAppController</i>.
You'll find even the popup menu is defined in this controller. 
A personal choice. 
Since the popup menu was so simple, 
I chose to place the popup menu code in the App's controller.

In the first screenshot below, you see the controller's `useMaterial` property determines the appropriate menu option
depending on the current interface. Remember, this controller has access to its State object
(_MyAppState) through the property, <b>state</b>. It is readily utilized here.
For example, if the Cupertino interface is being used, there's no need for the color picker menu option:

`if (!(state?.usingCupertino ?? false))`

What's interesting is the second screenshot. 
We're still in the controller, <i>MyAppController</i>, with its access to the State object, <i>MyAppState</i>.
Again, that's the 'root' or first State object, 
and so calling the <b>setState</b>() function would convey the new interface design.
However, it also has the property, <i>rootState</i>.
In the second screenshot, we see that property is used instead of the <b>state</b> property
achieving the same outcome.
That's because all controllers and State objects have access to the 'App State object'
because all have the property, <i>rootState</i>.
Easy access to the App's 'first' State object will prove to be a most powerful capability. 
Lastly, note the static function,`Prefs.setBool('useMaterial', false)`, records false
so that, next time the app starts up, the Cupertino interface design is used.

<div>
<a id="PopupMenuButton" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/063829d5-b403-452a-b202-426dfc8e0982"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/063829d5-b403-452a-b202-426dfc8e0982" width="48%" height="60%"></a>
<a id="onSelected" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ff33d719-87da-4bcc-9e97-b0138651517b"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ff33d719-87da-4bcc-9e97-b0138651517b" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|

And so, as you see in the first screenshot below of the App State object's 'build' function again,
when either the <b>setState</b>() or the <b>rootState</b>() function is called,
the App State object's <b>build</b>() function will execute again and the `useMatrial` property determines the appropriate interface.

Now, in the video below, we're repeatedly changing the app's font with no trouble at all.
We'll see how that's done next.
<div>
<a id="changeFonts" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c70e2f15-a639-49f8-8916-17c6e2f94a76"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/bfc59b6a-b346-42a3-9d75-600a397a39f4" width="171" height="357"></a>
<a id="buildInuseMaterial" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/e3de745e-107a-4b3e-b8ab-5a561eaf0231"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e3de745e-107a-4b3e-b8ab-5a561eaf0231" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) |
|:------------------------------------------------------------------------------------------------------------------|
<h2 id="new">New Font</h2>
Let's walk with the controller responsible for supplying and changing the app's font.
It's the <i>GoogleFontsController</i> and, in the first screenshot below, it's instantiated to the App's State object, <i>_MyAppState</i>.
As you know, it's then assigned to the instance variable, <i>googleFonts</i>, in the State object's <b>initState</b>() function
(see the second screenshot below).
That variable is now available to the rest of the State object and its functions.
<div>
<a id="GooglefontsController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ddf23cff-0b2d-4bce-ac22-66e862972d36"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ddf23cff-0b2d-4bce-ac22-66e862972d36" width="48%" height="60%"></a>
<a id="GooglefontsInitState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c0b00fdb-ed6b-4d67-895d-8ac245c94ec7"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c0b00fdb-ed6b-4d67-895d-8ac245c94ec7" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
For example, further down the State object in its <b>_materialView</b>() function,
that variable is then utilized to assign the font to be used by the app.
The GoogleFontsController is displayed in the second screenshot below.
The stretch of code presented there assigns a new font to the app.
You can see it's assigned to the 'current font' variable, <i>_font</i>.
It's then recorded as the default font, and then the App State object's is 'refreshed' using the property, <i>rootState</i>.
That means the code in the first screenshot runs again with the property, `googleFonts?.font`, supplying the new font.
As easy as all that.
<div>
<a id="googleFontsMaterialApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/672d492b-3cfe-486a-bd99-6d5b8b4f8bc5"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/672d492b-3cfe-486a-bd99-6d5b8b4f8bc5" width="48%" height="60%"></a>
<a id="showFonts" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/eda71633-93a1-46fc-a013-45551daa1de9"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/eda71633-93a1-46fc-a013-45551daa1de9" width="48%" height="60%"></a>
</div>

| [my_app.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [page_01.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
