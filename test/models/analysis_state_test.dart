import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/analysis_state.dart';
import 'package:swish_lab/models/results_response.dart';

void main() {
  group('AnalysisState', () {
    test('AnalysisSuccess stores result', () {
      final result = ResultsResponse(<String, dynamic>{});
      final state = AnalysisSuccess(result);
      expect(state.result, result);
    });

    test('AnalysisFailure stores error', () {
      final error = Exception('error');
      final state = AnalysisFailure(error);
      expect(state.error, error);
    });

    test('AnalysisIdle and AnalysisLoading can be instantiated', () {
      expect(AnalysisIdle(), isA<AnalysisIdle>());
      expect(AnalysisLoading(), isA<AnalysisLoading>());
    });
  });
}
