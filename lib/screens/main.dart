import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/controller/saving.dart';
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
      HomePage(key: PageStorageKey('FeedPage')),
      ForumScreen(key: PageStorageKey('SearchPage')),
      AddPost(key: PageStorageKey('AddPost')),
      ListResources(key: PageStorageKey('ResourcesPage')),
      MoreScreen(key: PageStorageKey('MorePage'))
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
          selectedLabelStyle: TextStyle(
            color: accent,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
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
                color: accent,
                "assets/icons/home.svg",
                height: 24,
                width: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/forum.svg",
                height: 24,
                width: 24,
              ),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_rounded,
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/resource.svg",
                height: 24,
                width: 24,
              ),
              label: 'Resources',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
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
