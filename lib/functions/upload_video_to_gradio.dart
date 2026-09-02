import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../logger.dart';

final uploadLogger = AppLogger.scope('Upload');

/// Custom exceptions for better error propagation
class UploadException implements Exception {
  final String message;
  final int? statusCode;
  UploadException(this.message, {this.statusCode});
  @override
  String toString() => 'UploadException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Upload the supplied video to Gradio using streaming to save memory.
///
/// Uses Dio for easier multipart streaming and cancellation support.
Future<String> uploadVideoToGradio(
  File videoFile, {
  Dio? dioClient,
  CancelToken? cancelToken,
}) async {
  try {
    if (!await videoFile.exists()) {
      throw UploadException("Video file not found at path: ${videoFile.path}");
    }

    // Using Dio allows us to stream from disk using MultipartFile.fromFile
    // which significantly reduces memory usage compared to readAsBytes()
    final dio = dioClient ?? Dio();
    final url = '$hfSpace/gradio_api/upload';

    final formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(
        videoFile.path,
        filename: path.basename(videoFile.path),
      ),
    });

    final Response<dynamic> response = await dio.post<dynamic>(
      url,
      data: formData,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );

    if (response.statusCode == 200) {
      final jsonResp = response.data;

      // Gradio responds with a list: take first element
      if (jsonResp is List && jsonResp.isNotEmpty) {
        return jsonResp[0] as String;
      } else {
        throw UploadException("Unexpected response format from server");
      }
    } else {
      throw UploadException("Server rejected upload", statusCode: response.statusCode);
    }
  } catch (e, stack) {
    if (e is DioException && CancelToken.isCancel(e)) {
      uploadLogger.i("Upload cancelled by user");
      rethrow;
    }
    uploadLogger.e("Error uploading video", error: e, stackTrace: stack);
    rethrow;
  }
}
