import 'dart:io';

sealed class VideoSource {
  const VideoSource();
}

class FileVideoSource extends VideoSource {
  final File file;

  const FileVideoSource(this.file);
}

class NetworkVideoSource extends VideoSource {
  final String url;

  const NetworkVideoSource(this.url);
}
