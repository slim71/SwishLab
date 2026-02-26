import 'package:flutter_riverpod/legacy.dart';
import 'package:swish_lab/controllers/shooting_analysis_notifier.dart';
import 'package:swish_lab/models/analysis_state.dart';

final shootingAnalysisProvider = StateNotifierProvider<ShootingAnalysisController, AnalysisState>(
  (ref) => ShootingAnalysisController(ref),
);
