///
import '/src/controller.dart';

///
import '/src/view.dart';

///
class DevToolsSettings extends StatefulWidget {
  ///
  const DevToolsSettings({super.key});

  @override
  State createState() => _DevToolsSettingsState();
}

///
class _DevToolsSettingsState extends StateX<DevToolsSettings> {
  //
  _DevToolsSettingsState() : super(controller: DevTools()) {
    con = controller as DevTools;
  }

  //
  late DevTools con;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: devSettings,
      );

  ///
  List<Widget> get devSettings {
    final List<Widget> widgets = <Widget>[
      ListTile(
        leading: const Icon(Icons.bug_report),
        title: const Text('Show DEBUG banner'),
        onTap: () {
          con.debugShowCheckedModeBanner = !con.debugShowCheckedModeBanner;
        },
        trailing: Switch(
          value: con.debugShowCheckedModeBanner,
          onChanged: (bool value) {
            con.debugShowCheckedModeBanner = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.picture_in_picture),
        title: const Text('Show rendering performance overlay'),
        onTap: () {
          con.showPerformanceOverlay = !con.showPerformanceOverlay;
        },
        trailing: Switch(
          value: con.showPerformanceOverlay,
          onChanged: (bool value) {
            con.showPerformanceOverlay = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.accessibility),
        title: const Text('Show accessibility information'),
        onTap: () {
          con.showSemanticsDebugger = !con.showSemanticsDebugger;
        },
        trailing: Switch(
          value: con.showSemanticsDebugger,
          onChanged: (bool value) {
            con.showSemanticsDebugger = value;
          },
        ),
      ),
    ];
    // An approach to determine if running in your IDE or not is the assert()
    // i.e. When your in your Debugger or not.
    // The compiler removes assert functions and their content when in Production.
    assert(() {
      // material grid and size construction lines are only available in checked mode
      widgets.addAll(<Widget>[
        // Don't show the material grid if running in the Cupertino interface
        ListTile(
          leading: const Icon(Icons.border_clear),
          title: const Text('Show material grid'),
          onTap: () {
            con.debugShowMaterialGrid = !con.debugShowMaterialGrid;
          },
          trailing: Switch(
            value: con.debugShowMaterialGrid,
            onChanged: (bool value) {
              con.debugShowMaterialGrid = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.border_all),
          title: const Text('Paint construction lines'),
          onTap: () {
            con.debugPaintSizeEnabled = !con.debugPaintSizeEnabled;
          },
          trailing: Switch(
            value: con.debugPaintSizeEnabled,
            onChanged: (bool value) {
              con.debugPaintSizeEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_color_text),
          title: const Text('Show character baselines'),
          onTap: () {
            con.debugPaintBaselinesEnabled = !con.debugPaintBaselinesEnabled;
          },
          trailing: Switch(
            value: con.debugPaintBaselinesEnabled,
            onChanged: (bool value) {
              con.debugPaintBaselinesEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.filter_none),
          title: const Text('Highlight layer boundaries'),
          onTap: () {
            con.debugPaintLayerBordersEnabled =
                !con.debugPaintLayerBordersEnabled;
          },
          trailing: Switch(
            value: con.debugPaintLayerBordersEnabled,
            onChanged: (bool value) {
              con.debugPaintLayerBordersEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mouse),
          title: const Text('Flash interface taps'),
          onTap: () {
            con.debugPaintPointersEnabled = !con.debugPaintPointersEnabled;
          },
          trailing: Switch(
            value: con.debugPaintPointersEnabled,
            onChanged: (bool value) {
              con.debugPaintPointersEnabled = value;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.gradient),
          title: const Text('Highlight repainted layers'),
          onTap: () {
            con.debugRepaintRainbowEnabled = !con.debugRepaintRainbowEnabled;
          },
          trailing: Switch(
            value: con.debugRepaintRainbowEnabled,
            onChanged: (bool value) {
              con.debugRepaintRainbowEnabled = value;
            },
          ),
        ),
      ]);
      return true;
    }());

    return widgets;
  }
}
