// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/screens/forum/joined_forum_details.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/styled_button.dart';

class ForumDetails extends StatefulWidget {
  final bool joined;
  final Forum forum;

  const ForumDetails({super.key, required this.joined, required this.forum});

  @override
  State<ForumDetails> createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }

  void joinedForum() async {
    final result = await ForumServices().joinForum(widget.forum.id);
    if (result == 200) {
      Get.dialog(
        Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: horizontal_p),
          backgroundColor: Colors.black,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: horizontal_p, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width - 2 * horizontal_p,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/illustrations/forum_created.svg",
                  height: 120,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "You have joined  the forum!",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "The best way to Spark new friendship",
                        style: TextStyle(
                          color: grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: InkWell(
                    onTap: () => Get.offAll(() => JoinedForumDetails(
                          forum: widget.forum,
                        )),
                    child: const StyledButton(
                      loading: false,
                      text: "Explore forum",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      ToastManager.showToast("Something went wrong!", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;
    const double buttonBottomPadding = 20;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: Text(
          widget.forum.name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.network(
            widget.forum.image,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          DraggableScrollableSheet(
            snap: true,
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Created by',
                            style: TextStyle(color: grey),
                          ),
                          const SizedBox(width: 5),
                          CircularShimmerImage(
                            imageUrl: widget.forum.userId.imageUrl,
                            size: 24,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "@${widget.forum.userId.username}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "${widget.forum.joined.length} members",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.forum.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                          height: buttonHeight + buttonBottomPadding + 20),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: buttonBottomPadding,
            left: horizontal_p,
            right: horizontal_p,
            child: InkWell(
                onTap: joinedForum,
                child: const StyledButton(loading: false, text: "Join now")),
          ),
        ],
      ),
    );
  }
}
