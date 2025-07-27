// ignore_for_file: unnecessary_lambdas, avoid_positional_boolean_parameters, invalid_use_of_protected_member

//
import '/src/controller.dart';

//
import '/src/view.dart';

///
class AppSettings extends StatefulWidget {
  /// Provide the Dev Tool options in a ListView
  const AppSettings({super.key, this.shrinkWrap}) : useAssert = true;

  /// Wrap the options in a Column
  const AppSettings.column({super.key, this.shrinkWrap}) : useAssert = true;

  /// Only disable those options not available
  const AppSettings.disabled({super.key, this.shrinkWrap}) : useAssert = false;

  ///
  final bool? shrinkWrap;

  /// Use assert to remove options only available during development.
  final bool useAssert;

  @override
  State createState() => _AppSettingsState();
}

///
class _AppSettingsState extends State<AppSettings> {
  _AppSettingsState() {
    con = AppSettingsController();
  }

  late AppSettingsController con;

  @override
  Widget build(BuildContext context) {
    //
    Widget wid = ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      shrinkWrap: widget.shrinkWrap ?? false,
      children: appSettings,
    );

    /// In Material Design, widgets require a Material widget ancestor
    if (LookupBoundary.findAncestorWidgetOfExactType<Material>(context) ==
        null) {
      wid = Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: wid,
      );
    }
    return wid;
  }

  ///
  List<Widget> get appSettings {
    //
    final isPhone = MediaQuery.of(context).size.shortestSide < 600;

    final isSmall = isPhone && !kIsWeb;

    // Disable if running in Cupertino
    const disable = kIsWeb;

    // ignore: unused_local_variable
    const tip = disable ? 'Not Web enabled' : '';

    TextStyle style, textStyle;

    final TextTheme textTheme = Theme.of(context).textTheme;

    style = textTheme.headlineMedium!;

    textStyle = textTheme.labelSmall!;

    //
    final List<Widget> widgets = <Widget>[
      listTile(
        key: const Key('delay'),
        leading: isSmall ? null : const Icon(Icons.dark_mode),
        title: const Text('Delay Startup'),
        onTap: () => disable ? null : onTapInitAsyncDelay(state: this),
        // tip: disable ? tip : tipDelay,
        value: con.initAsyncDelay,
        onChanged: (v) =>
            disable ? null : onTapInitAsyncDelay(use: v, state: this),
      ),
      listTile(
        key: const Key('button error'),
        leading: isSmall ? null : const Icon(Icons.radio_button_on_sharp),
        title: const Text('Error Push button'),
        onTap: () {
          con.errorButton = !con.errorButton;
          if (con.errorButton) {
            _showSnackBar(tipButtonError);
          }
          setState(() {});
        },
        tip: tipButtonError,
        value: con.errorButton,
        onChanged: (bool value) {
          con.errorButton = value;
          if (value) {
            _showSnackBar(tipButtonError);
          }
          setState(() {});
        },
      ),
      listTile(
        key: const Key('custom error screen'),
        leading: isSmall ? null : const Icon(Icons.build),
        title: const Text('Custom Error Screen'),
        onTap: () {
          con.toggleErrorScreen(!con.customErrorScreen);
          setState(() {});
          String snack;
          if (con.customErrorScreen) {
            snack = 'Custom error screen enabled';
          } else {
            snack = "Flutter's original error screen";
          }
          _showSnackBar(snack);
        },
        tip: 'Custom error screen or not',
        value: con.customErrorScreen,
        onChanged: (bool value) {
          con.toggleErrorScreen(value);
          setState(() {});
          String snack;
          if (con.customErrorScreen) {
            snack = 'Custom error screen enabled';
          } else {
            snack = "Flutter's original error screen";
          }
          _showSnackBar(snack);
        },
      ),
      Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listTile(
              key: const Key('App initAsync error'),
              leading:
                  isSmall ? null : const Icon(Icons.insert_invitation_sharp),
              title: const Text('Error initAsync at Startup'),
              onTap: () {
                con.initAppAsyncError = !con.initAppAsyncError;
                // Show snack bar when appropriate
                _showSnackBar(_snackBarMsg);
                setState(() {});
              },
              value: con.initAppAsyncError,
              onChanged: (bool value) {
                con.initAppAsyncError = value;
                // Show snack bar
                _showSnackBar(_snackBarMsg);
                setState(() {});
              },
            ),
            CaughtErrorRadioButtons(
              initialValue: con.catchInitAppAsyncError,
              inChanged: (v) {
                con.catchInitAppAsyncError = v;
                // Show snack bar
                _showSnackBar(_snackBarMsg);
              },
            ),
          ]),
      Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listTile(
              key: const Key('Another initAsync error'),
              leading:
                  isSmall ? null : const Icon(Icons.insert_invitation_sharp),
              title: const Text('Error in Another initAsync'),
              onTap: () {
                con.anotherInitAsyncError = !con.anotherInitAsyncError;
                if (con.anotherInitAsyncError) {
                  tipAsyncError = 'Must restart app';
                  // Show snack bar when appropriate
                  _showSnackBar(snackPage02Error);
                } else {
                  tipAsyncError = '';
                }
                setState(() {});
              },
              value: con.anotherInitAsyncError,
              onChanged: (bool value) {
                con.anotherInitAsyncError = value;
                if (value) {
                  tipAsyncError = 'Must restart app';
                  // Show snack bar when appropriate
                  _showSnackBar(snackPage02Error);
                } else {
                  tipAsyncError = '';
                }
                setState(() {});
              },
            ),
            CaughtErrorRadioButtons(
              initialValue: con.catchAnotherInitAsyncError,
              inChanged: (v) {
                con.catchAnotherInitAsyncError = v;
                if (con.anotherInitAsyncError && !v) {
                  // Show snack bar
                  _showSnackBar(snackPage02Error);
                }
              },
            ),
          ]),
      listTile(
        key: const Key('builder error'),
        leading: isSmall ? null : const Icon(Icons.build),
        title: const Text('Error in Builder'),
        onTap: () {
          con.errorInBuilder = !con.errorInBuilder;
          if (con.errorInBuilder) {
            snackPage02Error = 'Page 2 will error.';
            // Show snack bar when appropriate
            _showSnackBar(snackPage02Error);
          } else {
            snackPage02Error = '';
          }
          setState(() {});
          // con.setSettingState(); // Don't invoke the error yet
        },
        tip: snackPage02Error,
        value: con.errorInBuilder,
        onChanged: (bool value) {
          con.errorInBuilder = value;
          if (value) {
            snackPage02Error = 'Page 2 will error';
            // Show snack bar when appropriate
            _showSnackBar(snackPage02Error);
          } else {
            snackPage02Error = '';
          }
          setState(() {});
          // con.setSettingState(); // Don't invoke the error yet
        },
      ),
      Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listTile(
              key: const Key('errorCatchAsync error'),
              leading: isSmall ? null : const Icon(Icons.cast_for_education),
              title: const Text('Error in errorCatchAsyncError'),
              onTap: () {
                con.errorCatchAsyncError = !con.errorCatchAsyncError;
                if (con.errorCatchAsyncError) {
                  snackPage02Error = 'Must restart app';
                  // Show snack bar when appropriate
                  _showSnackBar(snackPage02Error);
                } else {
                  snackPage02Error = '';
                }
                setState(() {});
              },
              tip: snackPage02Error,
              value: con.errorCatchAsyncError,
              onChanged: (bool value) {
                con.errorCatchAsyncError = value;
                if (value) {
                  snackPage02Error = 'Must restart app';
                  // Show snack bar when appropriate
                  _showSnackBar(snackPage02Error);
                } else {
                  snackPage02Error = '';
                }
                setState(() {});
              },
            ),
            CaughtErrorRadioButtons(
              initialValue: con.catchErrorCatchAsyncError,
              inChanged: (v) {
                con.catchErrorCatchAsyncError = v;
                // Show snack bar
                _showSnackBar(_snackBarMsg);
              },
            ),
          ]),
      listTile(
        key: const Key('initAsync returns false'),
        leading: isSmall ? null : const Icon(Icons.insert_invitation_sharp),
        title: const Text('initAsync() returns false'),
        onTap: () {
          con.initAsyncReturnsFalse = !con.initAsyncReturnsFalse;
          if (con.initAsyncReturnsFalse) {
            // Show snack bar when appropriate
            _showSnackBar(snackPage02Error);
          }
          setState(() {});
        },
        value: con.initAsyncReturnsFalse,
        onChanged: (bool value) {
          con.initAsyncReturnsFalse = value;
          if (value) {
            // Show snack bar
            _showSnackBar(snackPage02Error);
          }
          setState(() {});
        },
      ),
      listTile(
        key: const Key('Material3'),
        leading: isSmall ? null : const Icon(Icons.description_sharp),
        title: const Text('Use Material 3'),
        onTap: () {
          con.useMaterial3 = !con.useMaterial3;
          con.appStateX?.setState(() {});
          setState(() {});
        },
        value: con.useMaterial3,
        onChanged: (bool value) {
          con.useMaterial3 = value;
          con.appStateX?.setState(() {});
          setState(() {});
        },
      ),
      listTile(
        key: const Key('printoutEvents'),
        leading: isSmall ? null : const Icon(Icons.print),
        title: const Text('Print events to console'),
        onTap: () {
          con.printoutEvents = !con.printoutEvents;
          setState(() {});
          // Show snack bar
          _showSnackBar('Restart app');
        },
        value: con.printoutEvents,
        onChanged: (bool value) {
          con.printoutEvents = value;
          setState(() {});
          // Show snack bar
          _showSnackBar('Restart app');
        },
      ),
    ];
    return widgets;
  }

  var tipButtonError = 'Push button will error.';
  var tipAsyncError = '';
  var snackPage02Error = 'Page 2 will error';
  final _snackBarMsg = 'Must restart app';

  /// Delay
  void onTapInitAsyncDelay({bool? use, State? state}) {
    use ??= !con.initAsyncDelay;
    con.initAsyncDelay = use;
    state?.setState(() {});
    // Show snack bar
    _showSnackBar('Restart app');
  }

  /// Show a snack bar when appropriate
  void _showSnackBar([String? tip]) => MyApp.app.showSnackBar(tip);
}
