//
import 'package:flutter/gestures.dart' show PointerDeviceKind;

import '/src/view.dart';

/// The Settings
class SettingsPage extends StatelessWidget {
  ///
  const SettingsPage({super.key});
  //
  // @override
  // Widget build(BuildContext context) => AppSettingsDrawer(
  //   key: const Key('AppSettingsDrawer'),
  // );
  @override
  Widget build(BuildContext context) {
    if (MyApp.app.useMaterial) {
      return const AppSettings.column(key: Key('AppSettings'));
    } else {
      return const AppSettings.disabled(key: Key('AppSettings'));
    }
  }
}

/// The Settings
class SettingsScreen extends StatelessWidget {
  ///
  const SettingsScreen({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.child,
  });

  ///
  final Widget? leading;

  ///
  final String? title;

  ///
  final Widget? trailing;

  /// Displayed widget
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    //
    Widget widget = child ?? const Text('-- Empty Content --');

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
          middle: Text(title ?? ''),
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
          title: Text(title ?? ''),
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

/// Supply the appropriate ListTile widget
Widget listTile({
  Key? key,
  Widget? leading,
  Widget? title,
  Widget? subtitle,
  GestureTapCallback? onTap,
  String? tip,
  required bool value,
  ValueChanged<bool>? onChanged,
}) =>
    ListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: Tooltip(
        message: tip ?? '',
        preferBelow: false,
        verticalOffset: 20,
        height: 24,
        child: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
