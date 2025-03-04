// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/posts/mediacard.dart';

class ForumCard extends StatefulWidget {
  final Forum forum;
  final ForumPost forumPost;

  const ForumCard({
    super.key,
    required this.forum,
    required this.forumPost,
  });

  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  bool _isExpanded = false;
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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 2, color: lightgrey)),
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
            ],
          ),
          if(widget.forumPost.media.isNotEmpty) const SizedBox(
            height: 10,
          ),
          if(widget.forumPost.media.isNotEmpty) MediaCarousel(mediaPosts: widget.forumPost.media),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.mulish(
                      color: Colors.black
                    ),
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
              Row(
                children: [
                  SvgPicture.asset("assets/icons/like.svg"),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text("55k")
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Row(
                children: [
                  SvgPicture.asset("assets/icons/comment.svg"),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text("50")
                ],
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
