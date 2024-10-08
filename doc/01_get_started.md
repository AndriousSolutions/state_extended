## State Extended

The StateX class is truly an extension of Flutter's State class
providing functions and features found lacking in the original.
These features are nothing new to Flutter.
StateX is an amalgamation of other features already found in Flutter.
My motto when writing this package has been, 'Keep it simple, Keep it Flutter.'

<table>
  	<caption>Contents</caption>
    <tbody>
    <tr>
       <td><a href="#wait">Wait For The Future</a></td>
       <td><a href="#control">Control The State</a></td>
       <td><a href="#state">State The Control</a></td>
       <td><a href="#abstract">Abstract Control</a></td>
       <td><a href="#source">The Source of Control</a></td>
       <td><a href="#menu">On The Menu</a></td>
       <td><a href="#set">Set The State</a></td>
       <td><a href="#single">A Single Control</a></td>
      </tr>
    </tbody>
</table>

When it comes to building your interface with this State class, you've got options:

1) If you use the traditional <b>build</b>() function then you're using the StateX class like Flutter's original State class.

2) However, if you use the <b>builder</b>() function instead, you have the <b>initAsync</b>() 
function to perform any asynchronous operations. A FutureBuilder calls the <b>initAsync</b>() function
to complete these operations before continuing to display the interface.

3) When instantiating the StateX class, you can set the parameter, <i>useInherited</i>, to true.
This means the built-in InheritedWidget will now be used. 
This also means the interface will only be built once and will never change--- 
only the <b>stateSet</b>() function and <b>dependOnInheritedWidget</b>() function
will dictate which widgets in the interface are updated when something is to change.
Instead of building the interface from scratch again and again, 
only specified portions on the interface is rebuilt improving performance.

4) <b>buildAndroid</b>() and <b>buildiOS</b>() supplies the Material interface 
and the Cupertino interface respectively depending on whether you're app is running 
on a Android phone or iOS phone respectively.

So, why these other functions and features? Because, they're needed...all the time.
All my apps need to perform time-consuming operations before the app can proceed.
And I've come to appreciate the benefits of rebuilding as
little as possible with every change of the interface.
The less rebuilt, the better the performance, and an InheritedWidget allows for this.

Let's run through the example app found in the README.md file and demonstrate these features.
After this, you could turn to the extensive <a href="https://github.com/AndriousSolutions/state_extended/tree/master/example">example</a> app that comes with the package to learn more.

<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/88878db9-9199-4eb4-9045-88853bfa9bd1"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/88878db9-9199-4eb4-9045-88853bfa9bd1" width="171" height="357"></a>

<h2 id="wait">Wait For The Future</h2>

Time and time again, you'll find that some web service has to be opened or some database accessed before
a screen can then display the remote data.
In Flutter, these asynchronous operations can easily be handled by Flutter's FutureBuilder,
but a State object doesn't have a FutureBuilder... until now.  

In the video file, you see the README example app starting up
and its circular progress indicator rotating in the center of the screen.
The video is demonstrating the built-in FutureBuilder now available to you.
Instead of a circular progress indicator, you can provide a splash screen
by returning a widget in the <b>onSplashScreen</b>() function.
When there's work to be done before a State object can then display it's interface to the screen,
you now turn to its <b>initAsync</b>() function.

In this simple example, it's merely a time-delay of 10 seconds being executed, 
but it could just as easily be an authentication routine and or some REST API calls needed
to first retrieve the data then displayed on the screen.
The first screenshot below is of the State class, <i>_MyAppState</i>.
It is a subclass of the StateX class and takes in a controller called, <i>AppController</i>.
Being the first or 'root' State object for the app, it directly extends the class, <i>AppStateX</i>.
The State Object Controller, <i>AppController</i>, is presented in the second screenshot below. 
Note, it has an <b>initAsync</b>() function with the 10-second delay.
The controller has been delegated to perform the asynchronous operation. 
I would encourage that controllers be delegated to the app's event handling and business rules.
Again, nothing new to Flutter.
The widgets, ListView and TextFormField to name a few delegate specific tasks to a controller. 
<div>
<a id="_MyAppState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/463e67d7-ce75-45c6-ba16-56d069159154"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/463e67d7-ce75-45c6-ba16-56d069159154" width="48%" height="60%"></a>
<a id="AppController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b818775e-b44d-4352-9ac5-1dd259ff1795"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b818775e-b44d-4352-9ac5-1dd259ff1795" width="48%" height="60%"></a>
</div>

