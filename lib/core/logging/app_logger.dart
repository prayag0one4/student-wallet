import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  final String tag;

  const AppLogger(this.tag);

  void debug(String message) {
    if (kDebugMode) {
      print('[DEBUG] [$tag] $message');
    }
  }

  void info(String message) {
    if (kDebugMode) {
      print('[INFO] [$tag] $message');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      print('[WARNING] [$tag] $message');
    }
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR] [$tag] $message');
      if (error != null) print('[ERROR] Details: $error');
      if (stackTrace != null) print('[ERROR] Stack: $stackTrace');
    }
  }
}
