import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/forum/forum_card.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/platform_constraints/media_preview_mobile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class ForumAllPosts extends StatefulWidget {
  final Forum forum;

  const ForumAllPosts({super.key, required this.forum});

  @override
  State<ForumAllPosts> createState() => _ForumAllPostsState();
}

class _ForumAllPostsState extends State<ForumAllPosts> {
  List<ForumPost> forumPosts = [];
  bool private = false;

  SavingState _saving = SavingState.no;

  final List<File> _mediaFiles = [];
  final List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
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

  TextEditingController descriptionController = TextEditingController();
  UserController userController = Get.put(UserController());
  final ScrollController _scrollController = ScrollController();

  Future<List<Map<String, String>>> _uploadMedia() async {
    setState(() {
      _saving = SavingState.uploading;
    });

    List<Map<String, String>> downloadUrls = [];
    final uploadData =
        await UploadServices().uploadMultipleFiles(_mediaFiles, "forum");
    List<Map<String, String>> urls = [];
    urls = uploadData!.media.map((item) => item.toJson()).toList();
    downloadUrls.addAll(urls);
    setState(() {
      _saving = SavingState.uploaded;
    });
    Future.delayed(const Duration(seconds: 2), () {
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
          void createPost() async {
            List<Map<String, String>> urls = [];
            if (_mediaFiles.isNotEmpty) {
              final uploadedData = await _uploadMedia();
              print(uploadedData);
              if (uploadedData == null) {
                ToastManager.showToast("Upload failed", context);
                return;
              }
              urls = uploadedData;
            }
            final body = {
              "public": !private,
              "content": descriptionController.text,
              "media": urls,
            };
            print(body);
            ForumServices().createForumPost(widget.forum.id, body);
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
              surfaceTintColor: appbarColor,
              backgroundColor: appbarColor,
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
                                    style: const TextStyle(color: Colors.white),
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
                          for (int i = 0; i < _mediaFiles.length; i++)
                            Stack(
                              children: [
                                MediaPreviewMobile(
                                  mediaFile: _mediaFiles[i],
                                  fileName: _mediaFiles[i].path.split("/").last,
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
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.forum.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${widget.forum.joined.length} members",
                  style: const TextStyle(
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
                    ...forumPosts.map((forumPost) {
                      return ForumCard(
                          forum: widget.forum, forumPost: forumPost);
                    }),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _openBottomSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
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
                          icon: const Icon(Icons.add_rounded),
                        ),
                        const Text(
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
                        child: const Center(
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
