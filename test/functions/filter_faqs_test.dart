import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/filter_faqs.dart';

void main() {
  group('filterFaqs', () {
    final faqs = [
      {'question': 'What is SwishLab?', 'answer': 'It is a basketball analysis tool.'},
      {'question': 'How to use it?', 'answer': 'Upload a video of your shot.'},
      {'question': 'Is it free?', 'answer': 'Yes, for now.'},
    ];

    test('should return all faqs when search is empty', () {
      expect(filterFaqs(faqs, ''), faqs);
    });

    test('should filter by question', () {
      final result = filterFaqs(faqs, 'swish');
      expect(result.length, 1);
      expect(result[0]['question'], 'What is SwishLab?');
    });

    test('should filter by answer', () {
      final result = filterFaqs(faqs, 'video');
      expect(result.length, 1);
      expect(result[0]['question'], 'How to use it?');
    });

    test('should be case insensitive', () {
      final result = filterFaqs(faqs, 'SWISH');
      expect(result.length, 1);
      expect(result[0]['question'], 'What is SwishLab?');
    });

    test('should return empty list if no match found', () {
      final result = filterFaqs(faqs, 'nonexistent');
      expect(result, isEmpty);
    });

    test('should handle items that are not maps', () {
      final mixedFaqs = [...faqs, 'not a map'];
      final result = filterFaqs(mixedFaqs, 'swish');
      expect(result.length, 1);
    });

    test('should handle maps with missing keys', () {
      final incompleteFaqs = [
        {'question': 'No answer'},
        {'answer': 'No question'},
      ];
      expect(filterFaqs(incompleteFaqs, 'swish'), isEmpty);
    });
  });
}
