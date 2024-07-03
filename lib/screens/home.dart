import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/upload.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/platform_constraints/media_preview_mobile.dart';
import 'package:outreach/widgets/post_card.dart';
import 'package:outreach/widgets/story_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:outreach/screens/profile.dart';
import '../platform_constraints/post_web/upload.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MediaType { image, video }

enum SavingState { no, uploading, uploaded }

class MediaItem {
  final File file;
  final MediaType type;

  MediaItem({required this.file, required this.type});
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool private = false;
  List<Post> postsList = [];

  SavingState _saving = SavingState.no;

  final List<File> _mediaFiles = [];
  final List<UploadTask> _uploadTasks = [];
  final List<VideoPlayerController> _videoControllers = [];
  FeedService feedService = FeedService();

  TextEditingController descriptionController = TextEditingController();
  UserController userController = Get.put(UserController());
  PostController postController = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();

  Future<List<Map<String, String>>> _uploadMedia() async {
    setState(() {
      _saving = SavingState.uploading;
    });

    List<Map<String, String>> downloadUrls = [];
    final uploadData =
        await UploadServices().uploadMultipleFiles(_mediaFiles, "posts");
    List<Map<String, String>> urls = [];
    urls = uploadData!.media.map((item) => item.toJson()).toList();
    downloadUrls.addAll(urls);
    setState(() {
      _saving = SavingState.uploaded;
      _tags = [];
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _saving = SavingState.no;
      });
    });

    return downloadUrls;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int _currentPage = 1;
  bool _isLoadingMore = false;

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
    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    final morePosts = await feedService.getFeed(page: _currentPage);
    setState(() {
      postsList.addAll(morePosts);
      postController.addAllPosts(morePosts);
      _isLoadingMore = false;
    });
  }

  Future<void> initializeState() async {
    final listPosts = await feedService.getFeed(page: 1);
    setState(() {
      _currentPage = 1;
      postsList = listPosts;
      postController.initAddPosts(listPosts);
    });
  }

  List<String> _tags = [];
  final RegExp _tagRegExp = RegExp(r'\B#\w+');

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void _openBottomSheet() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void extractTags(String text) {
            final matches = _tagRegExp.allMatches(text);
            setState(() {
              _tags.clear();
              for (Match match in matches) {
                _tags.add(match.group(0)!);
              }
            });
          }

          void createPost() async {
            List<Map<String, String>> urls = [];
            if (_mediaFiles.isNotEmpty) {
              urls = await _uploadMedia();
            }
            final body = {
              "public": !private,
              "content": descriptionController.text,
              "media": urls,
              "tags": _tags
            };
            print(body);
            feedService.createFeed(body);
          }

          Future<void> pickMedia() async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
              allowMultiple: true,
            );

            if (result != null) {
              setState(() {
                List<File> newFiles = result.paths.map((path) {
                  return File(path!);
                }).toList();
                _mediaFiles.addAll(newFiles);
              });
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: const Text(
                "Create Post",
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (descriptionController.text.isNotEmpty ||
                        _mediaFiles.isNotEmpty) {
                      Get.back();
                      createPost();
                    } else {
                      ToastManager.showToast(
                        "No media selected",
                        context,
                      );
                    }
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: accent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        userController.userData!.imageUrl == null
                            ? Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(70 / 2),
                                ),
                                child: Center(
                                  child: Text(
                                    userController.userData!.name!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  userController.userData!.imageUrl!,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userController.userData!.name!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      private = false;
                                    });
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: private != true
                                          ? accent
                                          : accent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Public",
                                        style: TextStyle(
                                          color: private != true
                                              ? Colors.white
                                              : accent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      private = true;
                                    });
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: private == true
                                          ? accent
                                          : accent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Private",
                                        style: TextStyle(
                                          color: private == true
                                              ? Colors.white
                                              : accent,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: extractTags,
                      controller: descriptionController,
                      maxLength: 500,
                      minLines: null,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        enabledBorder: InputBorder.none,
                        counterText: '',
                        hintStyle: TextStyle(color: accent, fontSize: 16),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width - 2 * horizontal_p,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          if (!kIsWeb)
                            for (int i = 0; i < _mediaFiles.length; i++)
                              Stack(
                                children: [
                                  MediaPreviewMobile(
                                    mediaFile: _mediaFiles[i],
                                    fileName:
                                        _mediaFiles[i].path.split("/").last,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _mediaFiles.removeAt(i);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: pickMedia,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.upload_file,
                              size: 18,
                              color: accent,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _mediaFiles.isNotEmpty
                                  ? "Add more Photos/Videos"
                                  : "Upload Photos/Videos",
                              style: const TextStyle(
                                color: accent,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
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
                                    style: TextStyle(color: Colors.white),
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
            onPressed: () {},
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
            onPressed: () {},
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
                                onTap: () => _openBottomSheet(),
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
                SizedBox(
                  height: _saving != SavingState.no ? 20 : 10,
                ),
                if (_saving == SavingState.uploading)
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
                if (_saving == SavingState.uploaded)
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
                GetBuilder<PostController>(
                  init: PostController(),
                  builder: (postController) {
                    return Column(
                      children: [
                        ...postController.posts.reversed
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) =>
                                PostCard(post: entry.value, index: entry.key))
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        homeClick: () {
          print("object");
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        openBottomSheet: _openBottomSheet,
      ),
    );
  }
}
