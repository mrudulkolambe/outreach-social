import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/forum_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/forum.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/screens/forum/create_forum.dart';
import 'package:outreach/screens/forum/joined_forum.dart';
import 'package:outreach/widgets/forum/forum_card_primary.dart';
import 'package:outreach/widgets/forum/forum_list_card.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ForumController forumController = Get.put(ForumController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    initializeState();
    super.initState();
  }

  void initializeState() async {
    final forums = await ForumServices().getForums();
    forumController.initAddForums(forums ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        centerTitle: false,
        title: const Text(
          "Forum",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<ForumController>(
            init: ForumController(),
            builder: (forumController) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: horizontal_p),
                      child: SizedBox(
                        height: 45,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                    if (forumController.forums
                        .where((forum) =>
                            forum.userId.id == userController.userData!.id ||
                            forum.joined.contains(userController.userData!.id))
                        .isNotEmpty)
                      const Divider(
                        thickness: 5,
                        color: Color.fromRGBO(239, 239, 240, 1),
                      ),
                    if (forumController.forums
                        .where((forum) =>
                            forum.userId.id == userController.userData!.id ||
                            forum.joined.contains(userController.userData!.id))
                        .isNotEmpty)
                      SizedBox(
                        height: 145,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: horizontal_p,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "List of forum joined",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.to(
                                      () => const JoinedForum(),
                                    ),
                                    child: const Text(
                                      "View all",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (forumController.forums
                                .where((forum) =>
                                    forum.userId.id ==
                                        userController.userData!.id ||
                                    forum.joined
                                        .contains(userController.userData!.id))
                                .isNotEmpty)
                              SizedBox(
                                height: 95,
                                width: MediaQuery.of(context).size.width -
                                    horizontal_p,
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return ForumListCard(
                                      forum: forumController.forums
                                          .where((forum) =>
                                              forum.userId.id ==
                                                  userController.userData!.id ||
                                              forum.joined.contains(
                                                  userController.userData!.id))
                                          .toList()[index],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 15);
                                  },
                                  itemCount: forumController.forums
                                      .where((forum) =>
                                          forum.userId.id ==
                                              userController.userData!.id ||
                                          forum.joined.contains(
                                              userController.userData!.id))
                                      .length,
                                ),
                              ),
                          ],
                        ),
                      ),
                    const Divider(
                      thickness: 5,
                      color: Color.fromRGBO(239, 239, 240, 1),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                      child: Row(
                        children: [
                          Text(
                            "Explore new forum",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ...forumController.forums
                            .where(
                              (forum) =>
                                  forum.public &&
                                  forum.userId.id !=
                                      userController.userData!.id &&
                                  !forum.joined
                                      .contains(userController.userData!.id),
                            )
                            .map(
                              (forum) => ForumCardPrimary(
                                joined: false,
                                forum: forum,
                              ),
                            )
                      ],
                    ),
                    Positioned(
                      bottom: 86.0,
                      right: 16.0,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(() => const CreateForum()),
                        icon: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Create Forum",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              accent, // Use the color you used for FloatingActionButton
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
