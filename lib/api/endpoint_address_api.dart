import 'dart:convert';

import 'package:SwishLab/api/api_client.dart';
import 'package:SwishLab/models/analysis_response.dart';
import 'package:SwishLab/models/results_response.dart';
import 'package:dio/dio.dart';

class EndpointAddressApi {
  final ApiClient _client;

  EndpointAddressApi(this._client);

  /// -------------------------------
  /// POST /gradio_api/call/api_endpoint
  /// AnalyzeShootingForm
  /// -------------------------------
  Future<AnalysisResponse> analyzeShootingForm({
    required String sourceVideo,
    required String shootingHand,
    required String pointOfView,
  }) async {
    final response = await _client.dio.post(
      '/gradio_api/call/api_endpoint',
      data: {
        // JSON body
        "data": [
          {
            "video": {
              "path": sourceVideo,
              "meta": {
                "_type": "gradio.FileData",
              }
            }
          },
          shootingHand,
          pointOfView,
        ]
      },
    );
    return AnalysisResponse.fromJson(response.data);
  }

  /// --------------------------------
  /// GET /gradio_api/{hf_event_id}
  /// GetShootingFormResults (STREAM)
  /// --------------------------------
  Stream<String> getShootingFormResults({
    required String hfEventId,
  }) async* {
    final response = await _client.dio.get<ResponseBody>(
      '/gradio_api/$hfEventId',
      options: Options(
        responseType: ResponseType.stream,
      ),
    );

    final stream = response.data?.stream;
    if (stream == null) return;

    // Handle chunks
    await for (final chunk in stream) {
      yield String.fromCharCodes(chunk);
    }
  }

  Future<AnalysisResults> getFinalAnalysisResult({
    required String hfEventId,
  }) async {
    final buffer = StringBuffer();

    await for (final chunk in getShootingFormResults(hfEventId: hfEventId)) {
      buffer.write(chunk);
    }

    return _parseSseResponse(buffer.toString());
  }

  AnalysisResults _parseSseResponse(String raw) {
    String? currentEvent;
    String? currentData;

    for (final line in const LineSplitter().convert(raw)) {
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        if (currentEvent == 'complete' && currentData != null) {
          final json = jsonDecode(currentData) as Map<String, dynamic>;
          return AnalysisResults(json);
        }
        currentEvent = null;
        currentData = null;
        continue;
      }

      if (trimmed.startsWith('event:')) {
        currentEvent = trimmed.substring(6).trim();
      } else if (trimmed.startsWith('data:')) {
        final data = trimmed.substring(5).trim();
        currentData = currentData == null ? data : '$currentData$data';
      }
    }

    throw Exception('No complete analysis event found');
  }
}
