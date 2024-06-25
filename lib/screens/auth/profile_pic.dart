// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/auth/bio.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  UserService userService = UserService();
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<String?> uploadImageToFirebase(XFile image) async {
    try {
      setState(() {
        _uploading = true;
      });
      final file = File(image.path);
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref();
      final filename = file.path.split("/").last;
      final uploadRef = storageRef.child("$userID/uploads/$userID-$filename");
      if (kIsWeb) {
        await uploadRef.putData(await file.readAsBytes());
      } else {
        await uploadRef.putFile(file);
      }

      final imgUrl = await uploadRef.getDownloadURL();
      final responseStatus = await userService.updateUser({
        "updateData": {"imageUrl": imgUrl}
      });
      if (responseStatus == 200 || responseStatus == 201) {
        ToastManager.showToast("Profile updated", context);
        Get.offAll(() => const Bio(
              update: false,
              bio: "",
            ));
      } else {
        ToastManager.showToast("Something went wrong", context);
      }
      setState(() {
        _uploading = false;
      });
      return "saved";
    } catch (e) {
      print(e);
      setState(() {
        _uploading = false;
      });
      return "not saved";
    }
  }

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> chooseImage() async {
    if (!kIsWeb) {
      bool permissionGranted = await requestGalleryPermission();
      if (!permissionGranted) {
        openAppSettings();
        return;
      }
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    } else {
      print('No image selected');
    }
  }

  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            "Great! Let's add your\nprofile picture",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                        ),
                          TextButton(onPressed: () => Get.to(() => const Bio(update: false, bio: "",)), child: const Text("Skip", style: TextStyle(color: grey, fontWeight: FontWeight.w400),))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Choose a photo for your profile picture",
                            style: TextStyle(fontSize: 16, color: grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontal_p,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(230),
                            onTap: chooseImage,
                            child: Container(
                              height: 230,
                              width: 230,
                              decoration: BoxDecoration(
                                color: lightgrey,
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: pickedImage != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(230 / 2),
                                      child: Image.file(
                                        File(pickedImage!.path),
                                        height: 230,
                                        width: 230,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/user-placeholder.svg",
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            left: 85,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: chooseImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 60,
                                width: 60,
                                child: const Center(
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(230 / 2),
                        onTap: () {
                          if (pickedImage != null) {
                            uploadImageToFirebase(pickedImage!);
                          } else {
                            ToastManager.showToast("Pick the image", context);
                          }
                        },
                        child: StyledButton(
                          disabled: pickedImage == null,
                          loading: _uploading,
                          text: "Proceed",
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
