import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateForumPost extends StatefulWidget {
  const CreateForumPost({super.key});

  @override
  State<CreateForumPost> createState() => _CreateForumPost();
}

class _CreateForumPost extends State<CreateForumPost> {
  bool private = false;
  List<File> postImgList = [];

  Future<bool> requestGalleryPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> chooseImages() async {
    bool permissionGranted = await requestGalleryPermission();
    if (permissionGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          postImgList.add(File(image.path));
        });
      } else {
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Share Post",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Post",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: accent, fontSize: 18),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
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
                      const Text(
                        "Chinedu Okoro",
                        style: TextStyle(
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
                // controller: postDesptn,
                minLines: null,
                maxLines: null,
                onChanged: (string) {
                  setState(() {
                    // postDesptn.text = string;
                  });
                },
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
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < postImgList.length; i++)
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 170,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: FileImage(postImgList[i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  postImgList.removeAt(i);
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
            GestureDetector(
              onTap: chooseImages,
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.description,
                        size: 20,
                        color: accent,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Upload Photos/Videos",
                        style: TextStyle(
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
