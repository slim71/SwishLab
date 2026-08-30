import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/router/app_documents.dart';

void main() {
  group('AppDocument', () {
    test('constructor sets fields correctly', () {
      const doc = AppDocument('file', 'title');
      expect(doc.file, equals('file'));
      expect(doc.title, equals('title'));
    });

    test('appDocuments map is correctly populated', () {
      expect(appDocuments, isNotEmpty);
      expect(appDocuments.containsKey('EULA'), isTrue);
      expect(appDocuments['EULA']?.file, equals('EULA'));
      expect(appDocuments['PRIVACY']?.title, equals('Privacy Policy'));
    });
  });
}
