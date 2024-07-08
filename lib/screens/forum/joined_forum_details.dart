import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/forum.dart';
import 'package:outreach/screens/forum/forum_all_posts.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/navbar.dart';

class JoinedForumDetails extends StatefulWidget {
  final Forum forum;

  const JoinedForumDetails({super.key, required this.forum});

  @override
  State<JoinedForumDetails> createState() => _JoinedForumDetailsState();
}

class _JoinedForumDetailsState extends State<JoinedForumDetails> {
  void leaveForum() async {
    final result = await ForumServices().leaveForum(widget.forum.id);
    if (result == 200) {
      ToastManager.showToast("Success", context);
      Get.offAll(() => const ForumScreen());
    } else {
      ToastManager.showToast("Something went wrong!", context);
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
            SizedBox(
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontal_p,
            vertical: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Created by',
                    style: TextStyle(color: grey),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircularShimmerImage(
                    imageUrl: widget.forum.userId.imageUrl,
                    size: 24,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Text(
                    "@${widget.forum.userId.username}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    '${widget.forum.joined.length.toString()} members',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircularShimmerImage(
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                    size: 32,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircularShimmerImage(
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                    size: 32,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircularShimmerImage(
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                    size: 32,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircularShimmerImage(
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                    size: 32,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.forum.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () => Get.to(() => ForumAllPosts(
                      forum: widget.forum,
                    )),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Post",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.chevron_right,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: leaveForum,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Leave forum",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