| [_MyAppState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L22) | [AppController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L633) |
|:-------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="control">Control The State</h2>

In the video below, you see this simple example app starts up again. 
Once it's up and running, the button is pressed 10 times and the app is then terminated.
With every tap of the button, the counter increments accordingly. 
Note, as simply as this app is, the only widget that is being updated is the Text widget containing the count.
Everything else (the Scaffold widget, its AppBar containing the title, 'StateX Demo App', 
the Text widget with the string, 'You have pushed the button this many times:', etc.) 
has been executed once at start up never to be touched again.
That's because the parameter, <i>useInherited</i>, was set true in the State class, <i>_MyHomePageState</i>. to display the count
<div>
<a id="counterApp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/dbdd79ed-3e35-4504-a3c6-c6d79391922c"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/dbdd79ed-3e35-4504-a3c6-c6d79391922c" width="171" height="357"></a>
<a id="FloatingActionButton" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6c451e73-f99d-4c48-bb28-a03d3dd58cf7"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6c451e73-f99d-4c48-bb28-a03d3dd58cf7" width="48%" height="60%"></a>
</div>
The screenshot highlights what happens when that button is pressed.
Again, when using the StateX class, a controller is typically delegated to handle any events, 
and so the controller's corresponding <b>onPressed</b>() function is called with every tap of the button.
This separation of the interface from the logic makes for more scalable and more maintainable software.

You'll find the StateXController class an indispensable companion to the StateX class.
When taken into such a State object, the controller easily 'retains' the state of the overall app.
With the logic, business rules and event handling residing in a class that, unlike the StatelessWidget and State class,
is not tethered to a interface allowing for mutable content brings about some dynamic capabilities
and an unlimited degree of abstraction. 

| [_MyHomePageState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L108) | 
|:-------------------------------------------------------------------------------------------------------------------|

<h2 id="state">State The Control</h2>

The first screenshot below is of the State class, <i>_MyHomePageState</i>, that displays the count. 
You'll see the count is encapsulated in yet another StatefulWidget called, <i>CounterWidget</i>.
Such an arrangement would keep the count unchanged even if the <b>buildIn</b>() function 
used by this State class was instead the traditional <b>build</b>() function. 
The CounterWidget has got its own State class. 
Conventionally, you would have to call the <b>setState</b>() function for that particular State object.

Remember, when the parameter, <i>useInherited</i>, is et true, the interface is built only once
--its content is displayed and would never change if not for the <b>setState</b>() function 
and the <b>dependOnInheritedWidget</b>() function. 
You can see the <b>dependOnInheritedWidget</b>() function in the second screenshot below.
It shows the <b>build</b>() function for the CounterWidget's State class.

The <b>dependOnInheritedWidget</b>() function will make the CounterWidget a 'client' of the State object, <i>_MyHomePageState</i>.
More specifically, it will depend on State object's built-in InheritedWidget. 
And so, every time the button is pressed, and the controller's function, `con.onPressed()`, is called,
the count is incremented. However, then the controller's <b>notifyClients</b>() function is also called.
The CounterWidget is one of these 'clients' now, and its <b>build</b>() function will then be called
displaying the new count and leaving the rest of the interface untouched.
Very nice.
<div>
<a id="CounterWidget" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b517b67b-43d7-438c-a23e-4a07950dfe19"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b517b67b-43d7-438c-a23e-4a07950dfe19" width="48%" height="60%"></a>
<a id="_CounterState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b61a1cf5-8300-4f02-a7ce-9539c35fabb7"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b61a1cf5-8300-4f02-a7ce-9539c35fabb7" width="48%" height="60%"></a>
</div>

