import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../functions/upload_video_to_gradio.dart';

typedef VideoUploader = Future<String> Function(File);

final videoUploaderProvider = Provider<VideoUploader>((ref) {
  return uploadVideoToGradio;
});
