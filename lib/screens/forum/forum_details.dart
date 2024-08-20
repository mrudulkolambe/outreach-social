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
            maxChildSize: 0.7,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
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
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
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
                                imageUrl: widget.forum.userId.imageUrl,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                "@${widget.forum.userId.username}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.forum.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: joinedForum,
                      child: const StyledButton(
                        loading: false,
                        text: "Join now",
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
