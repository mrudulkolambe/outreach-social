import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/resource.dart';
import 'package:outreach/api/services/resource_services.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/saving.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/platform_constraints/media_preview_mobile.dart';
import 'package:outreach/widgets/styled_textfield.dart';
import 'package:permission_handler/permission_handler.dart';

class ResourceAddPost extends StatefulWidget {
  final ResourcePost? resourcePost;

  const ResourceAddPost({super.key, this.resourcePost});

  @override
  State<ResourceAddPost> createState() => _ResourceAddPostState();
}

class _ResourceAddPostState extends State<ResourceAddPost> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final SavingController savingController = Get.put(SavingController());
  List<File> _mediaFiles = [];
  UserController userController = Get.put(UserController());
  ResourceServices resourceServices = ResourceServices();
  List<ResourceCategory> resourceCategories = [];
  String category = "";

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final response = await resourceServices.getResourceCategory();
    if (mounted) {
      setState(() {
        resourceCategories = response;
        category = response.first.id;
      });
      if (widget.resourcePost != null) {
        setState(() {
          category = widget.resourcePost!.category;
          titleController.text = widget.resourcePost!.title ?? "";
          descriptionController.text = widget.resourcePost!.content;
        });
      }
    }
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

  void updatePost() async {
    final body = {
      "content": descriptionController.text,
      "category": category,
      "title": titleController.text
    };
    resourceServices.updatePost({"updateData": body}, widget.resourcePost!.id);
    if (mounted) {
      setState(() {
        _mediaFiles = [];
        descriptionController.text = "";
      });
    }
    Get.offAll(() => const MainStack(
          page: 3,
        ));
  }

  bool loading = false;
  void createPost() async {
    List<Map<String, String>> urls = [];
    if (_mediaFiles.isNotEmpty) {
      urls = await _uploadMedia();
    }
    setState(() {
      loading = true;
    });
    final body = {
      "content": descriptionController.text,
      "category": category,
      "media": urls,
      "title": titleController.text
    };
    resourceServices.createPost(body);
    if (mounted) {
      setState(() {
        ToastManager.showToast("Submitted for approval", context);
        _mediaFiles = [];
        descriptionController.text = "";
        loading = false;
      });
    }
    Get.offAll(() => const MainStack(
          page: 3,
        ));
  }

  Future<List<Map<String, String>>> _uploadMedia() async {
    savingController.setSavingState(SavingState.uploading);

    List<Map<String, String>> downloadUrls = [];
    final uploadData =
        await UploadServices().uploadMultipleFiles(_mediaFiles, "resources");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: Text(
          widget.resourcePost != null
              ? "Update your resource"
              : "Share your resource",
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (descriptionController.text.isNotEmpty ||
                  _mediaFiles.isNotEmpty) {
                if (widget.resourcePost != null) {
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
              loading
                  ? "Uploading"
                  : widget.resourcePost != null
                      ? "Update"
                      : "Post",
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
                        height: 2,
                      ),
                      Text(
                        "@${userController.userData!.username!}",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: grey),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (category.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: accent),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    isExpanded: true,
                    value: category,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        category = value!;
                      });
                    },
                    items: resourceCategories.map<DropdownMenuItem<String>>(
                        (ResourceCategory value) {
                      return DropdownMenuItem<String>(
                        value: value.id,
                        child: Text(value.title),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              StyledTextField(
                controller: titleController,
                keyboardType: TextInputType.name,
                hintText: "Resource title",
                label: "Write the title",
                next: true,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: descriptionController,
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
