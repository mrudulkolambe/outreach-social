import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final bool? loading;

  const CustomButton({ super.key, required this.text, this.loading });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration:
          BoxDecoration(color: accent, borderRadius: BorderRadius.circular(8)),
      child: const Center(
        child: Text(
          "Continue",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
