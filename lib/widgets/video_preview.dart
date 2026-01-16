import 'package:SwishLab/models/video_source.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final VideoSource source;
  final bool autoPlay;
  final bool looping;

  const VideoPreview({
    super.key,
    required this.source,
    this.autoPlay = false,
    this.looping = true,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = switch (widget.source) {
      FileVideoSource(:final file) => VideoPlayerController.file(file),
      NetworkVideoSource(:final url) => VideoPlayerController.networkUrl(Uri.parse(url)),
    }
      ..setLooping(widget.looping)
      ..initialize().then((_) {
        if (widget.autoPlay) {
          _controller.play();
        }
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          IconButton(
            iconSize: 48,
            color: Colors.white,
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
          ),
        ],
      ),
    );
  }
}