| [_MyHomePageState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L102) | [_CounterState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L134) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="abstract">Abstract Control</h2>

<a id="countTypes" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/47a07c89-8eb1-4087-95bc-91c59eb9ff49"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/47a07c89-8eb1-4087-95bc-91c59eb9ff49" width="171" height="357"></a>
Let's continue to examine the benefits of using the State Object Controllers. 
The very simple Counter app we've been examining does have some more features. 
There's the original integer counter, granted, but there's two other counts available to you.
You can also tap through the alphabet or through the prime numbers between 1 and 1000 if you like.
There's a popup menu that presents you with all three options.

What I'm emphasizing here is the easy separation of the app's interface from its logic
with the use of controllers. 
The level of abstraction available to you when using these accompanying controllers
with your State objects will make you wonder how you ever did without.
It's a very very very simple app, but it's hoped the advantages of using controllers will 
only become more self-evident.

Note, in the CounterWidget, the line, `Text(con.data, style: Theme.of(context).textTheme.headlineMedium);`,
is left untouched as you hop from one count option to another listed in the menu.
As far as the interface side is concerned, the `con.data` simply returns a String (see below).
There's no sign of what the data is or how or where it comes from.
A Clean Architecture, for example, would have the StatelessWidgets and the StatefulWidgets 
that make up the interface only concerned with 'how the data' is presented not 'what the data' is.
State Object Controllers makes this readily possible.

<div>
<a id="_CounterState1" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/0fd817e4-63d4-49cb-9634-457cf2c31489"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/0fd817e4-63d4-49cb-9634-457cf2c31489" width="48%" height="60%"></a>
<a id="HomeController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/e4a8c152-f264-44b8-96ad-9378abc15cdd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/e4a8c152-f264-44b8-96ad-9378abc15cdd" width="48%" height="60%"></a>
</div>

| [_CounterState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L134) | [HomeController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L167) |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="source">The Source of Control</h2>

In the second screenshot above, it's abundantly clear there's a lot going on in the HomeController's getter called, <i>data</i>. 
The code on the interface side, gives no hint there's actually three data sources used by the app.
It's the controller's responsibility to properly deal with 'the data' supplied to this app.
It's the controller's responsibility, for example, to convert the data to a String so to accommodate the Text widget.
It's the controller that's concerned with what happens when the app starts up or when a button is pressed.
That distinction makes for more effective, more scalable coding frankly.

Back to the HomeController class.
It's displayed in first screenshot below instantiating the three data sources it's to works with.
The interface code doesn't need to know 'how to talk' to these data sources.
The controller does that.
It's also responsible for the event handling, and so it's <b>onPressed</b>() function is a bit busy as well
(see the second screenshot below).
The controller increments the appropriate source depending on what was selected up on the menu.
<div>
<a id="HomeControllerModels" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/41fd9f9e-7f47-459f-b4dd-62d105088df9"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/41fd9f9e-7f47-459f-b4dd-62d105088df9" width="48%" height="60%"></a>
<a id="onPressed" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/cf873e37-de83-4b73-8271-1f7993cafe58"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/cf873e37-de83-4b73-8271-1f7993cafe58" width="48%" height="60%"></a>
</div>

| [HomeController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L102) | [HomeController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L185) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="menu">On The Menu</h2>

As for the popup menu, in the <i>_MyAppState</i> class, it's supplied from the controller, <i>HomeController</i> (see below).
Once a menu option is selected, you'll notice in the second screenshot below, the controller's <b>setState</b>() function is called.
That will refresh the last State class the controller registered with (i.e. <i>_MyHomePageState</i>)
and the new count will appear on the screen (see the video below). 
<div>
<a id="buildInMenu" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/21f912cd-47fe-4f65-9a44-d4ccc4b206c9"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/21f912cd-47fe-4f65-9a44-d4ccc4b206c9" width="48%" height="60%"></a>
<a id="onSelected" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/320da19a-3e96-49fb-a497-5e3329f82416"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/320da19a-3e96-49fb-a497-5e3329f82416" width="48%" height="60%"></a>
</div>

