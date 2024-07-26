// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/comment_feed_services.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/posts/mediacard.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final int index;
  final UserData user;

  const PostCard(
      {super.key, required this.post, required this.index, required this.user});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  static const int _maxLines = 2;
  bool showHeart = false;
  final TextEditingController commentController = TextEditingController();
  final feedCommentServices = CommentFeedServices();

  void postComment() async {
    final body = {
      'text': commentController.text,
      'parentID': null
    };
    final response = await feedCommentServices.createComment(widget.post.id, body);
    if(response == 200){
      commentController.text = "";
    }
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
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
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
                  const SizedBox(
                    height: 10,
                  ),
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
                      width: MediaQuery.of(context).size.width,
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
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(20, (index) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                      left: horizontal_p,
                                      right: horizontal_p,
                                      top: horizontal_p,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircularShimmerImage(
                                          size: 40,
                                          imageUrl: widget.user.imageUrl,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "@chinedukoro",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  "10h",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Thanks for sharing",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Reply",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
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
                      horizontal: horizontal_p,
                    ),
                    width: MediaQuery.of(context).size.width,
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
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: commentController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Message",
                              suffixIcon: Container(
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: IconButton(
                                  onPressed: postComment,
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
              widget.post.public
                  ? widget.post.user.imageUrl == null
                      ? Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(40 / 2),
                          ),
                          child: Center(
                            child: Text(
                              widget.post.public
                                  ? widget.post.user.name.substring(0, 1)
                                  : "A",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : CircularShimmerImage(
                          imageUrl: widget.post.user.imageUrl!,
                          size: 40,
                        )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40 / 2),
                          color: lightgrey),
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
                      widget.post.public ? widget.post.user.name : "Anonymous",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.post.public
                          ? "@${widget.post.user.username} ${widget.index + 1}"
                          : "@anonymous ${widget.index + 1}",
                      style: const TextStyle(
                        color: grey,
                      ),
                    )
                  ],
                ),
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
                  FeedService().likeOnPost(widget.post.id);
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
                  FeedService().likeOnPost(widget.post.id);
                },
                child: Row(
                  children: [
                    widget.post.liked
                        ? SvgPicture.asset(
                            "assets/icons/like-filled.svg",
                          )
                        : SvgPicture.asset(
                            "assets/icons/like.svg",
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.post.likesCount.toString())
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
                    const Text("50")
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
