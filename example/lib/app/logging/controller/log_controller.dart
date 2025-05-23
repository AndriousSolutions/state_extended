//
import '/src/view.dart';

///
class LogController extends StateXController with TabsScaffoldController {
  /// Singleton Pattern
  factory LogController() => _this ??= LogController._();

  LogController._();
  static LogController? _this;

  ///
  static List<Widget> get logs =>
      _logs.isEmpty ? [const SizedBox.shrink()] : _logs;
  static final _logs = <Widget>[];

  /// Log a String
  static void log(String? line) {
    //
    if (line != null && line.isNotEmpty) {
      //
      line = line.replaceFirst('=========== ', '');

      line = line.replaceFirst('########### ', '');

      _logs.add(Text(line.trim()));
    }
  }

  @override
  void dispose() {
    _logs.clear();
    super.dispose();
  }
}
