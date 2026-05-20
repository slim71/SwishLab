import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../functions/upload_video_to_gradio.dart';
import '../models/analysis_state.dart';
import '../providers/api_providers.dart';

class ShootingAnalysisController extends StateNotifier<AnalysisState> {
  ShootingAnalysisController(this.ref) : super(AnalysisIdle());

  final Ref ref;

  Future<void> start({
    required File videoFile,
    required String shootingHand,
    required String pointOfView,
  }) async {
    try {
      state = AnalysisLoading();

      // 1. Upload video to Gradio
      final gradioUrl = await uploadVideoToGradio(videoFile).timeout(
        const Duration(minutes: 2),
        onTimeout: () => throw Exception('Upload timed out'),
      );
      if (gradioUrl == null || gradioUrl.isEmpty) {
        state = AnalysisFailure('Upload failed');
        return;
      }

      // 2. Trigger analysis
      final api = ref.read(endpointAddressApiProvider);

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

      // 3. Get results
      final result = await api.getFinalAnalysisResult(hfEventId: eventId).timeout(
            const Duration(minutes: 5),
            onTimeout: () => throw Exception('Analysis timed out'),
          );

      if (!result.succeeded) {
        state = AnalysisFailure(result.error ?? 'Analysis failed');
        return;
      }

      state = AnalysisSuccess(result);
    } catch (e) {
      state = AnalysisFailure(e);
    }
  }
}
