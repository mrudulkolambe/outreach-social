import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class MediaPreview extends StatefulWidget {
  final File mediaFile;
  final double height;
  final double width;

  MediaPreview({
    required this.mediaFile,
    this.height = 135,
    this.width = 165,
  });

  @override
  _MediaPreviewState createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.mediaFile.path.endsWith('mp4') ||
        widget.mediaFile.path.endsWith('mov')) {
      _videoController = VideoPlayerController.file(widget.mediaFile);
      _initializeVideoPlayerFuture = _videoController!.initialize();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MediaPreview oldWidget) {
    if (oldWidget.mediaFile != widget.mediaFile) {
      if (_videoController != null) {
        _videoController!.dispose();
      }
      if (widget.mediaFile.path.endsWith('mp4') ||
          widget.mediaFile.path.endsWith('mov')) {
        _videoController = VideoPlayerController.file(widget.mediaFile);
        _initializeVideoPlayerFuture = _videoController!.initialize();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaFile.path.endsWith('mp4') ||
        widget.mediaFile.path.endsWith('mov')) {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: widget.height,
              width: widget.width,
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      return Image.file(
        widget.mediaFile,
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
      );
    }
  }
}
