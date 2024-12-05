import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShimmerImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const ShimmerImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        cacheKey: imageUrl,
        useOldImageOnUrlChange: true,
        filterQuality: FilterQuality.medium,
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        ),
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    );
  }
}
