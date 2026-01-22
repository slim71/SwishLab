import 'dart:convert';
import 'dart:io';

import 'package:SwishLab/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// Upload the supplied video to Gradio.
///
/// This is needed because we don't supply URLs to Gradio/HuggingFace, but a
/// local file. These files need to be in Gradio's cache, but directly using
/// the file local path won't work: it would result in an InvalidPathError
/// This actions solves that, uploading the local file to Gradio's cache so
/// that it as a reference available for it.
Future<String?> uploadVideoToGradio(File videoFile) async {
  try {
    // Check there are actually file bytes
    if (!await videoFile.exists()) {
      throw Exception("File does not exist.");
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

    final response = await request.send();

    // All good
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = json.decode(respStr);

      // Gradio responds with a list: take first element
      if (jsonResp is List && jsonResp.isNotEmpty) {
        return jsonResp[0] as String; // <-- the cached path in HuggingFace Space
      } else {
        throw Exception("Unexpected response: $jsonResp");
      }

      // Some kind of error
    } else {
      throw Exception("Upload failed: ${response.statusCode}");
    }
  } catch (e) {
    print("Error uploading video: $e");
    return null;
  }
}
