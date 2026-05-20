import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/analysis_response.dart';
import '../models/results_response.dart';
import 'api_client.dart';

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
    final url = '${_client.dio.options.baseUrl}/gradio_api/call/api_endpoint';
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/gradio_api/call/api_endpoint',
        data: {
          // JSON body
          "data": [
            {
              "path": sourceVideo,
              "meta": {
                "_type": "gradio.FileData",
              }
            },
            shootingHand.toUpperCase(),
            pointOfView.toUpperCase(),
          ]
        },
      );
      return AnalysisResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    }
  }

  /// --------------------------------
  /// GET /gradio_api/call/api_endpoint/{hf_event_id}
  /// GetShootingFormResults (STREAM)
  /// --------------------------------
  Stream<String> getShootingFormResults({
    required String hfEventId,
  }) async* {
    final url = '/gradio_api/call/api_endpoint/$hfEventId';

    try {
      final response = await _client.dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          // We want to keep the connection open for as long as the analysis takes
          receiveTimeout: const Duration(minutes: 10),
        ),
      );

      final stream = response.data?.stream;
      if (stream == null) {
        return;
      }

      // Handle chunks as lines using UTF-8 decoding
      yield* stream.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter());
    } on DioException catch (e) {
      _logger.e('DioException in getShootingFormResults', error: e);
      rethrow;
    }
  }

  Future<ResultsResponse> getFinalAnalysisResult({
    required String hfEventId,
  }) async {
    String? currentEvent;
    String? currentData;
    final fullBuffer = StringBuffer();

    try {
      await for (final line in getShootingFormResults(hfEventId: hfEventId)) {
        final trimmed = line.trim();
        fullBuffer.writeln(trimmed);

        // Detailed logging for each SSE event line
        if (trimmed.isNotEmpty) {
          _logger.d('SSE > $trimmed');
        }

        if (trimmed.isEmpty) {
          if (currentEvent == 'complete' && currentData != null) {
            final decoded = jsonDecode(currentData);

            if (decoded is List) {
              if (decoded.isNotEmpty) {
                final first = decoded.first;
                if (first is Map<String, dynamic>) {
                  return ResultsResponse(first);
                }
                // If it's not a map, wrap it so ResultsResponse can still be created
                return ResultsResponse({'data': decoded});
              }
              return ResultsResponse({'data': <dynamic>[]});
            } else if (decoded is Map<String, dynamic>) {
              return ResultsResponse(decoded);
            } else {
              return ResultsResponse({'raw_data': decoded});
            }
          }
          currentEvent = null;
          currentData = null;
          continue;
        }

        if (trimmed.startsWith('event:')) {
          currentEvent = trimmed.substring(6).trim();
        } else if (trimmed.startsWith('data:')) {
          final data = trimmed.substring(5).trim();
          currentData = (currentData == null) ? data : '$currentData$data';
        } else if (trimmed.startsWith('error:')) {
          throw Exception('Backend Error: ${trimmed.substring(6)}');
        }
      }
    } catch (e) {
      rethrow;
    }

    throw Exception('Stream closed without "complete" event. Full response so far: \n$fullBuffer');
  }
}
