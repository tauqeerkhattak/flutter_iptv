import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  const VideoScreen({
    super.key,
    required this.url,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.url,
      ),
    );
    await _controller?.initialize();
    await _controller?.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller?.value.isPlaying ?? false) {
            await _controller?.pause();
          } else {
            await _controller?.play();
          }
          setState(() {});
        },
        child: Icon(
          _controller?.value.isPlaying ?? false
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller?.value.isInitialized ?? false) {
      return Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(
            _controller!,
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
