import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/forum.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/screens/more.dart';
import 'package:outreach/screens/resources/list_resources.dart';
import 'package:outreach/utils/breakpoints.dart';

class Navbar extends StatelessWidget {
  final Function? openBottomSheet;
  final Function? homeClick;

  const Navbar({super.key, this.openBottomSheet, this.homeClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: horizontal_p,
      ),
      height: MediaQuery.of(context).size.width > Breakpoints.mobile
          ? 70
          : MediaQuery.of(context).size.width > Breakpoints.tablet
              ? 80
              : 70,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (Get.currentRoute == "/HomePage") {
                homeClick!();
              } else {
                Get.to(() => const MainStack());
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/home.svg",
                ),
                const Text("Home")
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => const ForumScreen()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/forum.svg",
                ),
                const Text("Forum")
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (Get.currentRoute == "/HomePage") {
                openBottomSheet!();
              } else {
                Get.to(() => MainStack());
              }
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                ),
                Text("Post")
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => const ListResources()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/resource.svg",
                ),
                const Text("Resource")
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => const MoreScreen()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/menu.svg",
                ),
                const Text("More")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
