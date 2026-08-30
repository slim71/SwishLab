import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/functions/load_credits.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('loadCredits', () {
    const localPath = 'assets/json/credits.json';
    final mockData = [
      {'author': 'John Doe', 'url': 'https://example.com', 'asset': 'image.png', 'type': 'image'}
    ];

    test('should load from local assets if available', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
          (message) async {
        return utf8.encode(json.encode(mockData)).buffer.asByteData();
      });
      rootBundle.evict(localPath);

      final credits = await loadCredits();

      expect(credits.length, 1);
      expect(credits[0].author, 'John Doe');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should fallback to remote if local fails', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      final mockResponse = json.encode(mockData);

      final client = MockClient((request) async {
        return http.Response(mockResponse, 200);
      });

      final credits = await loadCredits(client: client);
      expect(credits.length, 1);
      expect(credits[0].author, 'John Doe');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should return empty list if both local and remote fail', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final credits = await loadCredits(client: client);
      expect(credits, isEmpty);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should return empty list if remote throws', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async => null);
      rootBundle.evict(localPath);

      final client = MockClient((request) async {
        throw Exception('Network Error');
      });

      final credits = await loadCredits(client: client);
      expect(credits, isEmpty);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should return empty list if JSON is invalid', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
          (message) async {
        return utf8.encode('invalid-json').buffer.asByteData();
      });
      rootBundle.evict(localPath);

      final credits = await loadCredits();
      expect(credits, isEmpty);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should return empty list if JSON is empty', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
          (message) async {
        return utf8.encode('').buffer.asByteData();
      });
      rootBundle.evict(localPath);

      final credits = await loadCredits();
      expect(credits, isEmpty);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });

    test('should work without explicit client', () async {
      // This test is mostly for coverage of the case where client is null
      // We still need to mock the underlying IO if it were to actually reach out,
      // but here we just mock the local asset to satisfy the requirement early.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
          (message) async {
        return utf8.encode(json.encode(mockData)).buffer.asByteData();
      });
      rootBundle.evict(localPath);

      final credits = await loadCredits();
      expect(credits.length, 1);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
    });
    group('Cleanup', () {
      test('cleanup', () {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
      });
    });
  });
}
