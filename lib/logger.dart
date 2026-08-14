import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  static Logger? _baseLogger; // singleton

  /// Must be called in main() before runApp()
  static Future<void> init() async {
    _baseLogger = Logger(
      level: kReleaseMode ? Level.warning : Level.debug,
      printer: SimplePrinter(
        colors: true,
        printTime: true,
      ),
    );
  }

  /// Future remote logging hook
  static Future<void> _sendToRemote(
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) async {
    // TODO: send to Supabase or backend
  }

  /// Optional file logging
  static Future<File?> _getLogFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/app_logs.txt');
    } catch (_) {
      return null;
    }
  }

  static Future<void> logToFile(String message) async {
    try {
      final file = await _getLogFile();
      if (file != null) {
        await file.writeAsString(
          '${DateTime.now()} : $message\n',
          mode: FileMode.append,
        );
      }
    } catch (_) {}
  }

  /// Manual scope
  static ScopedLogger scope(String name) {
    return ScopedLogger._(name);
  }

  /// Auto class-name scope
  static ScopedLogger forClass(Object instance) {
    return ScopedLogger._(instance.runtimeType.toString());
  }

  /// Internal access for ScopedLogger
  static Logger get _logger {
    _baseLogger ??= Logger(
      level: Level.debug,
      printer: SimplePrinter(colors: true),
    );
    return _baseLogger!;
  }
}

class ScopedLogger {
  final String _scope;

  ScopedLogger._(this._scope);

  String _format(String message) => '[$_scope] $message';

  void d(String message) {
    AppLogger._logger.d(_format(message));
    _writeToFile(_format(message));
  }

  void i(String message) {
    AppLogger._logger.i(_format(message));
    _writeToFile(_format(message));
  }

  void w(String message) {
    AppLogger._logger.w(_format(message));
    _writeToFile(_format(message));
  }

  void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    AppLogger._logger.e(
      _format(message),
      error: error,
      stackTrace: stackTrace,
    );
    _writeToFile('${_format(message)} | error: $error');

    if (kReleaseMode) {
      AppLogger._sendToRemote(message, error, stackTrace);
    }
  }

  Future<void> _writeToFile(String message) async {
    try {
      final file = await AppLogger._getLogFile();
      if (file != null) {
        await file.writeAsString(
          '${DateTime.now()} : $message\n',
          mode: FileMode.append,
        );
      }
    } catch (_) {
      // silently ignore file errors
    }
  }
}
