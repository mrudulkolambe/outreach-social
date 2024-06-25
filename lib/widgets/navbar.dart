import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/screens/more.dart';
import 'package:outreach/utils/breakpoints.dart';

class Navbar extends StatelessWidget {
  final Function? openBottomSheet;

  const Navbar({super.key, this.openBottomSheet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: horizontal_p,
      ),
      height: MediaQuery.of(context).size.width > Breakpoints.mobile ? 70 : MediaQuery.of(context).size.width > Breakpoints.tablet ? 80 : 70,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Get.to(() => const HomePage()),
                child: SvgPicture.asset(
                  "assets/icons/home.svg",
                ),
              ),
              const Text("Home")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/forum.svg",
              ),
              const Text("Forum")
            ],
          ),
          GestureDetector(
            onTap: () {
              if (Get.currentRoute == "/HomePage") {
                openBottomSheet!();
              } else {
                Get.to(() => const HomePage());
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/resource.svg",
              ),
              const Text("Resource")
            ],
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
