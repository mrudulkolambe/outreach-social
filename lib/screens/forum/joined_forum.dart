import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/forum.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/widgets/forum/forum_card_primary.dart';

class JoinedForum extends StatefulWidget {
  const JoinedForum({super.key});

  @override
  State<JoinedForum> createState() => _JoinedForumState();
}

class _JoinedForumState extends State<JoinedForum> {
  final ForumController forumController = Get.put(ForumController());
  final UserController userController = Get.put(UserController());
  List<Forum> joinedForums = [];

  @override
  void initState() {
    forumController.forums.where((forum) =>
        forum.joined.contains(userController.userData!.id) ||
        forum.userId.id == userController.userData!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "List of forum joined",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
                child: SizedBox(
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
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 5,
                color: Color.fromRGBO(239, 239, 240, 1),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: [
                  ...forumController.forums
                      .where((forum) =>
                          forum.joined.contains(userController.userData!.id) ||
                          forum.userId.id == userController.userData!.id)
                      .map((forum) {
                    return ForumCardPrimary(joined: true, forum: forum);
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
