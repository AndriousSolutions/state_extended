## Wait For The Future

This topic presents what I felt was an essential feature missing in Flutter’s original State class:
The means to deal with asynchronous operations in a State object before proceeding to then render its interface. The FutureBuilder is utilised in the StateX class.

<a id="InheritedExample" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/f6679586-1d6c-4f9d-a5f6-233f291a4521"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/f6679586-1d6c-4f9d-a5f6-233f291a4521" width="171" height="357"></a>
<a id="exampleStartup" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/099c99bd-460b-4654-a4fc-184303712ed4"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/099c99bd-460b-4654-a4fc-184303712ed4" width="171" height="357"></a>
<a id="startUp" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/7e3bd683-4654-4c3b-a597-8560db008346"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/7e3bd683-4654-4c3b-a597-8560db008346" width="171" height="357"></a>

Looking at the three gif files.
The first one depicts the one StateX object waiting to continue
while the second gif depicts twelve StateX objects waiting to continue.
Each StateX object has its own individual asynchronous operation going on,
and each uses Flutter’s own FutureBuilder widget to wait for such operations to complete.

The third and last gif file depicts the whole process.
It’s the startup process of the example app that accompanies the <b>state_extended</b> package.
Note, since this app is running on an Android emulator,
those spinners are from the <a href="https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html">CircularProgressIndicator</a> widget.
If it were running on an iOS phone,
the <a href="https://api.flutter.dev/flutter/cupertino/CupertinoActivityIndicator-class.html">CupertinoActivityIndicator</a> widget would be used instead to produce the iOS-style activity indicators.
Flutter is a cross-platform SDK after all.

The spinner in the first gif file is caused by the controller, <i>ExampleAppController</i>.
It’s <b>initAsync</b>() function has a Future.<b>delay</b>() function 'pausing' the app for some ten seconds.
You can see this in the first screenshot below.
The twelve spinners in the second gif file, is the result of twelve StateX objects each individually waiting
for the Internet download of a particular image of a bird, dog, fox or cat.
That's seen in the second screenshot below.

<div>
<a id="ExampleAppInitAsync" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/5f49703b-4fb5-4d56-8a20-003183023924"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/5f49703b-4fb5-4d56-8a20-003183023924" width="48%" height="60%"></a>
<a id="initAsyncNetwork" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/d9c49c81-99cb-4bf1-bee2-ea5bc668b5005"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/d9c49c81-99cb-4bf1-bee2-ea5bc668b500" width="48%" height="60%"></a>
</div>


| [app_controller.dart](https://github.com/AndriousSolutions/state_extended/blob/05a7a89cfdca335ea7571e93526cd24ad10d7194/example/lib/src/controller/app/app_controller.dart#L7) | [image_api_controller.dart](https://github.com/AndriousSolutions/state_extended/blob/05a7a89cfdca335ea7571e93526cd24ad10d7194/example/lib/src/another_app/home/gridview/controller/image_api_controller.dart#L46) |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |

Note, the Future.<b>delay</b>() function was used for demonstration purposes.
There’s no real asynchronous operation going on in the controller, <i>ExampleAppController</i>.
However, it could have just as easily been the opening of a database,
the calling of web services, and the downloading of data as well.
Such operations can now easily be performed in a State Object Controller.
Its associated State object will wait until completion with something spinning away on the screen.
Alternatively, you are allowed to load a splash screen instead and wait until completion.

By design, the StateX's FutureBuilder widget may be called again and again.
Generally, however, the `future` generated should not be regenerated again and again.
After all, you don't want your database opened or your web services called again and again...unless you do. If that's the case, simply implement the asynchronous operation in the <b>runAsync</b>() function
instead of the <b>initAsync</b>() function. The example app does just that allowing for new animal images (i.e. new downloads) with every refresh of the screen. However, in the example app, the <b>initAsync</b>() function continues to be implemented, but so is the <b>runAsync</b>() function calling the <b>initAsync</b>() function in turn so the <b>_ranAsync</b> flag is not set.
See the two screenshot below.
You have that option.

<div>
<a id="buildF" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/794f0911-76cb-4518-988a-652d03672a91"><img src="https://github.com/AndriousSolutions/state_extended/assets/32497443/794f0911-76cb-4518-988a-652d03672a91" width="48%" height="60%"></a>
<a id="initAsyncNetwork" target="_blank" rel="noopener noreferrer" href="https://github.com/AndriousSolutions/state_extended/assets/32497443/71d276bd-9267-4478-9d5c-a899ac97563a"><img align="right" src="https://github.com/AndriousSolutions/state_extended/assets/32497443/71d276bd-9267-4478-9d5c-a899ac97563a" width="48%" height="60%"></a>
</div>


| [image_api.dart](https://github.com/AndriousSolutions/state_extended/blob/05a7a89cfdca335ea7571e93526cd24ad10d7194/example/lib/src/another_app/home/gridview/view/image_api.dart#L33) | [state_extended.dart](https://github.com/AndriousSolutions/state_extended/blob/05a7a89cfdca335ea7571e93526cd24ad10d7194/lib/state_extended.dart#L1946) |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------: |

Indeed, but in most cases, it is only so to call any and all of its StateXControllers’ own <b>initAsync</b>() functions. Since most asynchronous operations have no direct relation to an app’s interface,
you’ll likely have your asynchronous stuff running in a State Object Controller (SOC) with the rest of the app’s business logic.
