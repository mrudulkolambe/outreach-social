// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/screens/add_post.dart';
import 'package:outreach/screens/forum/forum.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/screens/more.dart';
import 'package:outreach/screens/resources/list_resources.dart';

class MainStack extends StatefulWidget {
  const MainStack({super.key});

  @override
  _MainStackState createState() => _MainStackState();
}

class _MainStackState extends State<MainStack> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(key: PageStorageKey('FeedPage')),
      const ForumScreen(key: PageStorageKey('SearchPage')),
      const AddPost(key: PageStorageKey('AddPost')),
      const ListResources(key: PageStorageKey('ResourcesPage')),
      const MoreScreen(key: PageStorageKey('MorePage'))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: grey.withOpacity(0.2), width: 2),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: accent,
          selectedFontSize: 15,
          unselectedFontSize: 14,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            color: accent,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                color: _currentIndex == 0 ? accent : Colors.black,
                "assets/icons/home.svg",
                height: 24,
                width: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                color: _currentIndex == 1 ? accent : Colors.black,
                "assets/icons/forum.svg",
                height: 24,
                width: 24,
              ),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                color: _currentIndex == 2 ? accent : Colors.black,
                Icons.add_rounded,
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                color: _currentIndex == 3 ? accent : Colors.black,
                "assets/icons/resource.svg",
                height: 24,
                width: 24,
              ),
              label: 'Resources',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                color: _currentIndex == 4 ? accent : Colors.black,
                "assets/icons/menu.svg",
                height: 24,
                width: 24,
              ),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
