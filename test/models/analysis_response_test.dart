import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/analysis_response.dart';

void main() {
  group('AnalysisResponse', () {
    test('fromJson creates a valid object', () {
      final json = {'event_id': 'evt123'};
      final result = AnalysisResponse.fromJson(json);
      expect(result.eventId, 'evt123');
    });
  });
}
