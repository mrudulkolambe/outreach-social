import 'dart:convert';
import 'dart:developer';

import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/notification.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/utils/toast_manager.dart';

class NotificationServices {
  Future<NotificationsResponse?> getNotifications(
      {int page = 1, int limit = 10, user}) async {
    final response = await ApiService()
        .get('$getNotificationAPI/$user?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      log(response.body);
      final postsData =
          NotificationsResponse.fromJson(jsonDecode(response.body));
      return postsData;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return null;
  }
}
