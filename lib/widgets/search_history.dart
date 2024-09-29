import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/screens/user_profile.dart';
import 'package:outreach/widgets/circular_image.dart';

class SearchHistoryCard extends StatelessWidget {
  final PostUser user;
  const SearchHistoryCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(
            () => UserProfile(
              userId: user.id!,
            ),
          ),
          contentPadding: const EdgeInsets.all(0),
          leading: user.imageUrl == null
              ? Container(
                  height: 45,
                  width: 45,
                  child: Center(
                    child:
                        SvgPicture.asset("assets/icons/user-placeholder.svg"),
                  ),
                )
              : CircularImage(
                  size: 45,
                  path: user.imageUrl!,
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@${user.username}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                "20 followers",
                style: TextStyle(color: grey, fontSize: 12),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
