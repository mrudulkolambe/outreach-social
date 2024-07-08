// main.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/upload_services.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/interest.dart';
import 'package:outreach/screens/auth/bio.dart';
import 'package:outreach/screens/auth/interest.dart';
import 'package:outreach/screens/your_posts.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/interest/interest_choice.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/posts/profile.dart';
import 'package:outreach/widgets/profile/details_elem.dart';
import 'package:permission_handler/permission_handler.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserService userService = UserService();
  PostController postController = Get.put(PostController());
  bool _uploading = false;

  Future<String?> uploadImage(File image) async {
    try {
      setState(() {
        _uploading = true;
      });
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final mediaData =
          await UploadServices().uploadSingleFile(image, "profile/$userID");
      final responseStatus = await userService.updateUser({
        "updateData": {
          "imageUrl": mediaData!.media.url,
        }
      });
      if (responseStatus == 200 || responseStatus == 201) {
        ToastManager.showToast("Profile updated", context);
      } else {
        ToastManager.showToast("Something went wrong", context);
      }
      setState(() {
        _uploading = false;
      });
      return "saved";
    } catch (e) {
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

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null) {
      uploadImage(File(result.paths.first!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: GetBuilder(
            init: UserController(),
            builder: (userController) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(80 / 2),
                          onTap: _pickMedia,
                          child: _uploading
                              ? const SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                    color: accent,
                                    strokeCap: StrokeCap.round,
                                  ),
                                )
                              : userController.userData!.imageUrl == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: accent,
                                        borderRadius:
                                            BorderRadius.circular(80 / 2),
                                      ),
                                      height: 80,
                                      width: 80,
                                      child: Center(
                                        child: Text(
                                          userController.userData!.name!
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CircularShimmerImage(
                                      imageUrl:
                                          userController.userData!.imageUrl!,
                                      size: 80,
                                    ),
                        ),
                        const SizedBox(width: 30),
                        const Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatsElem(count: 20, title: "Posts"),
                              StatsElem(count: 55500, title: "Followers"),
                              StatsElem(count: 5000, title: "Following"),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          userController.userData!.name!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: skyblue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            "@${userController.userData!.username}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(userController.userData!.bio == null
                              ? ""
                              : userController.userData!.bio!),
                        ),
                        IconButton(
                          onPressed: () => Get.to(
                            () => Bio(
                              update: true,
                              bio: userController.userData!.bio == null
                                  ? ""
                                  : userController.userData!.bio!,
                            ),
                          ),
                          icon: const Icon(Icons.draw_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/trophy.svg", height: 25),
                        const SizedBox(width: 8),
                        Text(
                          "Reward Points ${userController.userData!.rewardPoints!.toString()}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Interest",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.to(
                            () => InterestedIn(
                              update: true,
                              choosenInterest:
                                  userController.userData!.interest,
                            ),
                          ),
                          icon: const Icon(Icons.draw_outlined),
                        ),
                      ],
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InterestChoice(
                          interestType: handleInterests(
                              userController.userData!.interest)[index],
                          selected: userController.userData!.interest,
                        );
                      },
                      itemCount:
                          handleInterests(userController.userData!.interest)
                              .length,
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Posts",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ...userController.userData!.feeds.reversed
                        .map((e) => ProfilePosts(post: e)),
                    InkWell(
                      onTap: () => Get.to(() => const YourPosts()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "See all Post",
                              style: TextStyle(color: accent),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: accent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Leaderboard",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(64),
                        1: IntrinsicColumnWidth(),
                        2: FlexColumnWidth(),
                      },
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Rank"),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Posts interest "),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("3 months "),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Rank"),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Afolabi Ogunleye"),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("2563"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
