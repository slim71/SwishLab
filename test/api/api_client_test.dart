import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/api/api_client.dart';

void main() {
  group('ApiClient', () {
    test('initializes Dio with correct options', () {
      const baseUrl = 'https://api.example.com';
      final client = ApiClient(baseUrl: baseUrl);

      expect(client.dio.options.baseUrl, equals(baseUrl));
      expect(client.dio.options.connectTimeout,
          equals(const Duration(seconds: 30)));
      expect(client.dio.options.receiveTimeout,
          equals(const Duration(minutes: 10)));
      expect(client.dio.options.headers['Content-Type'],
          equals('application/json'));
    });
  });
}
