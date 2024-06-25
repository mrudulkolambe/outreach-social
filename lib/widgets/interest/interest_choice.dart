import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/models/interest.dart';

class InterestChoice extends StatelessWidget {
  final InterestType interestType;
  final List<String> selected;

  const InterestChoice({
    super.key,
    required this.interestType,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected.contains(interestType.interest) ? accent : grey.withOpacity(0.1),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            interestType.icon,
            height: interestType.icon == "Fitness & Exercise" ? 10 : 18,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              interestType.interest,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
