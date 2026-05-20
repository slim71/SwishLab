import 'package:flutter_riverpod/legacy.dart';

import '../controllers/shooting_analysis_notifier.dart';
import '../models/analysis_state.dart';

final shootingAnalysisProvider = StateNotifierProvider.autoDispose<ShootingAnalysisController, AnalysisState>(
  (ref) => ShootingAnalysisController(ref),
);
