// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularShimmerImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const CircularShimmerImage({
    super.key,
    this.imageUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: imageUrl == null
              ? SvgPicture.asset(
                  "assets/image_placeholder.svg",
                  width: size,
                  height: size,
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ),
      ],
    );
  }
}
