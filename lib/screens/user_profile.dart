// main.dart
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/agora_chat_service.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/controller/voice_call_controller.dart';
import 'package:outreach/models/call_request.dart';
import 'package:outreach/models/interest.dart';
import 'package:outreach/screens/agora/chat.dart';
import 'package:outreach/screens/agora/voice_call_state/call.dart';
import 'package:outreach/screens/your_posts.dart';
import 'package:outreach/utils/f.dart';
import 'package:outreach/utils/firebasemsg_handler.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/interest/interest_choice.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/posts/profile.dart';
import 'package:outreach/widgets/profile/details_elem.dart';
import 'package:outreach/widgets/styled_button.dart';

import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({super.key, required this.userId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserService userService = UserService();
  UserController userController = Get.put(UserController());
  UserData? userData;
  bool followLoading = false;

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  void getUserProfile() async {
    final response = await userService.getUserProfile(
      widget.userId,
      userController.userData!.id,
    );
    setState(() {
      userData = response;
      followLoading = false;
    });
  }

  void handleFollowing() async {
    setState(() {
      followLoading = true;
    });
    final response = await userService.followUser(
      widget.userId,
      userController.userData!.id,
    );
    if (response == 200) {
      getUserProfile();
    } else {
      ToastManager.showToast("Something went wrong", context);
    }
  }

  void audioCall(
    String call_type,
    String to_token,
    String to_avatar,
    String to_name,
    String channel_id,
  ) async {
    final VoiceCallController callController = Get.put(VoiceCallController());

    callController.personalID.value = userController.userData!.id;
    callController.nextPersonID.value = userData!.id;
    callController.nextPersonName.value = userData!.name!;  
    callController.nextPersonPic.value = userData!.imageUrl!;

    Get.to(
      () => VoiceCallPage(
        to_token: userData!.id,
        to_name: userData!.name,
        to_profile_image: userData!.imageUrl,
        call_role:
            callController.callerRole.value == "anchor" ? "anchor" : "audience",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AgoraService agoraService = AgoraService();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: userData != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        userData == null && userData!.imageUrl == null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(80 / 2),
                                ),
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: Text(
                                    userData!.name!
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
                                imageUrl: userData!.imageUrl!,
                                size: 80,
                              ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatsElem(
                                count: userData == null
                                    ? 0
                                    : userData!.feeds.length,
                                title: "Posts",
                              ),
                              StatsElem(
                                count: userData == null
                                    ? 0
                                    : userData!.followers ?? 0,
                                title: "Followers",
                              ),
                              StatsElem(
                                count: userData == null
                                    ? 0
                                    : userData!.following ?? 0,
                                title: "Following",
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          userData == null ? "..." : userData!.name!,
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
                            "@${userData == null ? '' : userData!.username}",
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
                          child:
                              Text(userData!.bio == null ? "" : userData!.bio!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: handleFollowing,
                      child: StyledButton(
                        loading: followLoading,
                        text: !userData!.isFollowing! ? "Follow" : "Unfollow",
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Message Button
                    InkWell(
                      onTap: () async {
                        await agoraService.createAttribute(
                          userName: userData!.name!,
                          userImage: userData!.imageUrl!,
                          cId: userData!.id,
                        );

                        final conversation =
                            await agoraService.getConversation(userData!.id);
                        Get.to(
                          () => ChatScreen(
                            recipientId: userData!.id,
                            recipientName: userData!.name!,
                            recipientImage: userData!.imageUrl,
                            conversation: conversation,
                          ),
                        );
                      },
                      child: const StyledButton(
                        text: "Message",
                        loading: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        final VoiceCallController callController =
                            Get.put(VoiceCallController());
                        audioCall("voice", userData!.id, userData!.imageUrl!,
                            userData!.name!, callController.uniqueChannelName.value);

                        log("on Line 238 ${userData!.id} ${userData!.imageUrl!} ${userData!.name!} ${callController.uniqueChannelName.value}");
                      },
                      child: const StyledButton(
                        text: "Calling Button",
                        loading: false,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Interest",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                          interestType:
                              handleInterests(userData!.interest)[index],
                          selected: userData!.interest,
                        );
                      },
                      itemCount: handleInterests(userData!.interest).length,
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Posts",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ...userData!.feeds.reversed
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
