import 'package:meta/meta.dart' show required;

/// 记录日志
class Logger {
  static void log(String tag, {@required String message}) {
    assert(tag != null);
    print("[$tag] $message");
  }
}
