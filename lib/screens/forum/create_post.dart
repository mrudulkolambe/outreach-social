import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/saving.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/interest.dart';
import 'package:outreach/screens/forum/forum_all_posts.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/platform_constraints/media_preview_mobile.dart';
import 'package:permission_handler/permission_handler.dart';

class AddForumPost extends StatefulWidget {
  final Forum forum;
  final ForumPost? post;

  const AddForumPost({super.key, required this.forum, this.post});

  @override
  State<AddForumPost> createState() => _AddForumPostState();
}

class _AddForumPostState extends State<AddForumPost> {
  TextEditingController descriptionController = TextEditingController();
  final SavingController savingController = Get.put(SavingController());
  List<File> _mediaFiles = [];
  bool private = false;
  UserController userController = Get.put(UserController());
  ForumServices feedService = ForumServices();

  final List<String> availableTags =
      interestsOptions.map((item) => item.tag).toList();
  List<String> filteredTags = [];
  bool showSuggestions = false;
  int currentHashtagStartIndex = -1;
  bool loading = false;

  double cursorX = 0.0;
  double cursorY = 0.0;

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

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void updatePost() async {
    setState(() {
      loading = true;
    });
    final body = {
      "public": !private,
      "content": descriptionController.text,
    };
    feedService.updateForumPost(
        widget.forum.id, {"updateData": body}, widget.post!.id);
    if (mounted) {
      setState(() {
        _mediaFiles = [];
        descriptionController.text = "";
      });
    }
    setState(() {
      loading = false;
    });
    Get.to(() => ForumAllPosts(forum: widget.forum));
  }

  void createPost() async {
    List<Map<String, String>> urls = [];
    setState(() {
      loading = true;
    });
    if (_mediaFiles.isNotEmpty) {
      urls = await _uploadMedia();
    }
    final body = {
      "public": !private,
      "content": descriptionController.text,
      "media": urls,
    };
    feedService.createForumPost(widget.forum.id, body);
    if (mounted) {
      setState(() {
        _mediaFiles = [];
        descriptionController.text = "";
      });
    }
    setState(() {
      loading = false;
    });
    Get.to(() => ForumAllPosts(forum: widget.forum));
  }

  Future<List<Map<String, String>>> _uploadMedia() async {
    savingController.setSavingState(SavingState.uploading);

    List<Map<String, String>> downloadUrls = [];
    final uploadData =
        await UploadServices().uploadMultipleFiles(_mediaFiles, "forum-posts");
    List<Map<String, String>> urls = [];
    urls = uploadData!.media.map((item) => item.toJson()).toList();
    downloadUrls.addAll(urls);
    savingController.setSavingState(SavingState.uploaded);
    Future.delayed(const Duration(seconds: 2), () {
      savingController.setSavingState(SavingState.no);
    });

    return downloadUrls;
  }

  @override
  void initState() {
    if (mounted && widget.post != null) {
      setState(() {
        private = !widget.post!.public;
        descriptionController.text = widget.post!.content;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: Text(
          widget.post != null ? "Update Post" : "Create Post",
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (descriptionController.text.isNotEmpty ||
                  _mediaFiles.isNotEmpty) {
                if (widget.post != null) {
                  updatePost();
                } else {
                  createPost();
                }
              } else {
                ToastManager.showToast(
                  "No media selected",
                  context,
                );
              }
            },
            child: Text(
              loading ? "Uploading..." : "Post",
              style: const TextStyle(
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
                            fit: BoxFit.cover,
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
                                    color:
                                        private != true ? Colors.white : accent,
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
                                    color:
                                        private == true ? Colors.white : accent,
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
              Stack(
                children: [
                  // RichText for styled text (background highlights)
                  // Positioned.fill(
                  //   child: IgnorePointer(
                  //     ignoring: true,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  //       child: RichText(
                  //         text: _buildRichText(),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Transparent TextField for input
                  MouseRegion(
                    onEnter: (_) {},
                    onExit: (_) {},
                    onHover: (details) {
                      setState(() {
                        cursorX = details.localPosition.dx;
                        cursorY = details.localPosition.dy - 20;
                      });
                    },
                    child: TextFormField(
                      controller: descriptionController,
                      minLines: 5,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        // color: accent,
                        // backgroundColor: Colors.yellow,
                      ),
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '',
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 2 * horizontal_p,
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
  }
}
