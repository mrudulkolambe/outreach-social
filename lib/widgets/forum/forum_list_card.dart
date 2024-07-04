import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/screens/forum/forum_details.dart';
import 'package:outreach/screens/forum/joined_forum_details.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

class ForumListCard extends StatelessWidget {
  final Forum forum;

  const ForumListCard({super.key, required this.forum});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => JoinedForumDetails(
            forum: forum,
          )),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularShimmerImage(
                  imageUrl: forum.image,
                  size: 48,
                ),
                Expanded(
                  child: Text(
                    forum.name,
                    style: const TextStyle(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
