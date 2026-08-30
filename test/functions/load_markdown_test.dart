import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/functions/load_markdown.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('loadMarkdown', () {
    const fileName = 'test';
    const localContent = '# Local Content';
    const remoteContent = '# Remote Content';
    const localPath = 'assets/markdown/test.md';

    test('should load from local assets if available', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
          (message) async {
        return utf8.encode(localContent).buffer.asByteData();
      });
      rootBundle.evict(localPath);

      final content = await loadMarkdown(fileName);
      expect(content, localContent);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should fallback to remote if local fails', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      final client = MockClient((request) async {
        return http.Response(remoteContent, 200);
      });

      final content = await loadMarkdown(fileName, client: client);
      expect(content, remoteContent);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should fallback to default if all fail', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final content = await loadMarkdown(fileName, client: client);
      expect(content, '# Content not available');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should return default if remote returns non-200', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      final client = MockClient((request) async {
        return http.Response('Error', 404);
      });

      final content = await loadMarkdown(fileName, client: client);
      expect(content, '# Content not available');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should work without explicit client and fallback to remote if local fails', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      // We can't easily mock the default http.Client() without a global override
      // but we can at least call the function to cover the null check and let it fail to default
      final content = await loadMarkdown(fileName);
      expect(content, '# Content not available');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });
  });
}
