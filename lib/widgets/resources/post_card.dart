// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/resource.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/resource_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/resources/add_post.dart';
import 'package:outreach/utils/report_reasons.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/bottomsheet/post_comment.dart';
import 'package:outreach/widgets/popup/delete_popup.dart';
import 'package:outreach/widgets/popup/report_popup.dart';
import 'package:outreach/widgets/posts/mediacard.dart';

class PostCard extends StatefulWidget {
  final ResourcePost post;
  final int index;
  final UserData user;

  const PostCard(
      {super.key, required this.post, required this.index, required this.user,});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  int likedCount = 0;
  bool liked = false;
  static const int _maxLines = 2;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    likedCount = widget.post.likesCount;
    liked = widget.post.liked;
  }

  void _openCommentBottomsheet() {
    showModalBottomSheet(
      useSafeArea: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      isScrollControlled: true,
      showDragHandle: false,
      builder: (context) {
        return CommentBottomSheet(
          postId: widget.post.id,
          user: widget.user,
          isPrivate: false,
        );
      },
    );
  }

  String _getTruncatedText(String text) {
    final words = text.split(' ');
    String truncatedText = '';
    for (var word in words) {
      if (truncatedText.split(' ').length < _maxLines * 10) {
        truncatedText += '$word ';
      } else {
        truncatedText = truncatedText.trim();
        break;
      }
    }
    return truncatedText;
  }

  bool _isTextLong(String text) {
    final words = text.split(' ');
    return words.length > _maxLines * 10;
  }

  void _openReportModal() {
    showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return ReportPopup(
            reasons: ReportReasons.postReasons,
            type: "resource",
            postId: widget.post.id,
            userID: widget.user.id);
      },
    );
    // showDialog(context: context, builder: (context) => ReportPopup());
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmPopup(
          id: widget.post.id,
          type: "resource",
        );
      },
    );
  }

  final ResourceServices resourceServices = ResourceServices();

  @override
  Widget build(BuildContext context) {
    final isTextLong = _isTextLong(widget.post.content);
    final contentText = _isExpanded || !isTextLong
        ? widget.post.content
        : _getTruncatedText(widget.post.content);

    // Define a regular expression to match #tags
    final RegExp tagRegExp = RegExp(r'\B#\w+');
    final matches = tagRegExp.allMatches(contentText);

    // Split content text into parts: regular text and #tags
    final List<TextSpan> textSpans = [];
    int lastMatchEnd = 0;
    for (var match in matches) {
      if (match.start > lastMatchEnd) {
        // Add regular text before the tag
        textSpans.add(TextSpan(
          text: contentText.substring(lastMatchEnd, match.start),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ));
      }
      // Add the #tag with different style
      textSpans.add(TextSpan(
        text: contentText.substring(match.start, match.end),
        style: const TextStyle(fontSize: 16, color: accent),
      ));
      lastMatchEnd = match.end;
    }
    // Add any remaining regular text after the last #tag
    if (lastMatchEnd < contentText.length) {
      textSpans.add(TextSpan(
        text: contentText.substring(lastMatchEnd),
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontal_p,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 2, color: lightgrey)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              widget.post.user.imageUrl == null
                  ? Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(40 / 2),
                      ),
                      child: Center(
                        child: Text(
                          widget.post.user.name.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : CircularShimmerImage(
                      imageUrl: widget.post.user.imageUrl!,
                      size: 40,
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.user.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "@${widget.post.user.username}",
                      style: const TextStyle(
                        color: grey,
                      ),
                    )
                  ],
                ),
              ),
              PopupMenuButton<int>(
                padding: const EdgeInsets.all(0),
                onSelected: (item) {
                  if (item == 1) {
                    Get.to(() => ResourceAddPost(
                          resourcePost: widget.post,
                        ));
                  } else if (item == 2) {
                    _confirmDelete();
                  } else if (item == 3) {
                    _openReportModal();
                  }
                },
                itemBuilder: (context) => [
                  if (widget.user.id == widget.post.user.id)
                    const PopupMenuItem(
                      value: 1,
                      child: Center(
                        child: SizedBox(
                            width: 120,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  if (widget.user.id == widget.post.user.id)
                    const PopupMenuItem(
                      value: 2,
                      child: Center(
                        child: SizedBox(
                            width: 120,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  if (widget.user.id != widget.post.user.id)
                    const PopupMenuItem(
                      value: 3,
                      child: Center(
                        child: SizedBox(
                            width: 120,
                            child: Text(
                              'Report',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          if (widget.post.media.isNotEmpty)
            const SizedBox(
              height: 10,
            ),
          if (widget.post.media.isNotEmpty)
            InkWell(
              onDoubleTap: () {
                if (!widget.post.liked) {
                  // FeedService().likeOnPost(widget.);
                  setState(() {
                    showHeart = true;
                  });
                  Timer(const Duration(milliseconds: 400), () {
                    setState(() {
                      showHeart = false;
                    });
                  });
                }
              },
              child: MediaCarousel(mediaPosts: widget.post.media),
            ),
          const SizedBox(
            height: 10,
          ),
          if (widget.post.title != null)
            Row(
              children: [
                Text(
                  widget.post.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.mulish(),
                    children: textSpans,
                  ),
                ),
              ),
            ],
          ),
          if (_isExpanded && isTextLong)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = false;
                });
              },
              child: const Row(
                children: [
                  Text(
                    "Show less",
                    style: TextStyle(
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          if (!_isExpanded && isTextLong)
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: const Text(
                    "Read more",
                    style: TextStyle(
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (widget.post.liked) {
                      likedCount = widget.post.likesCount - 1;
                      liked = false;
                    } else {
                      likedCount = widget.post.likesCount + 1;
                      liked = true;
                    }
                  });
                  resourceServices.likeOnPost(widget.post);
                },
                child: Row(
                  children: [
                    liked
                        ? SvgPicture.asset(
                            "assets/icons/like-filled.svg",
                          )
                        : SvgPicture.asset(
                            "assets/icons/like.svg",
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(likedCount.toString())
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: _openCommentBottomsheet,
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/comment.svg"),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.post.commentCount.toString())
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            children: [
              Text("View all comments"),
            ],
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
