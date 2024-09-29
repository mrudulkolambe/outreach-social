import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CircularImage extends StatelessWidget {
  final double size;
  final String path;

  const CircularImage({
    super.key,
    required this.size,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: path,
        height: size,
        width: size,
      ),
    );
  }
}
