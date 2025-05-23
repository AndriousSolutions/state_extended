// ignore_for_file: unnecessary_lambdas, avoid_positional_boolean_parameters, invalid_use_of_protected_member

//
import '/src/controller.dart';
//
import '/src/view.dart';

///
class AppSettings extends StatefulWidget {
  /// Provide the Dev Tool options in a ListView
  const AppSettings({super.key, this.shrinkWrap})
      : column = false,
        useAssert = true;

  /// Wrap the options in a Column
  const AppSettings.column({super.key, this.shrinkWrap})
      : column = true,
        useAssert = true;

  /// Only disable those options not available
  const AppSettings.disabled({super.key, this.shrinkWrap})
      : column = true,
        useAssert = false;

  ///
  final bool? shrinkWrap;

  /// Wrap the options in a Column
  final bool column;

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
    Widget wid;
    if (widget.column) {
      wid = Column(
        children: appSettings,
      );
    } else {
      wid = ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shrinkWrap: widget.shrinkWrap ?? false,
        children: appSettings,
      );
    }

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

    const tip = disable ? 'Not Web enabled' : '';
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
            tipButtonError = 'Push button will error.';
            _showSnackBar(tipButtonError);
          } else {
            tipButtonError = '';
          }
          setState(() {});
        },
        tip: tipButtonError,
        value: con.errorButton,
        onChanged: (bool value) {
          con.errorButton = value;
          if (value) {
            tipButtonError = 'Push button will error.';
            _showSnackBar(tipButtonError);
          } else {
            tipButtonError = '';
          }
          setState(() {});
        },
      ),
      listTile(
        key: const Key('App initAsync error'),
        leading: isSmall ? null : const Icon(Icons.insert_invitation_sharp),
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
          // Show snack bar when appropriate
          _showSnackBar(_snackBarMsg);
          setState(() {});
        },
      ),
      listTile(
        key: const Key('initAsync error'),
        leading: isSmall ? null : const Icon(Icons.insert_invitation_sharp),
        title: const Text('Error in Another initAsync'),
        onTap: () {
          con.initAsyncError = !con.initAsyncError;
          if (con.initAsyncError) {
            tipAsyncError = 'Must restart app';
            // Show snack bar when appropriate
            _showSnackBar(tipAsyncError);
          } else {
            tipAsyncError = '';
          }
          setState(() {});
        },
        value: con.initAsyncError,
        onChanged: (bool value) {
          con.initAsyncError = value;
          if (value) {
            tipAsyncError = 'Must restart app';
            // Show snack bar when appropriate
            _showSnackBar(tipAsyncError);
          } else {
            tipAsyncError = '';
          }
          setState(() {});
        },
      ),
      listTile(
        key: const Key('builder error'),
        leading: isSmall ? null : const Icon(Icons.build),
        title: const Text('Error in Builder'),
        onTap: () {
          con.errorInBuilder = !con.errorInBuilder;
          if (con.errorInBuilder) {
            tipBuilderError = 'Page 2 will error.';
            // Show snack bar when appropriate
            _showSnackBar(tipBuilderError);
          } else {
            tipBuilderError = '';
          }
          setState(() {});
          // con.setSettingState(); // Don't invoke the error yet
        },
        tip: tipBuilderError,
        value: con.errorInBuilder,
        onChanged: (bool value) {
          con.errorInBuilder = value;
          if (value) {
            tipBuilderError = 'Page 2 will error';
            // Show snack bar when appropriate
            _showSnackBar(tipBuilderError);
          } else {
            tipBuilderError = '';
          }
          setState(() {});
          // con.setSettingState(); // Don't invoke the error yet
        },
      ),
      listTile(
        key: const Key('errorCatchAsync error'),
        leading: isSmall ? null : const Icon(Icons.cast_for_education),
        title: const Text('Error in errorCatchAsyncError'),
        onTap: () {
          con.errorCatchAsyncError = !con.errorCatchAsyncError;
          if (con.errorCatchAsyncError) {
            tipBuilderError = 'Must restart app';
            // Show snack bar when appropriate
            _showSnackBar(tipBuilderError);
          } else {
            tipBuilderError = '';
          }
          setState(() {});
        },
        tip: tipBuilderError,
        value: con.errorCatchAsyncError,
        onChanged: (bool value) {
          con.errorCatchAsyncError = value;
          if (value) {
            tipBuilderError = 'Must restart app';
            // Show snack bar when appropriate
            _showSnackBar(tipBuilderError);
          } else {
            tipBuilderError = '';
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
    ];
    return widgets;
  }

  var tipButtonError = '';
  var tipAsyncError = '';
  var tipBuilderError = '';
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
  void _showSnackBar([String? tip]) {
    if (MyApp.app.inMobile) {
      final content = tip ?? '';
      if (content.isNotEmpty) {
        // Displays a snack bar.
        MyApp.app.snackBar(message: content);
      }
    }
  }
}
