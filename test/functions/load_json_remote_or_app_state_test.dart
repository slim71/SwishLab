import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swish_lab/functions/load_json_remote_or_app_state.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('loadJsonRemoteOrAppState', () {
    const remoteName = 'test_data';
    final remoteData = [
      {'source': 'remote'}
    ];
    final cachedData = [
      {'source': 'cached'}
    ];
    final defaultData = [
      {'source': 'default'}
    ];
    final defaultJson = json.encode(defaultData);

    test('should load from remote and cache it', () async {
      SharedPreferences.setMockInitialValues({});
      final mockResponse = json.encode(remoteData);

      final client = MockClient((request) async {
        return http.Response(mockResponse, 200);
      });

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result.first['source'], 'remote');
    });

    test('should fallback to cache if remote fails and trigger background refresh', () async {
      SharedPreferences.setMockInitialValues({
        'cached_json_$remoteName': json.encode(cachedData),
      });

      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      // Set factory for background refresh
      httpClientFactory = () => client;

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result.first['source'], 'cached');

      // Allow background task to run
      await Future<void>.delayed(const Duration(milliseconds: 100));

      httpClientFactory = () => http.Client(); // reset
    });

    test('background refresh success updates cache', () async {
      SharedPreferences.setMockInitialValues({
        'cached_json_$remoteName': json.encode(cachedData),
      });

      final client = MockClient((request) async {
        return http.Response(json.encode(remoteData), 200);
      });

      httpClientFactory = () => client;

      await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);

      // Wait for background refresh
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('cached_json_$remoteName'), json.encode(remoteData));

      httpClientFactory = () => http.Client(); // reset
    });

    test('should fallback to default if remote and cache fail', () async {
      SharedPreferences.setMockInitialValues({});

      final client = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result.first['source'], 'default');
    });

    test('should return empty list if all fail and default is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final client = MockClient((request) async => throw Exception('err'));

      final result = await loadJsonRemoteOrAppState(remoteName, '', client: client);
      expect(result, isEmpty);
    });

    test('should return list if remote returns a map', () async {
      SharedPreferences.setMockInitialValues({});
      final mapData = {'key': 'value'};
      final client = MockClient((request) async {
        return http.Response(json.encode(mapData), 200);
      });

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result.length, 1);
      expect(result.first, {'key': 'value'});
    });

    test('should return empty list if remote returns invalid JSON', () async {
      SharedPreferences.setMockInitialValues({});
      final client = MockClient((request) async {
        return http.Response('invalid-json', 200);
      });

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result, isEmpty);
    });

    test('should return empty list if remote returns non-list/non-map', () async {
      SharedPreferences.setMockInitialValues({});
      final client = MockClient((request) async {
        return http.Response('123', 200);
      });

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result, isEmpty);
    });

    test('should work without explicit client and hit remote timeout/error', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson);
      expect(result.first['source'], 'default');
    });

    test('should handle remote non-200 status', () async {
      SharedPreferences.setMockInitialValues({});
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final result = await loadJsonRemoteOrAppState(remoteName, defaultJson, client: client);
      expect(result.first['source'], 'default');
    });
  });
}
