import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Create a temporary local image downloading the URL provided
Future<File> localImageFromUrl(String imageUrl) async {
  if (imageUrl.isEmpty) {
    throw Exception('No image URL provided');
  }

  // Download the image from the network
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) {
    throw Exception('Failed to download image (status ${response.statusCode})');
  }

  final bytes = response.bodyBytes;
  final fileName = imageUrl.split('/').last.split('?').first;

  final tempDir = await getTemporaryDirectory();
  final filePath = p.join(tempDir.path, fileName);

  final file = File(filePath);
  await file.writeAsBytes(bytes);

  return file;
}
