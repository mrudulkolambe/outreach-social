import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:outreach/api/models/feed_comments.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/comment_feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
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
  String? parentID;
  String? viewNestedComments;
  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  void postComment() async {
    setState(() {
      isPosting = true;
    });
    final body = {
      'text': commentController.text,
      'parentID': parentID == "" ? null : parentID
    };
    final response =
        await feedCommentServices.createComment(widget.postId, body);
    if (response != null) {
      feedComments.add(response);
      feedComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      commentController.text = "";
    }
    setState(() {
      parentID = "";
      isPosting = false;
    });
  }

  void fetchComments() async {
    try {
      final comments = await feedCommentServices.getPostComments(widget.postId);
      if (mounted) {
        setState(() {
          feedComments = comments;
          feedComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  FeedComment? handleReplyStories(
      String? parentID, List<FeedComment> feedComments) {
    if (parentID == null || parentID == "") {
      return null;
    } else {
      print(feedComments.first.id);
      final data = feedComments.firstWhere((comment) {
        return comment.id == parentID;
      });
      return data;
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
                                            feedComments
                                                .where((comment) =>
                                                    comment.parentID == null)
                                                .length, (index) {
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
                                                  imageUrl: feedComments
                                                      .where((comment) =>
                                                          comment.parentID ==
                                                          null)
                                                      .toList()[index]
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
                                                          "@${feedComments.where((comment) => comment.parentID == null).toList()[index].author.username}",
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
                                                                feedComments
                                                                    .where((comment) =>
                                                                        comment
                                                                            .parentID ==
                                                                        null)
                                                                    .toList()[
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
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              82 -
                                                              20,
                                                      child: Text(
                                                        feedComments
                                                            .where((comment) =>
                                                                comment
                                                                    .parentID ==
                                                                null)
                                                            .toList()[index]
                                                            .text,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              parentID = feedComments
                                                                  .where((comment) =>
                                                                      comment
                                                                          .parentID ==
                                                                      null)
                                                                  .toList()[
                                                                      index]
                                                                  .id;
                                                            });
                                                          },
                                                          child: const Text(
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
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        if (feedComments
                                                            .where((comment) =>
                                                                comment
                                                                    .parentID ==
                                                                feedComments
                                                                    .where((comment) =>
                                                                        comment
                                                                            .parentID ==
                                                                        null)
                                                                    .toList()[
                                                                        index]
                                                                    .id)
                                                            .isNotEmpty)
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                viewNestedComments = viewNestedComments ==
                                                                        null
                                                                    ? feedComments
                                                                        .where((comment) =>
                                                                            comment.parentID ==
                                                                            null)
                                                                        .toList()[
                                                                            index]
                                                                        .id
                                                                    : null;
                                                              });
                                                            },
                                                            child: const Text(
                                                              "View comments",
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
                                                    // TODO: START
                                                    if (viewNestedComments ==
                                                        feedComments
                                                            .where((comment) =>
                                                                comment
                                                                    .parentID ==
                                                                null)
                                                            .toList()[index]
                                                            .id)
                                                      Column(
                                                        children: List.generate(
                                                            feedComments
                                                                .where((comment) =>
                                                                    comment
                                                                        .parentID ==
                                                                    feedComments
                                                                        .where((comment) =>
                                                                            comment.parentID ==
                                                                            null)
                                                                        .toList()[
                                                                            index]
                                                                        .id)
                                                                .length,
                                                            (nestedIndex) {
                                                          return Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 20,
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CircularShimmerImage(
                                                                  size: 40,
                                                                  imageUrl: feedComments
                                                                      .where((comment) =>
                                                                          comment
                                                                              .parentID ==
                                                                          feedComments
                                                                              .where((comment) =>
                                                                                  comment.parentID ==
                                                                                  null)
                                                                              .toList()[
                                                                                  index]
                                                                              .id)
                                                                      .toList()[
                                                                          nestedIndex]
                                                                      .author
                                                                      .imageUrl,
                                                                ),
                                                                const SizedBox(
                                                                    width: 15),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "@${feedComments.where((comment) => comment.parentID == feedComments.where((comment) => comment.parentID == null).toList()[index].id).toList()[nestedIndex].author.username}",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                7),
                                                                        Text(
                                                                          formatDate(
                                                                              DateTime.fromMillisecondsSinceEpoch(
                                                                                feedComments.where((comment) => comment.parentID == feedComments.where((comment) => comment.parentID == null).toList()[index].id).toList()[nestedIndex].createdAt,
                                                                              ),
                                                                              [
                                                                                hh,
                                                                                ':',
                                                                                nn,
                                                                                ' ',
                                                                                am
                                                                              ]),
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            3),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          82 -
                                                                          20 -
                                                                          40 -
                                                                          15,
                                                                      child:
                                                                          Text(
                                                                        feedComments
                                                                            .where((comment) =>
                                                                                comment.parentID ==
                                                                                feedComments.where((comment) => comment.parentID == null).toList()[index].id)
                                                                            .toList()[nestedIndex]
                                                                            .text,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // TODO: Hidden nested reply functionality
                                                                    if (true ==
                                                                        false)
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                parentID = feedComments.where((comment) => comment.parentID == null).toList()[index].id;
                                                                              });
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "Reply",
                                                                              style: TextStyle(
                                                                                color: Colors.black54,
                                                                                fontWeight: FontWeight.w700,
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

                                                    // TODO: END
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
                    if (parentID != null && parentID != "" ||
                        handleReplyStories(parentID, feedComments) != null)
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: horizontal_p),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "@${handleReplyStories(parentID, feedComments) == null ? "" : handleReplyStories(parentID, feedComments)!.author.username}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    "${handleReplyStories(parentID, feedComments) == null ? "" : handleReplyStories(parentID, feedComments)!.text}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  parentID = null;
                                });
                              },
                              icon: const Icon(Icons.close),
                            )
                          ],
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
