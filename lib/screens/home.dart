import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/story.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/api/services/story_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/controller/saving.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/screens/search.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/post_card.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:outreach/screens/profile.dart';
import 'package:advstory/advstory.dart';

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
  StoryServices storyServices = StoryServices();
  StoryResponse storyResponse = StoryResponse(own: [], user: []);
  List<UserStoryGroup> groupedStories = [];
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
    if (hasMorePost) {
      _currentPage++;
      final morePostsResponse = await feedService.getFeed(page: _currentPage);
      setState(() {
        hasMorePost =
            morePostsResponse!.totalPages > morePostsResponse.currentPage;
        postsList.addAll(morePostsResponse.posts);
        postController.addAllPosts(morePostsResponse.posts);
      });
    } else {
      print("Else Load More Posts");
    }
  }

  Future<void> initializeState() async {
    try {
      final listPostsResponse = await feedService.getFeed(page: 1);
      final storyList = await storyServices.getUserStories();
      setState(() {
        _currentPage = 1;
        storyResponse = storyList!.response;
        groupedStories = [];
        if (storyResponse.own.isNotEmpty) {
          groupedStories.add(UserStoryGroup(
              username: storyResponse.own.first.userId.username,
              stories: storyResponse.own));
        } else {
          groupedStories.add(UserStoryGroup(
              username: userController.userData!.username!, stories: []));
        }
        groupedStories.addAll(handleStories(storyList.response.user));
        print(groupedStories[0].stories.length);
        postsList = listPostsResponse!.posts;
        postController.initAddPosts(listPostsResponse.posts);
        hasMorePost =
            listPostsResponse.totalPages > listPostsResponse.currentPage;
      });
    } catch (e) {
      print(e);
    }
  }

  List<UserStoryGroup> handleStories(List<UserStory> stories) {
    final Map<String, UserStoryGroup> groupedMap = {};

    for (var story in stories) {
      final username = story.userId.username;
      if (!groupedMap.containsKey(username)) {
        groupedMap[username] = UserStoryGroup(
            username: username, stories: [], imageUrl: story.userId.imageUrl!);
      }
      groupedMap[username]!.stories.add(story);
    }
    return groupedMap.values.toList();
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
          // IconButton(
          //   onPressed: () => Get.to(() => ZIMKitDemoHomePage()),
          //   icon: SvgPicture.asset(
          //     "assets/icons/message.svg",
          //   ),
          // ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 125,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        key: Key("GROUPED_STORIES_${groupedStories.length}"),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 125,
                        child: AdvStory(
                          buildStoryOnTrayScroll: true,
                          preloadStory: true,
                          preloadContent: true,
                          style: const AdvStoryStyle(),
                          storyCount: groupedStories.length,
                          trayBuilder: (storyIndex) {
                            print("storyIndex $storyIndex");
                            return storyIndex == 0
                                ? InkWell(
                                    onTap: () {
                                      if (storyResponse.own.isEmpty) {
                                        Get.offAll(() => const MainStack(
                                              page: 5,
                                            ));
                                      } else {
                                        Get.to(
                                          () => SelfStoryView(
                                            userStories: storyResponse.own,
                                          ),
                                        );
                                      }
                                    },
                                    onLongPress: () {
                                      Get.offAll(() => const MainStack(
                                            page: 5,
                                          ));
                                    },
                                    child: Container(
                                      height: 103,
                                      width: 88,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            211, 221, 250, 0.3),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(25),
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
                                          const Text(
                                            "Add your\nstory",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : AdvStoryTray(
                                    username: SizedBox(
                                      width: 88,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        storyIndex == 0
                                            ? "Your story"
                                            : groupedStories[storyIndex].username,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    borderRadius: 20,
                                    size: const Size(88, 103),
                                    shape: BoxShape.rectangle,
                                    url: groupedStories[storyIndex].imageUrl !=
                                                null ||
                                            groupedStories[storyIndex]
                                                    .imageUrl !=
                                                ""
                                        ? groupedStories[storyIndex].imageUrl!
                                        : "assets/icons/user-placeholder.png",
                                  );
                          },
                          storyBuilder: (storyIndex) {
                            return Story(
                              header: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: groupedStories[storyIndex]
                                                      .imageUrl ==
                                                  null ||
                                              groupedStories[storyIndex]
                                                      .imageUrl ==
                                                  ""
                                          ? Image.asset(
                                              "assets/icons/user-placeholder.png")
                                          : Image.network(
                                              fit: BoxFit.cover,
                                              groupedStories[storyIndex]
                                                  .imageUrl!,
                                              height: 50,
                                              width: 50,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "@${groupedStories[storyIndex].username}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                              contentCount:
                                  groupedStories[storyIndex].stories.length,
                              contentBuilder: (contentIndex) {
                                return groupedStories[storyIndex]
                                            .stories[contentIndex]
                                            .media
                                            .type ==
                                        "video"
                                    ? VideoContent(
                                        timeout: const Duration(seconds: 5),
                                        url: groupedStories[storyIndex]
                                            .stories[contentIndex]
                                            .media
                                            .url,
                                      )
                                    : ImageContent(
                                        footer: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            groupedStories[storyIndex]
                                                .stories[contentIndex]
                                                .content,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        url: groupedStories[storyIndex]
                                            .stories[contentIndex]
                                            .media
                                            .url,
                                      );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
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

class SelfStoryView extends StatefulWidget {
  final List<UserStory> userStories;
  const SelfStoryView({super.key, required this.userStories});

  @override
  State<SelfStoryView> createState() => _SelfStoryViewState();
}

class _SelfStoryViewState extends State<SelfStoryView> {
  final controller = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StoryView(
              onComplete: () {
                Get.back();
              },
              storyItems: List.generate(
                widget.userStories.length,
                (index) {
                  if (widget.userStories[index].media.type == "video") {
                    return StoryItem.pageVideo(
                        widget.userStories[index].media.url,
                        controller: controller,
                        imageFit: BoxFit.contain,
                        caption: Text(widget.userStories[index].content));
                  } else if (widget.userStories[index].media.type == "image") {
                    return StoryItem.pageImage(
                        url: widget.userStories[index].media.url,
                        imageFit: BoxFit.contain,
                        controller: controller,
                        caption: Text(widget.userStories[index].content));
                  }
                  return null;
                },
              ),
              controller: controller)),
    );
  }
}
