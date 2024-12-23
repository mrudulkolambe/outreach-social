// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/forum_post_details.dart';
import 'package:outreach/utils/report_reasons.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/popup/delete_popup.dart';
import 'package:outreach/widgets/popup/report_popup.dart';
import 'package:outreach/widgets/posts/mediacard.dart';

class ForumCard extends StatefulWidget {
  final Forum forum;
  final ForumPost forumPost;
  final String type;
  final String user;

  const ForumCard({
    super.key,
    required this.forum,
    required this.forumPost,
    required this.type,
    required this.user,
  });

  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  final bool _isExpanded = false;
  static const int _maxLines = 2;

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
            type: "forum",
            postId: widget.forumPost.id,
            userID: widget.user);
      },
    );
    // showDialog(context: context, builder: (context) => ReportPopup());
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmPopup(
          id: widget.forumPost.id,
          type: "forum",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTextLong = _isTextLong(widget.forum.description);
    final contentText = _isExpanded || !isTextLong
        ? widget.forum.description
        : _getTruncatedText(widget.forum.description);
    final RegExp tagRegExp = RegExp(r'\B#\w+');
    final matches = tagRegExp.allMatches(contentText);
    final List<TextSpan> textSpans = [];
    int lastMatchEnd = 0;
    for (var match in matches) {
      if (match.start > lastMatchEnd) {
        textSpans.add(TextSpan(
          text: contentText.substring(lastMatchEnd, match.start),
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ));
      }
      textSpans.add(TextSpan(
        text: contentText.substring(match.start, match.end),
        style: const TextStyle(fontSize: 16, color: accent),
      ));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < contentText.length) {
      textSpans.add(TextSpan(
        text: contentText.substring(lastMatchEnd),
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontal_p,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: widget.type != "details" ? 2 : 0,
            color: widget.type != "details" ? lightgrey : Colors.transparent,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              widget.forum.public
                  ? widget.forum.userId.imageUrl == null
                      ? Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(40 / 2),
                          ),
                          child: Center(
                            child: Text(
                              widget.forum.public
                                  ? widget.forum.userId.name!.substring(0, 1)
                                  : "A",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : CircularShimmerImage(
                          imageUrl: widget.forum.userId.imageUrl!,
                          size: 40,
                        )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40 / 2),
                        color: lightgrey,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/user-placeholder.svg",
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    )
                  ],
                ),
              ),
              if (widget.type == "primary")
                PopupMenuButton<int>(
                  padding: const EdgeInsets.all(0),
                  onSelected: (item) {
                    if (item == 1) {
                      print('Edit tapped');
                    } else if (item == 2) {
                      _confirmDelete();
                    } else if (item == 3) {
                      _openReportModal();
                    }
                  },
                  itemBuilder: (context) => [
                    if (widget.user == widget.forumPost.user.id)
                      const PopupMenuItem(
                        value: 1,
                        child: Center(
                          child: SizedBox(
                              width: 150,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    if (widget.user == widget.forumPost.user.id)
                      const PopupMenuItem(
                        value: 2,
                        child: Center(
                          child: SizedBox(
                              width: 150,
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    const PopupMenuItem(
                      value: 3,
                      child: Center(
                        child: SizedBox(
                            width: 150,
                            child: Text(
                              'Report',
                              style: TextStyle(
                                fontSize: 16,
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
          if (widget.type == "details")
            SizedBox(
              width: widget.type == "details"
                  ? MediaQuery.of(context).size.width - 85 - 40
                  : MediaQuery.of(context).size.width - 2 * horizontal_p,
              child: Column(
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.forumPost.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (widget.forumPost.media.isNotEmpty)
            const SizedBox(
              height: 10,
            ),
          if (widget.forumPost.media.isNotEmpty)
            InkWell(
              onTap: widget.type == "details"
                  ? () {}
                  : () => Get.to(
                        () => ForumPostDetails(
                          forumPost: widget.forumPost,
                          forum: widget.forum,
                        ),
                      ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: widget.type == "details"
                        ? MediaQuery.of(context).size.width - 85
                        : MediaQuery.of(context).size.width - 2 * horizontal_p,
                    child: MediaCarousel(
                      mediaPosts: widget.forumPost.media,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.forumPost.content.isNotEmpty)
            const SizedBox(
              height: 10,
            ),
          if (widget.type != "details")
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.forumPost.content,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          if (widget.type != "details")
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ForumServices().likeOnPost(widget.forumPost);
                  },
                  child: Row(
                    children: [
                      widget.forumPost.liked
                          ? SvgPicture.asset(
                              "assets/icons/like-filled.svg",
                            )
                          : SvgPicture.asset(
                              "assets/icons/like.svg",
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(widget.forumPost.likesCount.toString())
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: widget.type == "details"
                          ? () {}
                          : () => Get.to(
                                () => ForumPostDetails(
                                  forumPost: widget.forumPost,
                                  forum: widget.forum,
                                ),
                              ),
                      child: const Text(
                        "Reply",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
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
