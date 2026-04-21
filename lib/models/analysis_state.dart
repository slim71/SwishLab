import 'results_response.dart';

sealed class AnalysisState {}

class AnalysisIdle extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisSuccess extends AnalysisState {
  final ResultsResponse result;

  AnalysisSuccess(this.result);
}

class AnalysisFailure extends AnalysisState {
  final Object error;

  AnalysisFailure(this.error);
}
