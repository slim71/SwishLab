import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../functions/upload_video_to_gradio.dart';

typedef VideoUploader = Future<String> Function(
  File videoFile, {
  Dio? dioClient,
  CancelToken? cancelToken,
});

final videoUploaderProvider = Provider<VideoUploader>((ref) {
  return uploadVideoToGradio;
});
