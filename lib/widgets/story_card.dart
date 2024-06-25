import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StoryCard extends StatelessWidget {
  final String url;

  const StoryCard({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 8,
        ),
        // Container(
        //   height: 103,
        //   width: 88,
        //   decoration: BoxDecoration(
        //     color: Colors.red,
        //     borderRadius: BorderRadius.circular(14),
        //   ),
        // ),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            url,
            height: 103,
            width: 88,
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
