// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/shimmer_image.dart';
import 'package:video_player/video_player.dart';


class MediaCarousel extends StatefulWidget {
  final List<Media> mediaPosts;

  const MediaCarousel({super.key, required this.mediaPosts});

  @override
  _MediaCarouselState createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    for (var post in widget.mediaPosts) {
      if (post.type == 'mp4' || post.type == 'mov') {
        _initializeVideoController(post);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int _currentIndex = 0;

  void _initializeVideoController(Media post) {
    if (!_videoControllers.containsKey(post.url)) {
      _videoControllers[post.url] = VideoPlayerController.network(post.url)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoControllers[post.url]?.setLooping(true);
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            autoPlay: false,
            aspectRatio: 16 / 9, // Adjust aspect ratio as per your requirement
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.mediaPosts.map((post) {
            return Builder(
              builder: (BuildContext context) {
                if (post.type == 'jpg' || post.type == 'jpeg' || post.type == 'png') {
                  return ShimmerImage(
                    imageUrl: post.url,
                    width: double.infinity,
                    height: double.infinity,
                  );
                } else if (post.type == 'mp4' || post.type == 'mov') {
                  final controller = _videoControllers[post.url];
                  if (controller != null && controller.value.isInitialized) {
                    return VideoPlayerWidget(controller: controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                } else {
                  return const Center(child: Text('Unsupported media type'));
                }
              },
            );
          }).toList(),
        ),
        if(widget.mediaPosts.length > 1) Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.mediaPosts.map((post) {
              int index = widget.mediaPosts.indexOf(post);
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? accent : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}



class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({super.key, required this.controller});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onControllerUpdated);
  }

  void _onControllerUpdated() {
    if (!_controller.value.isInitialized || _isControllerDisposed) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isControllerDisposed) {
      return const Center(child: Text('Video not available'));
    }
    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          _controller.value.isPlaying
              ? const Icon(Icons.pause, size: 50, color: Colors.white)
              : const Icon(Icons.play_arrow, size: 50, color: Colors.white),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdated);
    _controller.pause();
    _isControllerDisposed = true;
    super.dispose();
  }
}
