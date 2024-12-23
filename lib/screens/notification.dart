import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:outreach/api/models/notification.dart';
import 'package:outreach/api/services/notification_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

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
    _loadInitialNotifications();
    _scrollController.addListener(_moreNotifications);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _moreNotifications() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (hasMoreNotification) {
      _currentPage++;
      final moreNotificationResponse = await notificationServices
          .getNotifications(page: _currentPage, user: widget.user);
      if (moreNotificationResponse != null && mounted) {
        setState(() {
          hasMoreNotification = moreNotificationResponse.totalPages >
              moreNotificationResponse.page;
          notificationList.addAll(moreNotificationResponse.notifications);
        });
      }
    }
  }

  Future<void> _loadInitialNotifications() async {
    final notificationsResponse =
        await notificationServices.getNotifications(page: 1, user: widget.user);
    if (mounted) {
      setState(() {
        notificationList = notificationsResponse!.notifications;
        hasMoreNotification = notificationsResponse.totalPages > 1;
      });
    }
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
        child: notificationList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                ),
                controller: _scrollController,
                itemCount: notificationList.length + 1,
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  if (index < notificationList.length) {
                    final notification = notificationList[index];
                    return Row(
                      children: [
                        notification.from!.imageUrl == null
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: accent,
                                ),
                              )
                            : CircularShimmerImage(
                                size: 50,
                                imageUrl: notification.from!.imageUrl,
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    notification.timestamp,
                                  ),
                                  [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd,
                                    "   ",
                                    hh,
                                    ':',
                                    nn,
                                    ' ',
                                    am
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (hasMoreNotification) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
      ),
    );
  }
}
