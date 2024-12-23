import 'package:flutter/material.dart';
import 'package:outreach/api/models/notification.dart';
import 'package:outreach/api/services/notification_services.dart';
import 'package:outreach/constants/spacing.dart';

class NotificationScreen extends StatefulWidget {
  final String user;

  const NotificationScreen({super.key, required this.user});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationServices notificationServices = NotificationServices();
  final ScrollController _scrollController = ScrollController();
  List<UserNotification> notificationList = [];
  bool hasMoreNotification = false;
  int _currentPage = 1;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(moreNotifications);
    init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> moreNotifications() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (hasMoreNotification) {
      _currentPage++;
      final moreNotificationResponse =
          await notificationServices.getNotifications(page: _currentPage);
      setState(() {
        hasMoreNotification = moreNotificationResponse!.totalPages >
            moreNotificationResponse.page;
        notificationList.addAll(moreNotificationResponse.notifications);
      });
    } else {
      print("Else Load More Posts");
    }
  }

  void init() async {
    final notificationsResponse =
        await notificationServices.getNotifications(page: 1, user: widget.user);
    notificationList.addAll(notificationsResponse!.notifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontal_p,
          ),
          controller: _scrollController,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "New",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ...notificationList.map((notiuficationItem) {
                return Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@chineduok like to your photo.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("20 mins ago"),
                      ],
                    )
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
