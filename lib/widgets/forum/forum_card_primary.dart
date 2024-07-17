import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/forum_details.dart';
import 'package:outreach/screens/forum/joined_forum_details.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/shimmer_image.dart';

class ForumCardPrimary extends StatelessWidget {
  final bool joined;
  final Forum forum;

  const ForumCardPrimary({
    super.key,
    required this.joined,
    required this.forum,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => joined
          ? JoinedForumDetails(forum: forum)
          : ForumDetails(joined: joined, forum: forum)),
      child: Container(
        height: 155,
        color: const Color.fromRGBO(227, 231, 230, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontal_p,
                vertical: 20,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ShimmerImage(
                      imageUrl: forum.image,
                      height: 110,
                      width: 165,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  forum.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Created by',
                                style: TextStyle(color: grey),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CircularShimmerImage(
                                imageUrl: forum.userId.imageUrl,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                "@${forum.userId.username}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('${forum.joined.length} joined'),
                              const SizedBox(
                                width: 5,
                              ),
                               CircularShimmerImage(
                                imageUrl: forum.userId.imageUrl,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (!joined)
                            const Row(
                              children: [
                                Text(
                                  "Join now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
