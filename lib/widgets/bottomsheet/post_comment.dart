import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:outreach/api/models/feed_comments.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/comment_feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final UserData user;

  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.user,
  });

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool isLoading = true;
  bool isPosting = false;
  List<FeedComment> feedComments = [];
  final TextEditingController commentController = TextEditingController();
  final feedCommentServices = CommentFeedServices();

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  void postComment() async {
    setState(() {
      isPosting = true;
    });
    final body = {'text': commentController.text, 'parentID': null};
    final response =
        await feedCommentServices.createComment(widget.postId, body);
    if (response != null) {
      feedComments.add(response);
      feedComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      commentController.text = "";
    }
    setState(() {
      isPosting = false;
    });
  }

  void fetchComments() async {
    try {
      final comments = await feedCommentServices.getPostComments(widget.postId);
      setState(() {
        feedComments = comments;
        feedComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
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
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 5,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: constraints.maxWidth,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 14,
                              ),
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey.withOpacity(0.7),
                            ),
                            const SizedBox(height: 10),
                            isLoading
                                ? const Expanded(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                            feedComments.length, (index) {
                                          return Container(
                                            padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 20,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircularShimmerImage(
                                                  size: 40,
                                                  imageUrl: feedComments[index]
                                                      .author
                                                      .imageUrl,
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "@${feedComments[index].author.username}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 7),
                                                        Text(
                                                          formatDate(
                                                              DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                feedComments[
                                                                        index]
                                                                    .createdAt,
                                                              ),
                                                              [
                                                                hh,
                                                                ':',
                                                                nn,
                                                                ' ',
                                                                am
                                                              ]),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      feedComments[index].text,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const Row(
                                                      children: [
                                                        InkWell(
                                                          child: Text(
                                                            "Reply",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircularShimmerImage(
                            size: 35,
                            imageUrl: widget.user.imageUrl,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: TextFormField(
                              controller: commentController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Message",
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
                                          onPressed:
                                              isPosting ? () {} : postComment,
                                          icon: const Icon(
                                            Icons.arrow_upward,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
