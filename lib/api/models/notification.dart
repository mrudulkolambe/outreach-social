import 'package:outreach/api/models/upload.dart';
import 'package:outreach/api/models/user.dart';

import '../../models/post.dart';

const List<String> emptyJoined = [];

class ForumResponse {
  bool success;
  String message;
  List<Forum> forums;

  ForumResponse({
    required this.success,
    required this.message,
    required this.forums,
  });

  factory ForumResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final forums = List.from(json["response"]).map((forum) {
      return Forum.fromJson(forum);
    }).toList();

    return ForumResponse(
      success: success,
      message: message,
      forums: forums,
    );
  }
}

class Forum {
  String id;
  UserData userId;
  bool public;
  String name;
  String category;
  String description;
  int timestamp;
  String image;
  List<String> joined;

  Forum({
    required this.id,
    required this.userId,
    required this.public,
    required this.name,
    required this.category,
    required this.description,
    required this.timestamp,
    required this.image,
    required this.joined,
  });

  factory Forum.fromJson(dynamic json) {
    final id = json["_id"] as String;
    final public = json["public"] as bool;
    final name = json["name"] as String;
    final category = json["category"] as String;
    final description = json["description"] as String;
    final timestamp = json["timestamp"] as int;
    final image = json["image"] as String;
    final user = UserData.fromJson(json["userId"]);
    final joined = json['joined'] == null
        ? emptyJoined
        : List.from(json['joined']).map((item) => item as String).toList();

    return Forum(
      id: id,
      public: public,
      name: name,
      category: category,
      description: description,
      timestamp: timestamp,
      image: image,
      userId: user,
      joined: joined,
    );
  }
}

class ForumPost {
  String id;
  String content;
  List<Media> media;
  bool public;
  PostUser user;
  int likesCount;
  int commentCount;
  bool liked;

  ForumPost({
    required this.id,
    required this.content,
    required this.public,
    required this.media,
    required this.user,
    required this.liked,
    required this.likesCount,
    required this.commentCount,
  });

  factory ForumPost.fromJson(dynamic json) {
    final id = json["_id"] as String;
    final content = json["content"] as String;
    final media =
        List.from(json["media"]).map((e) => Media.fromJson(e)).toList();
    final public = json["public"] as bool;
    final user = PostUser.fromJson(json["user"]);
    final liked = json["liked"];
    final likesCount = json["likesCount"];
    final commentCount = json["commentCount"];

    return ForumPost(
      id: id,
      content: content,
      media: media,
      public: public,
      user: user,
      liked: liked,
      likesCount: likesCount,
      commentCount: commentCount,
    );
  }
}

final List<ForumPost> emptyForumPostList = [];

class ForumPostResponse {
  bool success;
  String message;
  ForumPost? forumPost;

  ForumPostResponse({
    required this.success,
    required this.message,
    this.forumPost,
  });

  factory ForumPostResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final forumPost =
        json["response"] == null ? null : ForumPost.fromJson(json["response"]);

    return ForumPostResponse(
      success: success,
      message: message,
      forumPost: forumPost,
    );
  }
}

class ForumPostsResponse {
  bool success;
  String message;
  List<ForumPost> forumPosts;
  int totalFeeds;
  int totalPages;
  int currentPage;

  ForumPostsResponse({
    required this.success,
    required this.message,
    required this.forumPosts,
    required this.totalFeeds,
    required this.currentPage,
    required this.totalPages,
  });

  factory ForumPostsResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final forumPosts = json["response"]["forumPosts"] == [] ||
            json["response"]["forumPosts"] == null
        ? emptyForumPostList
        : List.from(json["response"]["forumPosts"])
            .map((e) => ForumPost.fromJson(e))
            .toList();
    final totalPages = json["response"]["totalPages"] as int;
    final totalFeeds = json["response"]["totalPosts"] as int;
    final currentPage = json["response"]["currentPage"] as int;

    return ForumPostsResponse(
      success: success,
      message: message,
      forumPosts: forumPosts,
      totalFeeds: totalFeeds,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
