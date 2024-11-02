import 'package:date_format/date_format.dart';
import 'package:outreach/api/models/upload.dart';
import 'package:outreach/models/post.dart';

class UserStoryResponse {
  bool success;
  String message;
  StoryResponse response;

  UserStoryResponse({
    required this.success,
    required this.message,
    required this.response,
  });
  factory UserStoryResponse.fromJson(dynamic json) {
    print(json["message"]);
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final response = StoryResponse.fromJson(json["response"]);

    return UserStoryResponse(
      success: success,
      message: message,
      response: response,
    );
  }
}

class StoryResponse {
  List<UserStory> own;
  List<UserStory> user;

  StoryResponse({
    required this.own,
    required this.user,
  });
  factory StoryResponse.fromJson(dynamic json) {
    final own = List.from(json["own"]).map((story) {
      return UserStory.fromJson(story);
    }).toList();
    final user = List.from(json["user"]).map((story) {
      return UserStory.fromJson(story);
    }).toList();

    return StoryResponse(own: own, user: user);
  }
}

class UserStory {
  String id;
  PostUser userId;
  String content;
  Media media;
  int timestamp;
  bool deleted;
  String createdAt;
  String updatedAt;

  UserStory({
    required this.id,
    required this.userId,
    required this.content,
    required this.media,
    required this.timestamp,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserStory.fromJson(dynamic json) {
    final id = json["_id"] as String;
    final user = PostUser.fromJson(json["userId"]);
    final content = json["content"] as String;
    final media = Media.fromJson(json["media"]);
    final timestamp = json["timestamp"] as int;
    final deleted = json["deleted"] as bool;
    final createdAt = json["createdAt"] as String;
    final updatedAt = json["updatedAt"] as String;

    return UserStory(id: id, userId: user,content: content, media: media, timestamp: timestamp, deleted: deleted, createdAt: createdAt, updatedAt: updatedAt );
  }
}

class UploadStoryResponse {
  bool success;
  String message;
  UserStory response;

  UploadStoryResponse({
    required this.success,
    required this.message,
    required this.response,
  });
}

class UserStoryGroup {
  String username;
  List<UserStory> stories;

  UserStoryGroup({
    required this.username,
    required this.stories,
  });
}
