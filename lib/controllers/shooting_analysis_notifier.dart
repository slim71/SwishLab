import 'package:SwishLab/models/analysis_state.dart';
import 'package:SwishLab/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ShootingAnalysisController extends StateNotifier<AnalysisState> {
  ShootingAnalysisController(this.ref) : super(AnalysisIdle());

  final Ref ref;

  Future<void> start({
    required String sourceVideo,
    required String shootingHand,
    required String pointOfView,
  }) async {
    try {
      state = AnalysisLoading();

      final api = ref.read(endpointAddressApiProvider);

      final analyzeResponse = await api.analyzeShootingForm(
        sourceVideo: sourceVideo,
        shootingHand: shootingHand,
        pointOfView: pointOfView,
      );

      final eventId = analyzeResponse.eventId;
      final result = await api.getFinalAnalysisResult(hfEventId: eventId);

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
