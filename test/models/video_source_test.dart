import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/video_source.dart';

void main() {
  group('VideoSource', () {
    test('FileVideoSource stores file', () {
      final file = File('test.mp4');
      final source = FileVideoSource(file);
      expect(source.file, file);
    });

    test('NetworkVideoSource stores url', () {
      const url = 'https://example.com/video.mp4';
      const source = NetworkVideoSource(url);
      expect(source.url, url);
    });
  });
}
