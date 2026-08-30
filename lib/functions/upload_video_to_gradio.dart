import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../logger.dart';

final uploadLogger = AppLogger.scope('Upload');

/// Factory for http client, allows overriding in tests
http.Client Function() httpClientFactory = () => http.Client();

/// Custom exceptions for better error propagation
class UploadException implements Exception {
  final String message;
  final int? statusCode;
  UploadException(this.message, {this.statusCode});
  @override
  String toString() => 'UploadException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Upload the supplied video to Gradio.
///
/// This is needed because we don't supply URLs to Gradio/HuggingFace, but a
/// local file. These files need to be in Gradio's cache, but directly using
/// the file local path won't work: it would result in an InvalidPathError
/// This actions solves that, uploading the local file to Gradio's cache so
/// that it as a reference available for it.
Future<String> uploadVideoToGradio(File videoFile, {http.Client? client}) async {
  try {
    // Check there are actually file bytes
    if (!await videoFile.exists()) {
      throw UploadException("Video file not found at path: ${videoFile.path}");
    }
    final bytes = await videoFile.readAsBytes();

    // Create a multipart request
    final uri = Uri.parse('$hfSpace/gradio_api/upload');
    final request = http.MultipartRequest('POST', uri);

    // Attach the file
    request.files.add(http.MultipartFile.fromBytes(
      'files',
      bytes,
      filename: path.basename(videoFile.path),
    ));

    final httpClient = client ?? httpClientFactory();
    try {
      // Add explicit request timeout
      final response = await httpClient.send(request).timeout(
            const Duration(seconds: 90),
            onTimeout: () => throw UploadException("Upload timed out (server took too long to respond)"),
          );

      // All good
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResp = json.decode(respStr);

        // Gradio responds with a list: take first element
        if (jsonResp is List && jsonResp.isNotEmpty) {
          return jsonResp[0] as String; // <-- the cached path in HuggingFace Space
        } else {
          throw UploadException("Unexpected response format from server");
        }

        // Some kind of error
      } else {
        throw UploadException("Server rejected upload", statusCode: response.statusCode);
      }
    } finally {
      if (client == null) httpClient.close();
    }
  } catch (e, stack) {
    uploadLogger.e("Error uploading video", error: e, stackTrace: stack);
    rethrow;
  }
}
