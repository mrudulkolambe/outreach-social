import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/widgets/shimmer_image.dart';
// import 'package:zego_zimkit/zego_zimkit.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final UserService userService = UserService();
  List<UserData> users = [];
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    handleUsers();
    super.initState();
  }

  void handleUsers() async {
    final usersList = await userService.getAllUsers();
    setState(() {
      if (usersList == null) {
        users = [];
      } else {
        users = usersList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        title: Column(
          children: [
            const Row(
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 45,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  fillColor: Color.fromRGBO(239, 239, 240, 1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ...users
                  .where((user) => user.id != userController.userData!.id)
                  .map((user) {
                return Column(children: [
                  InkWell(
                    onTap: () {
                      // Get.to(
                      //   () => ZIMKitMessageListPage(
                      //     conversationID: user.id,
                      //     conversationType: ZIMConversationType.peer,
                      //   ),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      color: Colors.white,
                      child: Row(
                        children: [
                          ShimmerImage(
                            imageUrl:
                                user.imageUrl == null ? "" : user.imageUrl!,
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(user.username!),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ]);
              })
            ],
          ),
        ),
      ),
    );
  }
}
