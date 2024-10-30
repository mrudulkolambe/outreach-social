import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/feed_comments.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/comment_feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/comment.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/bottomsheet/forum_post_comment.dart';
import 'package:outreach/widgets/forum/forum_card.dart';

class ForumPostDetails extends StatefulWidget {
  final ForumPost forumPost;
  final Forum forum;

  const ForumPostDetails(
      {super.key, required this.forumPost, required this.forum});

  @override
  State<ForumPostDetails> createState() => _ForumPostDetailsState();
}

class _ForumPostDetailsState extends State<ForumPostDetails> {
  final FeedCommentController feedCommentController =
      Get.put(FeedCommentController());
  final ScrollController _scrollController = ScrollController();
  bool hasMoreComments = false;
  List<ForumFeedComment> forumComments = [];
  CommentFeedServices commentFeedServices = CommentFeedServices();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    initializeState();
    _scrollController.addListener(moreComments);
  }

  void _openCommentBottomsheet() {
    showModalBottomSheet(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return ForumCommentBottomSheet(
          postId: widget.forumPost.id,
        );
      },
    );
  }

  Future<void> moreComments() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMoreComments();
    }
  }

  Future<void> _loadMoreComments() async {
    if (hasMoreComments) {
      _currentPage++;
      final moreCommentsResponse =
          await commentFeedServices.getForumPostsComments(
              page: _currentPage, postID: widget.forumPost.id);
      setState(() {
        hasMoreComments =
            moreCommentsResponse!.totalPages > moreCommentsResponse.currentPage;
        feedCommentController.addAllForumComment(moreCommentsResponse.comments);
        forumComments.addAll(moreCommentsResponse.comments);
      });
    } else {
      print("Else Load More Posts");
    }
  }

  Future<void> initializeState() async {
    try {
      final listCommentsResponse = await commentFeedServices
          .getForumPostsComments(page: 1, postID: widget.forumPost.id);
      setState(() {
        _currentPage = 1;
        feedCommentController.initForumComment(listCommentsResponse!.comments);
        forumComments.addAll(listCommentsResponse.comments);
        hasMoreComments =
            listCommentsResponse.totalPages > listCommentsResponse.currentPage;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 30,
        elevation: 5,
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                widget.forum.image,
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.forum.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${widget.forum.joined.length} members",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ForumCard(
              forum: widget.forum,
              forumPost: widget.forumPost,
              type: "details",
            ),
            GetBuilder<FeedCommentController>(
                init: FeedCommentController(),
                builder: (controller) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: horizontal_p),
                    child: Column(
                      children: [
                        ...controller.forumFeedComments.map((forumComment) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      widget.forumPost.user.imageUrl == null
                                          ? Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: accent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        40 / 2),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  widget.forum.public
                                                      ? widget
                                                          .forumPost.user.name!
                                                          .substring(0, 1)
                                                      : "A",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : CircularShimmerImage(
                                              imageUrl:
                                                  widget.forum.userId.imageUrl!,
                                              size: 40,
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.forum.public
                                                ? widget.forum.userId.name!
                                                : "Anonymous",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            widget.forum.public
                                                ? "@${widget.forum.userId.username}"
                                                : "@anonymous",
                                            style: const TextStyle(
                                              color: grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  widget.forumPost.liked
                                      ? SvgPicture.asset(
                                          "assets/icons/like-filled.svg",
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/like.svg",
                                        ),
                                ],
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width - 85 - 40,
                                child: Text(
                                  forumComment.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => _openCommentBottomsheet(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2, color: grey.withOpacity(0.2)),
              bottom: BorderSide(width: 2, color: grey.withOpacity(0.2)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_rounded),
                  ),
                  const Text(
                    'Post comment',
                  )
                ],
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: accent,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
