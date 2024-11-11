import 'package:flutter/material.dart';
import 'package:outreach/utils/number_formatter.dart';

class StatsElem extends StatelessWidget {
  final int count;
  final String title;

  const StatsElem({super.key, required this.count, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            numberFormatter(count),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }
}