| [_MyHomePageState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L95) | [HomeController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L238) |
|:-------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<h2 id="set">Set The State</h2>

By the way, in this simple app, we're confident the controller's <b>setState</b>() function will call the <b>setState</b>() function for the State object, <i>_MyHomePageState</i>.
However, in other circumstances, the specific State object would have to be retrieved to ensure its <b>setState</b>() function is called.
The State Object Controller, once registered with any number of State objects, is able to retrieve a specific State object.
Note, if the specified type was not a State object taken in by the controller at that time, null is returned instead (see screenshot below).
<div>
<a id="countTypes02" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/3f8f25dd-d2f4-4949-ae72-7bddbd990889"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/3f8f25dd-d2f4-4949-ae72-7bddbd990889" width="171" height="357"></a>
<a id="setState" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/a34ced21-2764-47ad-9443-d0a6dd2bdb75"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/a34ced21-2764-47ad-9443-d0a6dd2bdb75" width="48%" height="60%"></a>
</div>

| [HomeController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L249) |
|:---------------------------------------------------------------------------------------------------------------------------------------------------------------|

<h2 id="single">A Single Control</h2>

Despite, being a very simple app, there is more than one controller.
Each delegated to a particular 'area of responsibility' for the app.
Remember, there is the, <i>AppController</i>.
Its job is to get the app ready at startup and essentially address the 'look and behavior' of the app overall.
The other controller, <i>HomeController</i>, was assigned to the home page.
It's code is concerned with the logic required by the home page.
This delegation of work between each State class using controllers allows for also very efficient coding and maintainability.

<a id="threecomps" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/716e2d31-1cfe-4d79-bed0-fe77dd02b71b"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/716e2d31-1cfe-4d79-bed0-fe77dd02b71b" alt="statecontroller" width="350" height="139"></a>

You may have noticed, in most cases, each controller class uses a <b>factory</b> constructor (see below).
Of course, not a hardened rule, but I've found it's most suitable for the role it plays to always have just a single instance of a State Object Controller.
This can be described as using the <a id="singleton" href="https://en.wikipedia.org/wiki/Singleton_pattern"><i>Singleton Pattern</i></a> for controllers.
Only one single instance of the class is ever created no matter the number of calls to its constructors.
It's another characteristic you're unable to attain with a State class and one that's very advantegous
to the overall dynamics of the running app.
<div>
<a id="AppController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/0228debd-55dc-4e7d-8587-9d384656ff30"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/0228debd-55dc-4e7d-8587-9d384656ff30" width="48%" height="60%"></a>
<a id="HomeController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/92c4269b-5024-400a-b214-74bc2f364c6d"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/92c4269b-5024-400a-b214-74bc2f364c6d" width="48%" height="60%"></a>
</div>

| [AppController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L633) | [HomeController](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L152) |
|:-------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|

For example, note how the controller can merely be instantiated in far-flung parts of the app
and easily supply the 'current state' or the necessary values and properties for a functioning app?
'Keep it Simple, Keep it Flutter' was the motto, remember?
The first screenshot below is the State class, <i>_MyHomePageState</i>.
It's controller is simply instantiated in its constructor---so the controller then has access to it.
In the second screenshot, the controller is instantiated so its State object can rebuild the 
widget, <i>CounterWidget</i>, whenever calling its <b>setState</b>() function.
<div>
<a id="_MyHomePageStateController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7b513dbd-6d81-4942-ac1c-9ae37c1136f8"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7b513dbd-6d81-4942-ac1c-9ae37c1136f8" width="48%" height="60%"></a>
<a id="_CounterStateController" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/cf53865b-d191-462c-86f4-91054f15c7cd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/cf53865b-d191-462c-86f4-91054f15c7cd" width="48%" height="60%"></a>
</div>

| [_MyHomePageState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L58) | [_CounterState](https://gist.github.com/Andrious/da8348b60f81bb5e49c5dd5623d88b4c#file-statex_readme_example_app-dart-L134) |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------:|
