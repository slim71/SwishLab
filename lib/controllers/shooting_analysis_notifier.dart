import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../functions/upload_video_to_gradio.dart';
import '../logger.dart';
import '../models/analysis_state.dart';
import '../providers/api_providers.dart';

class ShootingAnalysisController extends StateNotifier<AnalysisState> {
  ShootingAnalysisController(this.ref) : super(AnalysisIdle());

  final Ref ref;
  final _logger = AppLogger.scope('ShootingAnalysis');

  Future<void> start({
    required File videoFile,
    required String shootingHand,
    required String pointOfView,
  }) async {
    try {
      state = AnalysisLoading();

      _logger.i('Starting analysis process for file: ${videoFile.path}');

      // 1. Upload video to Gradio
      _logger.i('Step 1: Uploading video to Gradio...');
      final gradioUrl = await uploadVideoToGradio(videoFile).timeout(
        const Duration(minutes: 2),
        onTimeout: () => throw Exception('Upload timed out'),
      );
      if (gradioUrl == null || gradioUrl.isEmpty) {
        _logger.e('Upload failed: gradioUrl is null or empty');
        state = AnalysisFailure('Upload failed');
        return;
      }
      _logger.i('Upload successful. Gradio URL: $gradioUrl');

      // 2. Trigger analysis
      final api = ref.read(endpointAddressApiProvider);

      _logger.i('Step 2: Triggering analysis (hand: $shootingHand, pov: $pointOfView)...');
      final analyzeResponse = await api
          .analyzeShootingForm(
            sourceVideo: gradioUrl,
            shootingHand: shootingHand,
            pointOfView: pointOfView,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Triggering analysis timed out'),
          );

      final eventId = analyzeResponse.eventId;
      _logger.i('Analysis triggered successfully. Event ID: $eventId');

      // 3. Get results
      _logger.i('Step 3: Waiting for final analysis results (SSE)...');
      final result = await api.getFinalAnalysisResult(hfEventId: eventId).timeout(
            const Duration(minutes: 5),
            onTimeout: () => throw Exception('Analysis timed out'),
          );

      if (!result.succeeded) {
        _logger.e('Analysis failed according to result status: ${result.error}');
        state = AnalysisFailure(result.error ?? 'Analysis failed');
        return;
      }

      _logger.i('Analysis completed successfully!');
      state = AnalysisSuccess(result);
    } catch (e, stack) {
      _logger.e('Error during analysis process', error: e, stackTrace: stack);
      state = AnalysisFailure(e);
    }
  }
}
