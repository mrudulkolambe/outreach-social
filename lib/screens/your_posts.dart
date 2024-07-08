import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/posts/profile.dart';

class YourPosts extends StatefulWidget {
  const YourPosts({super.key});

  @override
  State<YourPosts> createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Your Posts",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
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
            Expanded(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
                child: GetBuilder<UserController>(
                    init: UserController(),
                    builder: (userController) {
                      return Column(
                        children: [
                          ...userController.userData!.feeds.map(
                            (e) => ProfilePosts(post: e),
                          )
                        ],
                      );
                    }),
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
