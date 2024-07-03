import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/create_forum.dart';
import 'package:outreach/screens/forum/joined_forum.dart';
import 'package:outreach/widgets/forum/forum_card_primary.dart';
import 'package:outreach/widgets/forum/forum_list_card.dart';
import 'package:outreach/widgets/navbar.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Forum",
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
              SizedBox(
                height: 145,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: horizontal_p),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "List of forum joined",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.to(() => const JoinedForum()),
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
                    SizedBox(
                      height: 95,
                      width: MediaQuery.of(context).size.width - horizontal_p,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return const ForumListCard(title: "Basic Yoga");
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 15);
                        },
                        itemCount: 10,
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
              const Column(
                children: [
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                  ForumCardPrimary(
                    joined: false,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const CreateForum()),
        label: const Text(
          "Create Forum",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        isExtended: true,
        backgroundColor: accent,
      ),
    );
  }
}
