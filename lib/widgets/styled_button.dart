// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';

class StyledButton extends StatelessWidget {
  final bool loading;
  final String text;
  final bool? disabled;

  const StyledButton({super.key, required this.loading, required this.text, this.disabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: disabled == true ? accent.withOpacity(0.5) : accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
