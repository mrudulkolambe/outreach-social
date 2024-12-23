import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/utils/report_reasons.dart';
import 'package:outreach/widgets/bottomsheet/post_comment.dart';
import 'package:outreach/widgets/circular_image.dart';
import 'package:outreach/widgets/popup/report_popup.dart';
import 'package:outreach/widgets/posts/mediacard.dart';
import 'package:outreach/widgets/posts/profile_video.dart';

class ProfilePosts extends StatefulWidget {
  final Post post;
  final UserData user;

  const ProfilePosts({super.key, required this.post, required this.user});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  final FeedService feedService = FeedService();
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
        );
      },
    );
  }

  void _openReportModal() {
    showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return ReportPopup(
          reasons: ReportReasons.postReasons,
          type: "post",
          postId: widget.post.id,
          userID: widget.user.id,
        );
      },
    );
    // showDialog(context: context, builder: (context) => ReportPopup());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Column(
        children: [
          Row(
            children: [
              widget.post.user.imageUrl == null
                  ? Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(45 / 2),
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
                  : CircularImage(
                      size: 45,
                      path: widget.post.user.imageUrl!,
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.public
                                    ? widget.post.user.name
                                    : "Anonymous",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "2 months ago",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "posted on Forum.",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<int>(
                      padding: const EdgeInsets.all(0),
                      onSelected: (item) {
                        if (item == 1) {
                          print('Edit tapped');
                        } else if (item == 2) {
                          print('Delete tapped');
                        } else if (item == 3) {
                          _openReportModal();
                        }
                      },
                      itemBuilder: (context) => [
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
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.post.media.isNotEmpty)
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  height: 80,
                  child: MediaCarousel(mediaPosts: widget.post.media),
                ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  widget.post.content,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  FeedService().likeOnPost(widget.post);
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
                    Text(widget.post.commentCount.toString())
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuEntry<T> {
  final String text;
  final VoidCallback onTap;

  const CustomPopupMenuItem({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  double get height => 48.0;

  @override
  bool represents(T? value) => false;

  @override
  CustomPopupMenuItemState createState() => CustomPopupMenuItemState();
}

class CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        Navigator.pop(context);
      },
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
