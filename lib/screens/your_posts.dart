import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/post_card.dart';

class YourPosts extends StatefulWidget {
  final String user;

  const YourPosts({super.key, required this.user});

  @override
  State<YourPosts> createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> {
  final FeedService feedService = FeedService();
  final ScrollController _scrollController = ScrollController();
  final UserController userController = Get.put(UserController());
  List<Post> postList = [];
  bool hasMorePosts = false;
  int _currentPage = 1;
  Key columnKey = const Key("main_column");
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(morePosts);
    init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> morePosts() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (hasMorePosts) {
      _currentPage++;
      final morePostsResponse = await feedService.getUserFeed(
        page: _currentPage,
        user: widget.user,
      );
      print(morePostsResponse!.totalPages);
      setState(() {
        hasMorePosts =
            morePostsResponse.totalPages > morePostsResponse.currentPage;
        postList.addAll(morePostsResponse.posts);
        columnKey = Key(Random().toString());
      });
    } else {
      print("Else Load More Posts");
    }
  }

  void init() async {
    final feedResponse = await feedService.getUserFeed(
      page: 1,
      user: widget.user,
    );
    log(feedResponse!.posts.length);
    postList.addAll(feedResponse.posts);
    columnKey = Key(Random().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Your Posts",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
            //   child: SizedBox(
            //     height: 45,
            //     child: TextFormField(
            //       decoration: const InputDecoration(
            //         hintText: "Search...",
            //         prefixIcon: Icon(
            //           Icons.search_rounded,
            //           size: 20,
            //         ),
            //         contentPadding: EdgeInsets.symmetric(
            //           vertical: 0,
            //           horizontal: 20,
            //         ),
            //         fillColor: Color.fromRGBO(239, 239, 240, 1),
            //         filled: true,
            //         border: OutlineInputBorder(
            //           borderSide: BorderSide.none,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    key: columnKey,
                    children: [
                      ...postList.map((e) {
                        return PostCard(
                          post: e,
                          user: userController.userData!,
                          index: 1,
                        );
                      })
                    ],
                  )),
            ))
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
