import 'dart:async';

import 'package:flutter/services.dart' show rootBundle, AssetBundle;
import 'package:http/http.dart' as http;

import '../logger.dart';

final _logger = AppLogger.scope('MarkdownLoader');

/// Load Markdown content
Future<String> loadMarkdown(String fileName, {AssetBundle? bundle, http.Client? client}) async {
  final localPath = 'assets/markdown/$fileName.md';
  final assetBundle = bundle ?? rootBundle;

  try {
    _logger.d("Trying local md: $localPath");
    final localContent = await assetBundle.loadString(localPath);
    return localContent;
  } catch (e) {
    _logger.w("Failed to load local md: $e");
  }

  // Try remote URL
  final remoteUrl = "https://ccqvtpiltowjpogbjmpd.supabase.co/storage/v1/object/public/assets/mds/$fileName.md";

  try {
    _logger.d("Trying remote md: $remoteUrl");
    final httpClient = client ?? http.Client();
    final response = await httpClient.get(Uri.parse(remoteUrl));
    if (client == null) httpClient.close();
    if (response.statusCode == 200) return response.body;
  } catch (e, st) {
    _logger.e("Failed to load remote md", error: e, stackTrace: st);
  }

  // Fallback
  _logger.w("Fallback to default for $fileName");
  return '# Content not available';
}
