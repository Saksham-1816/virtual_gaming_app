import 'dart:developer' as developer;

class AppLogger {
  static const String _name = 'VirtualGamingApp';

  static void info(String message) {
    developer.log(
      message,
      name: _name,
    );
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: _name,
      error: error,
      stackTrace: stackTrace,
    );
  }
}