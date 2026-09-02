import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../logger.dart';
import '../models/analysis_state.dart';
import '../providers/api_providers.dart';
import '../providers/auth_providers.dart';
import '../providers/statistics_provider.dart';
import '../providers/upload_provider.dart';

class ShootingAnalysisController extends StateNotifier<AnalysisState> {
  ShootingAnalysisController(this.ref) : super(AnalysisIdle());

  final Ref ref;
  final _logger = AppLogger.scope('ShootingAnalysis');
  bool _isCancelled = false;
  CancelToken? _cancelToken;

  void cancel() {
    _logger.w('Analysis cancelled by user.');
    _isCancelled = true;
    _cancelToken?.cancel("User cancelled analysis");
    state = AnalysisIdle();
  }

  Future<void> start({
    required File videoFile,
    required String shootingHand,
    required String pointOfView,
  }) async {
    if (state is AnalysisLoading) {
      _logger.w('Analysis already in progress. Ignoring request.');
      return;
    }

    _isCancelled = false;
    _cancelToken = CancelToken();

    try {
      state = AnalysisLoading();

      _logger.i('Starting analysis process for file: ${videoFile.path}');

      // 1. Upload video to Gradio
      _logger.i('Step 1: Uploading video to Gradio...');
      final uploader = ref.read(videoUploaderProvider);
      final gradioUrl = await uploader(videoFile, cancelToken: _cancelToken).timeout(
        const Duration(minutes: 2),
        onTimeout: () => throw Exception('Upload timed out'),
      );
      if (_isCancelled) return;
      _logger.i('Upload successful. Gradio URL: $gradioUrl');

      // 2. Trigger analysis
      final api = ref.read(endpointAddressApiProvider);

      _logger.i('Step 2: Triggering analysis (hand: $shootingHand, pov: $pointOfView)...');
      final analyzeResponse = await api
          .analyzeShootingForm(
            sourceVideo: gradioUrl,
            shootingHand: shootingHand,
            pointOfView: pointOfView,
            cancelToken: _cancelToken,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Triggering analysis timed out'),
          );
      if (_isCancelled) return;

      final eventId = analyzeResponse.eventId;
      _logger.i('Analysis triggered successfully. Event ID: $eventId');

      // 3. Get results
      _logger.i('Step 3: Waiting for final analysis results (SSE)...');
      final result = await api
          .getFinalAnalysisResult(
            hfEventId: eventId,
            cancelToken: _cancelToken,
          )
          .timeout(
            const Duration(minutes: 5),
            onTimeout: () => throw Exception('Analysis timed out'),
          );
      if (_isCancelled) return;

      if (!result.succeeded) {
        _logger.e('Analysis failed according to result status: ${result.error}');
        state = AnalysisFailure(result.error ?? 'Analysis failed');
        return;
      }

      // 4. Persist to DB
      _logger.i('Step 4: Persisting results to database...');
      final user = ref.read(authUserProvider);
      if (user != null) {
        final statsRepo = ref.read(statisticsRepositoryProvider);
        await statsRepo.insertAnalysisResults(
          userId: user.id,
          analysisData: (result.raw['analysis'] as Map<String, dynamic>? ?? <String, dynamic>{}),
        );
        _logger.i('Results persisted to DB for user ${user.id}');
        // Refresh the statistics provider so the new session appears on the Home Page
        ref.invalidate(userStatisticsProvider);
      }
      if (_isCancelled) return;

      _logger.i('Analysis completed successfully!');
      state = AnalysisSuccess(result);
    } catch (e, stack) {
      if (_isCancelled || (e is DioException && CancelToken.isCancel(e))) {
        _logger.i('Analysis process aborted.');
        return;
      }
      _logger.e('Error during analysis process', error: e, stackTrace: stack);
      state = AnalysisFailure(e);
    } finally {
      _cancelToken = null;
    }
  }
}
