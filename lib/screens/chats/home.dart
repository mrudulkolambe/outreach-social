import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/widgets/shimmer_image.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

// home_page.dart
class ZIMKitDemoHomePage extends StatefulWidget {
  const ZIMKitDemoHomePage({Key? key}) : super(key: key);

  @override
  State<ZIMKitDemoHomePage> createState() => _ZIMKitDemoHomePageState();
}

class _ZIMKitDemoHomePageState extends State<ZIMKitDemoHomePage> {
  String searchQuery = "";

  final UserService userService = UserService();
  List<UserData> users = [];
  Timer? _debounce;

  void searchUsers(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      if (query.isNotEmpty) {
        print(query);
        final usersList = await userService.searchUsers(query);
        setState(() {
          if (usersList == null) {
            users = [];
          } else {
            users = usersList;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            const Row(
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 45,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                  searchUsers(value.replaceFirst("@", "").toLowerCase());
                },
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
          ],
        ),
      ),
      body: Stack(
        children: [
          if (searchQuery.startsWith("@"))
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                  child: const Row(
                    children: [
                      Text(
                        "Messages",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ...users.map((user) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                    child: Column(children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => ZIMKitMessageListPage(
                              conversationID: user.id,
                              conversationType: ZIMConversationType.peer,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          color: Colors.white,
                          child: Row(
                            children: [
                              ShimmerImage(
                                imageUrl: user.imageUrl!,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              user.name!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "@${user.username}",
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ]),
                  );
                })
              ],
            ),
          if (searchQuery.isEmpty || !searchQuery.contains("@"))
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                  child: const Row(
                    children: [
                      Text(
                        "Messages",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ZIMKitConversationListView(
                    filter: (context, p1) {
                      if (searchQuery.contains("@")) {
                        return p1;
                      }
                      return p1.where((element) {
                        return element.value.name
                            .toLowerCase()
                            .contains(searchQuery);
                      }).toList();
                    },
                    itemBuilder: (context, conversation, defaultWidget) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontal_p),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => ZIMKitMessageListPage(
                                  conversationID: conversation.id,
                                  conversationType: ZIMConversationType.peer,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  ShimmerImage(
                                    imageUrl: conversation.avatarUrl,
                                    width: 60,
                                    height: 60,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  conversation.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  conversation.lastMessage!
                                                      .textContent!.text,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              formatDate(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                  conversation.lastMessage!.info
                                                      .timestamp,
                                                ),
                                                [hh, ':', nn, ' ', am],
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Opacity(
                                              opacity: conversation
                                                          .unreadMessageCount ==
                                                      0
                                                  ? 0
                                                  : 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: accent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                height: 18,
                                                width: 18,
                                                child: Center(
                                                  child: Text(
                                                    conversation
                                                        .unreadMessageCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ]),
                      );
                    },
                    onPressed: (context, conversation, defaultAction) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ZIMKitMessageListPage(
                            messageContentBuilder:
                                (context, message, defaultWidget) {
                              if (message.type == ZIMMessageType.custom) {
                                return Text(message.textContent!.text);
                              } else {
                                return Text(message.textContent!.text);
                              }
                            },
                            conversationID: conversation.id,
                            conversationType: conversation.type,
                          );
                        },
                      ));
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
