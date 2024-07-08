import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/search_history.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key});

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: Text(
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
                  decoration: InputDecoration(
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Clear all",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, color: accent),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              // color: Colors.black12,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                child: Column(
                  children: [
                    SearchHistoryCard(),
                    SearchHistoryCard(),
                    SearchHistoryCard(),
                    SearchHistoryCard(),
                    SearchHistoryCard(),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
