import 'results_response.dart';

sealed class AnalysisState {}

class AnalysisIdle extends AnalysisState {}

class AnalysisLoading extends AnalysisState {
  final double progress;

  AnalysisLoading({this.progress = 0.0});
}

class AnalysisSuccess extends AnalysisState {
  final ResultsResponse result;

  AnalysisSuccess(this.result);
}

class AnalysisFailure extends AnalysisState {
  final Object error;

  AnalysisFailure(this.error);
}
