// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/models/interest.dart';
import 'package:outreach/screens/forum/forum.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:outreach/widgets/styled_textfield.dart';

class CreateForum extends StatefulWidget {
  const CreateForum({super.key});

  @override
  State<CreateForum> createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {
  final TextEditingController forumName = TextEditingController();
  final TextEditingController forumDescription = TextEditingController();
  bool private = false;
  String category = interestsOptions.first.interest;
  bool loading = false;
  File? image;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (result != null) {
      final imageFile = File(result.paths.first!);
      setState(() {
        image = imageFile;
      });
    }
  }

  void createForum() async {
    setState(() {
      loading = true;
    });
    final userID = FirebaseAuth.instance.currentUser!.uid;
    if (image != null) {
      final imageResult =
          await UploadServices().uploadSingleFile(image!, 'forum/$userID');
      await ForumServices().createForum({
        'public': !private,
        'name': forumName.text,
        'category': category,
        'description': forumDescription.text,
        'image': imageResult!.media.url
      });
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: horizontal_p),
          backgroundColor: Colors.black,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: horizontal_p, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width - 2 * horizontal_p,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/illustrations/forum_created.svg",
                  height: 120,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Your forum created successfully!",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "The best way to Spark new friendship",
                        style: TextStyle(
                          color: grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: InkWell(
                    onTap: () => Get.offAll(() => const ForumScreen()),
                    child: const StyledButton(
                      loading: false,
                      text: "Explore forum",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      ToastManager.showToast("Image not picked", context);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Create Forum",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: pickFile,
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Center(
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: Image.file(
                                    image!,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SvgPicture.asset(
                                  "assets/icons/cloud_upload.svg",
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: Text(
                        "Upload cover photo for \nForum",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                ),
                child: StyledTextField(
                  controller: forumName,
                  keyboardType: TextInputType.name,
                  hintText: "",
                  label: "Forum name",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: horizontal_p),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...interestsOptions.map(
                            (e) => InkWell(
                              onTap: () {
                                setState(() {
                                  category = e.interest;
                                });
                              },
                              child: SizedBox(
                                width: 70,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          234,
                                          241,
                                          255,
                                          1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(45 / 2),
                                        border: Border.all(
                                          width: 1,
                                          color: category != e.interest
                                              ? Colors.transparent
                                              : accent,
                                        ),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(e.icon),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.category,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Forum type",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Write description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 10,
                      controller: forumDescription,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Description",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: accent,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: loading ? () {} : createForum,
                      child: StyledButton(
                        loading: loading,
                        text: "Create Forum",
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
