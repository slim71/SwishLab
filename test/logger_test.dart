import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/logger.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProvider extends Mock with MockPlatformInterfaceMixin implements PathProviderPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockPathProvider mockPathProvider;

  setUpAll(() async {
    mockPathProvider = MockPathProvider();
    PathProviderPlatform.instance = mockPathProvider;
    when(() => mockPathProvider.getApplicationDocumentsPath()).thenAnswer((_) async => '.');
    when(() => mockPathProvider.getTemporaryPath()).thenAnswer((_) async => '.');

    // Clean up old log file if exists
    final logFile = File('./app_logs.txt');
    if (await logFile.exists()) {
      await logFile.delete();
    }

    await AppLogger.init();
  });

  tearDown(() async {
    await AppLogger.waitForWrites();
    final logFile = File('./app_logs.txt');
    if (await logFile.exists()) {
      try {
        await logFile.delete();
      } catch (_) {
        // Ignore errors during teardown cleanup
      }
    }
  });

  group('AppLogger', () {
    test('logs at all levels', () async {
      final logger = AppLogger.scope('Test');

      // Reset release mode for this test
      AppLogger.isReleaseMode = false;

      logger.d('debug message');
      logger.i('info message');
      logger.w('warning message');
      logger.e('error message', error: Exception('test error'));

      final classLogger = AppLogger.forClass('test string');
      classLogger.i('class log');

      await AppLogger.logToFile('manual log');
      await AppLogger.waitForWrites();

      final logFile = File('./app_logs.txt');
      expect(await logFile.exists(), isTrue);

      final content = await logFile.readAsString();
      expect(content, contains('debug message'));
      expect(content, contains('info message'));
      expect(content, contains('warning message'));
      expect(content, contains('error message'));
      expect(content, contains('class log'));
      expect(content, contains('manual log'));
    });

    test('logs to remote in release mode', () async {
      AppLogger.isReleaseMode = true;
      final logger = AppLogger.scope('ReleaseTest');

      // This should trigger _sendToRemote branch
      logger.e('release error');
      await AppLogger.waitForWrites();

      // Since _sendToRemote is currently a TODO (empty), we just verify it doesn't crash
      // and the line was hit.
      AppLogger.isReleaseMode = false; // Reset
    });

    test('handles path provider errors gracefully', () async {
      when(() => mockPathProvider.getApplicationDocumentsPath()).thenThrow(Exception('Path error'));

      // This should trigger the catch block in _getLogFile
      await AppLogger.logToFile('wont be logged');
      await AppLogger.waitForWrites();

      final logger = AppLogger.scope('ErrorTest');
      logger.i('wont be logged to file');
      await AppLogger.waitForWrites();

      // Restore path provider for other tests or cleanup
      when(() => mockPathProvider.getApplicationDocumentsPath()).thenAnswer((_) async => '.');
    });

    test('re-initializes if _baseLogger is null', () async {
      AppLogger.reset();
      final logger = AppLogger.scope('LazyInit');
      logger.d('lazy message');
      expect(logger, isNotNull);
      await AppLogger.waitForWrites();
    });

    test('rotates log file when size limit is exceeded', () async {
      final logFile = File('./app_logs.txt');
      // tearDown will have deleted it, but just in case
      if (await logFile.exists()) await logFile.delete();

      // Create a file slightly larger than 1MB
      final largeContent = 'a' * (1024 * 1024 + 100);
      await logFile.writeAsString(largeContent);

      final initialSize = await logFile.length();
      expect(initialSize, greaterThan(1024 * 1024));

      // This log should trigger rotation
      await AppLogger.logToFile('trigger rotation');
      await AppLogger.waitForWrites();

      final newContent = await logFile.readAsString();
      expect(newContent, contains('[SYSTEM] Log rotated due to size limit.'));
      expect(newContent, contains('trigger rotation'));
      expect(newContent.length, lessThan(1000)); // Should be much smaller now
    });

    test('sequential writes are handled correctly by lock', () async {
      final logFile = File('./app_logs.txt');
      if (await logFile.exists()) await logFile.delete();

      // Fire multiple logs without awaiting
      final futures = List.generate(10, (i) => AppLogger.logToFile('message $i'));
      await Future.wait(futures);
      await AppLogger.waitForWrites();

      final content = await logFile.readAsString();
      for (var i = 0; i < 10; i++) {
        expect(content, contains('message $i'));
      }
    });
  });
}
