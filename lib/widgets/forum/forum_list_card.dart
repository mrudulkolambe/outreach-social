import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/screens/forum/forum_details.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

class ForumListCard extends StatelessWidget {
  final String title;

  const ForumListCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => Get.to(() => const ForumDetails()),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularShimmerImage(
                  imageUrl:
                      "https://s3-alpha-sig.figma.com/img/e168/327f/58205971b1c3cbc8902a9893bf549407?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=WzCuZK1Mw614hF5UK9ODGKuiDYx33WfuYqv9bUJL6~C2Py2JzhklnrBE4yiGvvHx1mrP2LS87FOOiV5hrgWOdv48QkSk5jnxDwJQIv3~aH6Q3GsssSo48F6yqePQodhvKOxXHAvrJnk-jRq1x8LgSGdq~8C7hq1I24mq0nCthRpYFEVheA0rgK6-YqHfexkiDOl0KzhYYfexG4oqOa8otMXEhWJ7w4OVKiVS7D5PDvf-okuWS8jgMHBeviLG5J8xoZsjpjjeWq~f2oWt-v8A9DM2H6xk1rCa1eTbLhP-wf7PDaEBsj5w6zkR95WjQsTYE1nrG0rvdd9YcNljLr3VrA__",
                  size: 48,
                ),
                Expanded(
                  child: Text(
                    title,
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
