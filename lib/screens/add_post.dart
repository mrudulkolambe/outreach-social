import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/saving.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/platform_constraints/media_preview_mobile.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController descriptionController = TextEditingController();
  final SavingController savingController = Get.put(SavingController());
  List<File> _mediaFiles = [];
  bool private = false;
  UserController userController = Get.put(UserController());
  FeedService feedService = FeedService();

  List<String> _tags = [];
  final RegExp _tagRegExp = RegExp(r'\B#\w+');

  void extractTags(String text) {
    final matches = _tagRegExp.allMatches(text);
    setState(() {
      _tags.clear();
      for (Match match in matches) {
        _tags.add(match.group(0)!);
      }
    });
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

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
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
    feedService.createFeed(body);
    if (mounted) {
      setState(() {
        _mediaFiles = [];
        descriptionController.text = "";
      });
    }
    Get.offAll(() => const MainStack());
  }

  Future<List<Map<String, String>>> _uploadMedia() async {
    savingController.setSavingState(SavingState.uploading);

    List<Map<String, String>> downloadUrls = [];
    final uploadData =
        await UploadServices().uploadMultipleFiles(_mediaFiles, "posts");
    List<Map<String, String>> urls = [];
    urls = uploadData!.media.map((item) => item.toJson()).toList();
    downloadUrls.addAll(urls);
    savingController.setSavingState(SavingState.uploaded);
    setState(() {
      _tags = [];
    });
    Future.delayed(const Duration(seconds: 2), () {
      savingController.setSavingState(SavingState.no);
    });

    return downloadUrls;
  }

  @override
  Widget build(BuildContext context) {
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
