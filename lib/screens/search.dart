import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/search_history.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key});

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

final _storage = GetStorage();

class _SearchUsersState extends State<SearchUsers> {
  Timer? _debounce;
  final UserService userService = UserService();
  List<PostUser> users = [];
  UserController userController = Get.put(UserController());
  bool fetching = false;

  void searchHistory() async {
    final search = await _storage.read("global_search_history");
    if (search == null) {
      _storage.write("global_search_history", []);
    } else {
      print("search");
      print(search);
    }
  }

  void searchUsers(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      if (query.isNotEmpty && userController.userData != null) {
        setState(() {
          fetching = true;
        });
        final usersList =
            await userService.globalSearch(query, userController.userData!.id);
        setState(() {
          if (usersList == null) {
            users = [];
          } else {
            users = usersList;
          }
          fetching = false;
        });
      }
    });
  }

  @override
  void initState() {
    searchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Search",
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
                  onChanged: (value) {
                    searchUsers(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    suffixIcon: fetching ? Container(
                      height: 10,
                      width: 10,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: accent.withOpacity(0.5),
                          strokeWidth: 2,
                        ),
                      ),
                    ): null,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Clear all",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, color: accent),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
              child: Column(
                children: [
                  ...users.map((user) {
                    return SearchHistoryCard(user: user,);
                  })
                ],
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
