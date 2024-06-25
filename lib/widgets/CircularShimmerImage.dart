// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularShimmerImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CircularShimmerImage({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!kIsWeb)
          ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Container(
              width: size,
              height: size,
              color: Colors.grey[300],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }
}
