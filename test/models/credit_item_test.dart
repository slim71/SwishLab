import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/credit_item.dart';

void main() {
  group('Credit', () {
    test('fromJson creates a valid object', () {
      final json = {
        'author': 'Author Name',
        'url': 'https://example.com',
        'asset': 'asset.png',
        'type': 'image',
      };
      final result = Credit.fromJson(json);
      expect(result.author, 'Author Name');
      expect(result.url, 'https://example.com');
      expect(result.asset, 'asset.png');
      expect(result.type, 'image');
    });

    test('fromJson handles null or missing values with defaults', () {
      final json = <String, dynamic>{};
      final result = Credit.fromJson(json);
      expect(result.author, '');
      expect(result.url, '');
      expect(result.asset, '');
      expect(result.type, '');
    });
  });
}
