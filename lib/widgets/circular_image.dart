import 'package:flutter/material.dart';

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
      child: Image.network(
        fit: BoxFit.cover,
        path,
        height: size,
        width: size,
      ),
    );
  }
}
