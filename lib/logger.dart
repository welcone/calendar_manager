import 'package:meta/meta.dart' show required;

/// 记录日志
class Logger {
  static bool get debug => true;


  static void log(String tag, {@required String message}) {
    assert(tag != null);
    print("[$tag] $message");
  }

  static void logd({@required String message}) {
    final tag = 'Debug';
    if(debug)
    print("[$tag] $message");
  }

}
