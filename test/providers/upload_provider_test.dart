import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/functions/upload_video_to_gradio.dart';
import 'package:swish_lab/providers/upload_provider.dart';

void main() {
  group('UploadProvider', () {
    test('videoUploaderProvider provides uploadVideoToGradio function', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final uploader = container.read(videoUploaderProvider);
      expect(uploader, equals(uploadVideoToGradio));
    });
  });
}
