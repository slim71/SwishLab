import 'package:SwishLab/models/results_response.dart';

sealed class AnalysisState {}

class AnalysisIdle extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisSuccess extends AnalysisState {
  final AnalysisResults result;

  AnalysisSuccess(this.result);
}

class AnalysisFailure extends AnalysisState {
  final Object error;

  AnalysisFailure(this.error);
}
