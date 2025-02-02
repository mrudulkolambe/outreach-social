// main.dart
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/interest.dart';
import 'package:outreach/screens/your_posts.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/interest/interest_choice.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/posts/profile.dart';
import 'package:outreach/widgets/profile/details_elem.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

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
    print("FEED COUNT: ${response?.feedCount}");
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

  @override
  Widget build(BuildContext context) {
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
                        userData!.imageUrl == null
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
                                    : userData!.feedCount ?? 0,
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
                        Get.to(() => ZIMKitMessageListPage(
                              appBarActions: [
                                ZegoSendCallInvitationButton(
                                  isVideoCall: false,
                                  clickableBackgroundColor: Colors.transparent,
                                  iconSize: const Size(40, 40),
                                  icon: ButtonIcon(
                                    icon: const Icon(
                                      Icons.call_outlined,
                                      color: accent,
                                    ),
                                  ),
                                  unclickableBackgroundColor:
                                      Colors.transparent,
                                  buttonSize: const Size(40, 40),
                                  resourceID: "outreach-zim",
                                  invitees: [
                                    ZegoUIKitUser(
                                      id: userData!.id,
                                      name: userData!.username!,
                                    )
                                  ],
                                ),
                                ZegoSendCallInvitationButton(
                                  isVideoCall: true,
                                  clickableBackgroundColor: Colors.transparent,
                                  iconSize: const Size(40, 40),
                                  icon: ButtonIcon(
                                    icon: const Icon(
                                      Icons.videocam_outlined,
                                      color: accent,
                                    ),
                                  ),
                                  unclickableBackgroundColor:
                                      Colors.transparent,
                                  buttonSize: const Size(40, 40),
                                  resourceID: "outreach-zim",
                                  invitees: [
                                    ZegoUIKitUser(
                                      id: userData!.id,
                                      name: userData!.username!,
                                    )
                                  ],
                                ),
                              ],
                              showMoreButton: false,
                              inputDecoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your message here...",
                              ),
                              showPickFileButton: false,
                              showPickMediaButton: false,
                              showRecordButton: false,
                              conversationID: userData!.id,
                              conversationType: ZIMConversationType.peer,
                            ));
                      },
                      child: const StyledButton(
                        text: "Message",
                        loading: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // InkWell(
                    //   onTap: () {
                    //     final VoiceCallController callController =
                    //         Get.put(VoiceCallController());

                    //     audioCall(
                    //       "voice",
                    //       userData!.id,
                    //       userController.userData!.imageUrl ?? "null",
                    //       userController.userData!.name ?? "null",
                    //       callController.uniqueChannelName.value,
                    //     );
                    //   },
                    //   child: const StyledButton(
                    //     text: "Calling Button",
                    //     loading: false,
                    //   ),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     final VideoCallControlller videoController =
                    //         Get.put(VideoCallControlller());

                    //     videoCall(
                    //       "video",
                    //       userData!.id,
                    //       userController.userData!.imageUrl ?? "null",
                    //       userController.userData!.name ?? "null",
                    //       videoController.uniqueChannelName.value,
                    //     );
                    //   },
                    //   child: const StyledButton(
                    //     text: "Video Call",
                    //     loading: false,
                    //   ),
                    // ),
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
                    if (userData!.interest.isEmpty) const Text("No interests"),
                    if (userData!.interest.isNotEmpty)
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
                    if (userData!.feeds.isEmpty) const Text("No posts"),
                    if (userData!.feeds.isNotEmpty)
                      ...userData!.feeds.reversed.map((e) => ProfilePosts(
                            post: e,
                            user: userData!,
                          )),
                    if (userData!.feeds.isNotEmpty)
                      InkWell(
                        onTap: () => Get.to(() => YourPosts(
                              user: widget.userId,
                            )),
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
                      children: [
                        const TableRow(
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
                        ...userData!.leaderBoard!.asMap().entries.map((item) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text((item.key + 1).toString()),
                                ),
                              ),
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Afolabi Ogunleye"),
                                ),
                              ),
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("2563"),
                                ),
                              ),
                            ],
                          );
                        }),
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
