import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  static Logger? _baseLogger; // singleton
  static bool isReleaseMode = kReleaseMode;
  static const int _maxLogSize = 1024 * 1024; // 1MB
  static Future<void> _writeLock = Future.value();

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

  @visibleForTesting
  static void reset() {
    _baseLogger = null;
  }

  @visibleForTesting
  static Future<void> waitForWrites() async {
    await _writeLock;
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
    final completer = Completer<void>();
    final oldLock = _writeLock;
    _writeLock = completer.future;

    try {
      await oldLock;
      final file = await _getLogFile();
      if (file != null) {
        // Simple rotation: check size before writing
        if (await file.exists()) {
          final size = await file.length();
          if (size > _maxLogSize) {
            await file.writeAsString(
              '${DateTime.now()} : [SYSTEM] Log rotated due to size limit.\n',
              mode: FileMode.write, // Overwrite
            );
          }
        }

        await file.writeAsString(
          '${DateTime.now()} : $message\n',
          mode: FileMode.append,
        );
      }
    } catch (_) {
    } finally {
      completer.complete();
    }
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
    AppLogger.logToFile(_format(message));
  }

  void i(String message) {
    AppLogger._logger.i(_format(message));
    AppLogger.logToFile(_format(message));
  }

  void w(String message) {
    AppLogger._logger.w(_format(message));
    AppLogger.logToFile(_format(message));
  }

  Future<void> e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    AppLogger._logger.e(
      _format(message),
      error: error,
      stackTrace: stackTrace,
    );
    await AppLogger.logToFile('${_format(message)} | error: $error');

    if (AppLogger.isReleaseMode) {
      AppLogger._sendToRemote(message, error, stackTrace);
    }
  }
}
