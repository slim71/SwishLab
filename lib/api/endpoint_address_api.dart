import 'dart:convert';

import 'package:dio/dio.dart';

import '../logger.dart';
import '../models/analysis_response.dart';
import '../models/results_response.dart';
import 'api_client.dart';

class EndpointAddressApi {
  final ApiClient _client;
  final _logger = AppLogger.scope('EndpointApi');

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
    _logger.i('POST to $url');
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
      _logger.i('Response from analyzeShootingForm: ${response.data}');
      return AnalysisResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.e('DioException in analyzeShootingForm', error: e);
      if (e.response?.statusCode == 404) {
        _logger.e(
            '404 Error: The endpoint /gradio_api/call/api_endpoint was not found. Base URL: ${_client.dio.options.baseUrl}');
      }
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
    _logger.i('GET (Stream) from ${_client.dio.options.baseUrl}$url');

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
        _logger.w('Stream is null for event $hfEventId');
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

    _logger.i('Listening for SSE completion on event $hfEventId');

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
            _logger.i('Success! Received "complete" event.');
            final decoded = jsonDecode(currentData);

            if (decoded is List) {
              _logger.i('Decoded data is a List. Taking the first element if available.');
              if (decoded.isNotEmpty) {
                final first = decoded.first;
                if (first is Map<String, dynamic>) {
                  return ResultsResponse(first);
                }
                // If it's not a map, wrap it so ResultsResponse can still be created
                return ResultsResponse(<String, dynamic>{'data': decoded});
              }
              return ResultsResponse(<String, dynamic>{'data': <dynamic>[]});
            } else if (decoded is Map<String, dynamic>) {
              return ResultsResponse(decoded);
            } else {
              _logger.w('Decoded data is of unexpected type: ${decoded.runtimeType}');
              return ResultsResponse(<String, dynamic>{'raw_data': decoded});
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
          _logger.e('Backend reported error event: $trimmed');
          throw Exception('Backend Error: ${trimmed.substring(6)}');
        }
      }
    } catch (e, stack) {
      _logger.e('Stream error while waiting for result', error: e, stackTrace: stack);
      if (fullBuffer.isNotEmpty) {
        _logger.d('Last bits of data received before crash: \n${fullBuffer.toString()}');
      }
      rethrow;
    }

    throw Exception('Stream closed without "complete" event. Full response so far: \n$fullBuffer');
  }
}
