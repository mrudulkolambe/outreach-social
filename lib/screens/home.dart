import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/controller/saving.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/screens/chats/home.dart';
import 'package:outreach/screens/search.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/post_card.dart';
import 'package:outreach/widgets/story_card.dart';
import 'package:video_player/video_player.dart';
import 'package:outreach/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MediaType { image, video }

class MediaItem {
  final File file;
  final MediaType type;

  MediaItem({required this.file, required this.type});
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool private = false;
  List<Post> postsList = [];
  bool hasMorePost = false;

  final List<VideoPlayerController> _videoControllers = [];
  FeedService feedService = FeedService();
  TextEditingController descriptionController = TextEditingController();
  UserController userController = Get.put(UserController());
  PostController postController = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    print("initstate");
    initializeState();
    _scrollController.addListener(morePost);
  }

  Future<void> morePost() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    print("Load More Posts");
    if (hasMorePost) {
      _currentPage++;
      final morePostsResponse = await feedService.getFeed(page: _currentPage);
      setState(() {
        print(morePostsResponse!.totalFeeds);
        print(morePostsResponse.totalPages);
        print(morePostsResponse.currentPage);
        hasMorePost =
            morePostsResponse.totalPages > morePostsResponse.currentPage;
        print(morePostsResponse.totalPages > morePostsResponse.currentPage);
        postsList.addAll(morePostsResponse.posts);
        postController.addAllPosts(morePostsResponse.posts);
      });
    } else {
      print("Else Load More Posts");
    }
  }

  Future<void> initializeState() async {
    try {
      print("test");
      final listPostsResponse = await feedService.getFeed(page: 1);
      setState(() {
        _currentPage = 1;
        postsList = listPostsResponse!.posts;
        postController.initAddPosts(listPostsResponse.posts);
        hasMorePost =
            listPostsResponse.totalPages > listPostsResponse.currentPage;
        print(listPostsResponse.totalPages > listPostsResponse.currentPage);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 80,
        leadingWidth: 160,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GetBuilder<UserController>(
                  init: UserController(),
                  builder: (userController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Get.to(() => const MyProfile()),
                        child: userController.userData!.imageUrl == null
                            ? Container(
                                color: accent,
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: Text(
                                    userController.userData!.name!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : CircularShimmerImage(
                                imageUrl: userController.userData!.imageUrl!,
                                size: 30,
                              ),
                      ),
                    );
                  }),
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset(
                "assets/logo-text.svg",
                height: 14,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const SearchUsers()),
            icon: SvgPicture.asset(
              "assets/icons/search.svg",
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/notification.svg",
            ),
          ),
          IconButton(
            onPressed: () => Get.to(() => ZIMKitDemoHomePage()),
            icon: SvgPicture.asset(
              "assets/icons/message.svg",
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return initializeState();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 103,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    dragStartBehavior: DragStartBehavior.start,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 103,
                          width: 88,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(211, 221, 250, 0.3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                height: 25,
                                width: 25,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                child: const Text(
                                  "Add your\nstory",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const StoryCard(
                          url:
                              "https://media.licdn.com/dms/image/D4E03AQEYGYbPwLZcgw/profile-displayphoto-shrink_400_400/0/1709636815606?e=2147483647&v=beta&t=hzIqjHNZ2053KJxTC-5n9zAZAFJ_pWj2QpFpqR20YxY",
                        ),
                        const StoryCard(
                          url:
                              "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=1840&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                        const StoryCard(
                          url:
                              "https://images.unsplash.com/photo-1574406280735-351fc1a7c5e0?q=80&w=1951&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                        const StoryCard(
                          url:
                              "https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                        const SizedBox(
                          width: horizontal_p,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                GetBuilder(
                  init: SavingController(),
                  builder: (savingController) {
                    return Column(
                      children: [
                        SizedBox(
                          height: savingController.savingState != SavingState.no
                              ? 20
                              : 10,
                        ),
                        if (savingController.savingState ==
                            SavingState.uploading)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: horizontal_p,
                            ),
                            child: Column(
                              children: [
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Row(
                                  children: [
                                    Text("Your post is publishing... "),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (savingController.savingState ==
                            SavingState.uploaded)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: horizontal_p,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/published.svg"),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("Your post is published"),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
                GetBuilder<PostController>(
                  init: PostController(),
                  builder: (postController) {
                    return Column(
                      children: [
                        ...postController.posts.toList().asMap().entries.map(
                            (entry) => PostCard(
                                post: entry.value,
                                index: entry.key,
                                user: userController.userData!))
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Navbar(
      //   homeClick: () {
      //     _scrollController.animateTo(
      //       0,
      //       duration: const Duration(milliseconds: 500),
      //       curve: Curves.easeInOut,
      //     );
      //   },
      //   openBottomSheet: _openBottomSheet,
      // ),
    );
  }
}
