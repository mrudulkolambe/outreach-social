
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/comment_feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/controller/comment.dart';

class ForumCommentBottomSheet extends StatefulWidget {
  final String postId;

  const ForumCommentBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  _ForumCommentBottomSheet createState() => _ForumCommentBottomSheet();
}

class _ForumCommentBottomSheet extends State<ForumCommentBottomSheet> {
  bool isPosting = false;
  CommentFeedServices commentFeedServices = CommentFeedServices();
  final TextEditingController commentController = TextEditingController();
  final FeedCommentController feedCommentController =
      Get.put(FeedCommentController());

  void postComment() async {
    setState(() {
      isPosting = true;
    });
    final body = {'text': commentController.text};
    final response =
        await commentFeedServices.createForumComment(widget.postId, body);
    if (response != null) {
      feedCommentController.addForumComment(response);
      commentController.text = "";
    }
    setState(() {
      Get.back();
      isPosting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: constraints.maxWidth,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: grey.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: commentController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Comment here...",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            color: isPosting ? Colors.white : accent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: isPosting
                              ? const CircularProgressIndicator(
                                  color: accent,
                                )
                              : IconButton(
                                  onPressed: isPosting ? () {} : postComment,
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
