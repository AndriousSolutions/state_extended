## _Inherit The State_

The InheritedWidget is fundamental to supplying efficient performance.
Although Flutter has made great strides in being as efficient as possible, 
it's declarative approach will, in most cases, rebuild the whole screen
whereas an InheritedWidget allows you to rebuild only what's changed on the screen.
When it comes down to it, the less that's rebuilt, the better the performance.
The more immutable (less mutable) your app, the faster it is generally.

<table>
  	<caption>Contents</caption>
    <tbody>
      <tr>
        <td><a href="#state">Error In State</a></td>
        <td><a href="#count">Count On Errors</a></td>
        <td><a href="#firebasecrashlytics">Use FirebaseCrashlytics</a></td>
        <td><a href="#seeing">Seeing Red</a></td>
      </tr>
    </tbody>
</table>

<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/5f488187-a79f-4a7b-a39e-67075999a2bf"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/5f488187-a79f-4a7b-a39e-67075999a2bf" width="171" height="357"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/3cd09f28-675a-4cbc-acfd-14437f25335a"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/3cd09f28-675a-4cbc-acfd-14437f25335a" width="171" height="357"></a>
The 'Home!' example app is demonstrated in the video on your the right.
With every press of the button, indeed the whole screen is rebuilt.
This is just like the traditional Counter app that's created with every new Flutter project.
The <b>build</b>() function from the <i>_HomePageState</i> class is called again and again with every tap.
However, in this example app, the items displayed in red are updated independently of the whole screen rebuilds.
They are updated only when changed leaving the rest of the screen untouched (highlighted in second screenshot).

The series of greetings, for example, change with every five presses of the button.
Only that area of the screen changes. 
Further, as the count increments, you'll notice the red counter also increments to keep up with the current count.
It then starts over when the current count is reached.
Stop pressing the button, and the red counter continues the loop. 
Again, only that region of the screen is updated. 
The rest of the screen is left untouched. 
There is no 'rebuilding of the whole screen.'
The less the interface is changed at any point in time, the better the performance.
Updating the app's interface, in many instances, is the most 'expensive' operation.

The first screenshot below highlights the two widgets that displays those two items in red. 
The widget, `timer.counter`, involves a timer incrementing up to the current count.
The StatelessWidget, `SetState`, supplies a builder callback routine that's called again only if the App's 'InheritedWidget' is called again.
That's because this `SetState` widget has been assigned as a 'dependent' to that InheritedWidget.
This is a powerful aspect of using InheritedWidgets allowing for sporadic and spontaneous rebuilds of only parts of the interface
(see: <a rel="noopener noreferrer" href="https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html">dependOnInheritedWidgetOfExactType</a>()).
The second screenshot is a closer look at the `SetState` builder passing the current greeting using the property, <i>dataObject</i>. 
<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/b83e5697-206a-4dc5-b2f2-298775c712d5"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/b83e5697-206a-4dc5-b2f2-298775c712d5" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7d3375e6-682b-419b-b73d-cfb2f3c2594c"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7d3375e6-682b-419b-b73d-cfb2f3c2594c" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|
The second screenshot highlights the timer class being instantiated and added to the StateX object, <i>_HomePageState</i>.
Adding controllers to StateX objects allows those controllers to react appropriately when the app is placed in the backgournd, 
for example, or when the app is terminated. 

<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7cb65b83-eb02-4b25-87cf-25664c49e380"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7cb65b83-eb02-4b25-87cf-25664c49e380" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7cb65b83-eb02-4b25-87cf-25664c49e380"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7cb65b83-eb02-4b25-87cf-25664c49e380" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|


<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/fccdcead-a581-485a-b379-2fd544376e52"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/fccdcead-a581-485a-b379-2fd544376e52" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/ae8f7737-acae-40dd-9a4d-182175560527"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/ae8f7737-acae-40dd-9a4d-182175560527" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/home/page_01.dart#L15) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------:|

<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/5d673297-2f41-4b37-8da7-a088b86450fd"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/5d673297-2f41-4b37-8da7-a088b86450fd" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/70679283-117a-4c2a-93d5-9255c34bcf2a"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/70679283-117a-4c2a-93d5-9255c34bcf2a" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|

<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6f23fb71-2dab-4015-bcf7-71a6ad099c3d"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6f23fb71-2dab-4015-bcf7-71a6ad099c3d" width="171" height="357"></a>

<div>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/6928309e-c573-4866-ad72-b3b1d8fc7f12"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/6928309e-c573-4866-ad72-b3b1d8fc7f12" width="48%" height="60%"></a>
<a target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/c9004149-3a7b-46ae-bb2a-3d69ee05b1af"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/c9004149-3a7b-46ae-bb2a-3d69ee05b1af" width="48%" height="60%"></a>
</div>

| [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) | [home_page.dart](https://github.com/AndriousSolutions/state_extended/blob/07847b545764ea1b6feaf9ecae7fc6c64b2a5c37/example/lib/src/view/app/my_app.dart#L21) |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------:|
