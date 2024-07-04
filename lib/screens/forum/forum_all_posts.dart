import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/forum/forum_card.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/post_card.dart';

class ForumAllPosts extends StatefulWidget {
  final Forum forum;

  const ForumAllPosts({super.key, required this.forum});

  @override
  State<ForumAllPosts> createState() => _ForumAllPostsState();
}

class _ForumAllPostsState extends State<ForumAllPosts> {
  List<ForumPost> forumPosts = [];

  @override
  void initState() {
    // TODO: implement initState
    initializeState();
    super.initState();
  }

  void initializeState() async {
    final forumPostsFetched =
        await ForumServices().getForumPosts(widget.forum.id);
    setState(() {
      forumPosts = forumPostsFetched ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 30,
        elevation: 5,
        surfaceTintColor: Colors.transparent,
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
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${widget.forum.joined.length} members",
                  style: TextStyle(
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...forumPosts.map((forumPost) {
                      return ForumCard(
                          forum: widget.forum, forumPost: forumPost);
                    }).toList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontal_p,
              ),
              child: Container(
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
                          icon: Icon(Icons.add_rounded),
                        ),
                        Text(
                          'Post',
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
                        child: Center(
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
            )
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
