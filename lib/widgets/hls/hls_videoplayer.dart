// ignore_for_file: library_private_types_in_public_api

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HLSVideoPlayer extends StatefulWidget {
  final String url;

  const HLSVideoPlayer({super.key, required this.url});

  @override
  _HLSVideoPlayerState createState() => _HLSVideoPlayerState();
}

class _HLSVideoPlayerState extends State<HLSVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool isMuted = false;
  bool isEnded = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
              _videoPlayerController.value.duration &&
          !_videoPlayerController.value.isPlaying) {
        setState(() {
          isEnded = true;
        });
      }
    });

    _chewieController = ChewieController(
      allowMuting: true,
      showControls: false,
      allowPlaybackSpeedChanging: false,
      showControlsOnInitialize: false,
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );

    setState(() {});
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _videoPlayerController.setVolume(isMuted ? 0 : 1);
    });
  }

  void _replayVideo() {
    setState(() {
      isEnded = false;
      _videoPlayerController.seekTo(Duration.zero);
      _videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: VisibilityDetector(
                  key: Key(widget.url),
                  onVisibilityChanged: (visibilityInfo) {
                    if (mounted) {
                      final visibleFraction = visibilityInfo.visibleFraction;
                      if (visibleFraction == 0) {
                        _chewieController!.pause();
                      } else {
                        _chewieController!.play();
                      }
                    }
                  },
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    enableFeedback: true,
                    onPressed: _toggleMute,
                    icon: Icon(
                      isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              if (isEnded && !_chewieController!.isPlaying)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.replay,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: _replayVideo,
                    ),
                  ),
                ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
