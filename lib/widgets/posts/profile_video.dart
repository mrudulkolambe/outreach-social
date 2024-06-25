import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreenProfile extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreenProfile({required this.videoPath});

  @override
  _VideoPlayerScreenProfileState createState() =>
      _VideoPlayerScreenProfileState();
}

class _VideoPlayerScreenProfileState extends State<VideoPlayerScreenProfile> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 115,
      child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
            ),
            if (_controller.value.isInitialized)
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
