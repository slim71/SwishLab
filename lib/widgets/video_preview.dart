import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;

  const VideoPreview({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = true,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )
      ..setLooping(widget.looping)
      ..initialize().then((_) {
        if (widget.autoPlay) {
          _controller.play();
        }
        setState(() {});
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
