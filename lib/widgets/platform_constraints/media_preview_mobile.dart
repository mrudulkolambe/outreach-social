// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:video_player/video_player.dart';

Widget buildMediaPreview(
    Uint8List mediaData, String fileName, double height, double width) {
  return MediaPreviewMobile(
    mediaFile: File.fromRawPath(mediaData),
    fileName: fileName,
    height: height,
    width: width,
  );
}

class MediaPreviewMobile extends StatefulWidget {
  final File mediaFile;
  final String fileName;
  final double height;
  final double width;

  const MediaPreviewMobile({
    super.key,
    required this.mediaFile,
    required this.fileName,
    this.height = 135,
    this.width = 150,
  });

  @override
  _MediaPreviewMobileState createState() => _MediaPreviewMobileState();
}

class _MediaPreviewMobileState extends State<MediaPreviewMobile> {
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.fileName.endsWith('mp4') || widget.fileName.endsWith('mov')) {
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
  void didUpdateWidget(MediaPreviewMobile oldWidget) {
    if (oldWidget.mediaFile != widget.mediaFile) {
      if (_videoController != null) {
        _videoController!.dispose();
      }
      if (widget.fileName.endsWith('mp4') || widget.fileName.endsWith('mov')) {
        _videoController = VideoPlayerController.file(widget.mediaFile);
        _initializeVideoPlayerFuture = _videoController!.initialize();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileName.endsWith('mp4') || widget.fileName.endsWith('mov')) {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              height: widget.height,
              width: widget.width,
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          widget.mediaFile,
          height: widget.height,
          width: widget.width,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
