import 'package:outreach/models/post.dart';

class NotificationsResponse {
  bool success;
  String message;
  int totalNotifications;
  int page;
  int limit;
  int totalPages;
  List<UserNotification> notifications;

  NotificationsResponse({
    required this.success,
    required this.message,
    required this.notifications,
    required this.page,
    required this.limit,
    required this.totalNotifications,
    required this.totalPages,
  });

  factory NotificationsResponse.fromJson(dynamic json) {
    print(json);
    final success = json["success"];
    final message = json["message"] as String;
    final notifications =
        List.from(json["response"]["notifications"]).map((item) {
      return UserNotification.fromJson(item);
    }).toList();
    final page = json["response"]["page"];
    final limit = json["response"]["limit"];
    final totalNotifications = json["response"]["totalNotifications"];
    final totalPages = json["response"]["totalPages"];

    return NotificationsResponse(
      success: success,
      message: message,
      notifications: notifications,
      page: page,
      limit: limit,
      totalNotifications: totalNotifications,
      totalPages: totalPages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "notifications": notifications,
      "page": page,
      "limit": limit,
      "totalNotifications": totalNotifications,
      "totalPages": totalPages,
    };
  }
}

class UserNotification {
  String id;
  String title;
  String description;
  PostUser to;
  PostUser? from;
  String? post;
  String type;
  int timestamp;

  UserNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.to,
    required this.from,
    required this.post,
    required this.type,
    required this.timestamp,
  });

  factory UserNotification.fromJson(dynamic json) {
    final id = json["_id"] as String;
    final title = json["title"] as String;
    final description = json["description"] as String;
    final to = PostUser.fromJson(json["to"]);
    final from = PostUser.fromJson(json["from"]);
    final post = json["post"];
    final type = json["type"];
    final timestamp = json["timestamp"];
    return UserNotification(
      id: id,
      timestamp: timestamp,
      title: title,
      description: description,
      to: to,
      from: from,
      post: post,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "timestamp": timestamp,
      "title": title,
      "description": description,
      "to": to,
      "from": from,
      "post": post,
      "type": type,
    };
  }
}
