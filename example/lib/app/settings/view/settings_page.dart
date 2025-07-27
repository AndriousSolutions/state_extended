//
import '/src/view.dart';

/// The Settings
class SettingsPage extends StatelessWidget {
  ///
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (MyApp.app.useMaterial) {
      return const AppSettings(key: Key('AppSettings'));
    } else {
      return const AppSettings.disabled(key: Key('AppSettings'));
    }
  }
}
