import 'package:SwishLab/controllers/shooting_analysis_notifier.dart';
import 'package:SwishLab/models/analysis_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final shootingAnalysisProvider = StateNotifierProvider<ShootingAnalysisController, AnalysisState>(
  (ref) => ShootingAnalysisController(ref),
);
