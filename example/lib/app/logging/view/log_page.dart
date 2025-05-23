//
import 'package:flutter/gestures.dart' show PointerDeviceKind;

import '/src/controller.dart';

import '/src/view.dart';

// /// The Settings
// class LogPage extends StatelessWidget {
//   ///
//   const LogPage({super.key});
//
//   @override
//   Widget build(_) => Controller().setBuilder(
//         (_) => ListView(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//           children: LogController.logs,
//         ),
//       );
// }

/// The Settings
class LogPage extends StatefulWidget {
  ///
  const LogPage({
    required super.key,
    this.leading,
    this.trailing,
  }) : assert(key is UniqueKey);

  ///
  final Widget? leading;

  ///
  final Widget? trailing;

  @override
  State<StatefulWidget> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  //
  @override
  void initState() {
    super.initState();
    leading = widget.leading;
    trailing = widget.trailing;
  }

  //
  @override
  void dispose() {
    leading = null;
    trailing = null;
    super.dispose();
  }

  ///
  late Widget? leading;

  ///
  String title = 'Logging';

  ///
  late Widget? trailing;

  @override
  Widget build(BuildContext context) {
    //
    Widget widget = ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: LogController.logs,
    );

    if (kIsWeb || MyApp.app.inWindows) {
      //
      widget = ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: widget,
      );
    }
    //
    if (MyApp.app.useCupertino) {
      //
      widget = CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: leading,
          middle: Text(title),
          trailing: trailing,
        ),
        child: SafeArea(
          child: widget,
        ),
      );
    } else {
      //
      widget = Scaffold(
        primary: false,
        appBar: AppBar(
          leading: leading ?? const Text(''),
          title: Text(title),
          centerTitle: true,
          actions: trailing == null ? null : [trailing!],
        ),
        body: SafeArea(
          child: widget,
        ),
      );
    }
    return widget;
  }
}
