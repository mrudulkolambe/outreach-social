// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';

class ShimmerImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const ShimmerImage(
      {super.key,
      required this.imageUrl,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!kIsWeb)
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        if (kIsWeb)
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: width,
            height: height,
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
