import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/circular_image.dart';
import 'package:outreach/widgets/posts/profile_video.dart';

class ProfilePosts extends StatefulWidget {
  final Post post;

  const ProfilePosts({super.key, required this.post});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: grey.withOpacity(0.2), width: 1))),
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
                      onSelected: (item) => print(item),
                      itemBuilder: (context) => [
                        CustomPopupMenuItem(
                          text: 'Edit',
                          onTap: () => print(1),
                        ),
                        CustomPopupMenuItem(
                          text: 'Delete',
                          onTap: () => print(1),
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
            if(widget.post.media.isNotEmpty)  widget.post.media.first.type == "mp4" ||
                      widget.post.media.first.type == "mov"
                  ? ProfileHLSVideoPlayer(
                      url: widget.post.media.first.url,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.post.media.first.url,
                        height: 75,
                        width: 115,
                        fit: BoxFit.cover,
                      ),
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
    );
  }
}
