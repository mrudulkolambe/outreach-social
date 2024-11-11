import 'package:outreach/api/models/upload.dart';
import 'package:outreach/models/post.dart';

class ResourceCategoriesResponse {
  bool success;
  String message;
  List<ResourceCategory> response;

  ResourceCategoriesResponse({
    required this.success,
    required this.message,
    required this.response,
  });

  factory ResourceCategoriesResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final response = List.from(json["response"]).map((element) {
      return ResourceCategory.fromJson(element);
    }).toList();

    return ResourceCategoriesResponse(
      success: success,
      message: message,
      response: response,
    );
  }
}

class ResourceCategory {
  String id;
  String title;
  int createdAt;
  bool enabled;

  ResourceCategory({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.enabled,
  });

  factory ResourceCategory.fromJson(dynamic json) {
    final enabled = json["enabled"] as bool;
    final createdAt = json["createdAt"] as int;
    final title = json["title"] as String;
    final id = json["_id"] as String;

    return ResourceCategory(
      enabled: enabled,
      createdAt: createdAt,
      title: title,
      id: id,
    );
  }
}

final List<ResourcePost> emptyResourcePostList = [];

class ResourcePostResponse {
  bool success;
  String message;
  ResourcePost? feed;

  ResourcePostResponse({
    required this.success,
    required this.message,
    this.feed,
  });

  factory ResourcePostResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final feed = json["response"] == null
        ? null
        : ResourcePost.fromJson(json["response"]);

    return ResourcePostResponse(
      success: success,
      message: message,
      feed: feed,
    );
  }
}

class ResourcePostsResponse {
  bool success;
  String message;
  List<ResourcePost> feeds;
  int totalFeeds;
  int totalPages;
  int currentPage;

  ResourcePostsResponse({
    required this.success,
    required this.message,
    required this.feeds,
    required this.totalFeeds,
    required this.currentPage,
    required this.totalPages,
  });

  factory ResourcePostsResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final feeds =
        json["response"]["feeds"] == [] || json["response"]["feeds"] == null
            ? emptyResourcePostList
            : List.from(json["response"]["feeds"])
                .map((e) => ResourcePost.fromJson(e))
                .toList();
    final totalPages = json["response"]["totalPages"] as int;
    final totalFeeds = json["response"]["totalFeeds"] as int;
    final currentPage = json["response"]["currentPage"] as int;

    return ResourcePostsResponse(
      success: success,
      message: message,
      feeds: feeds,
      totalFeeds: totalFeeds,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

class ResourcePost {
  String id;
  String title;
  String content;
  String category;
  List<Media> media;
  PostUser user;
  int likesCount;
  int commentCount;
  bool liked;

  ResourcePost({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.media,
    required this.user,
    required this.liked,
    required this.likesCount,
    required this.commentCount,
  });

  factory ResourcePost.fromJson(dynamic json) {
    final id = json["_id"] as String;
    final content = json["content"] as String;
    final title = json["title"] as String;
    final category = json["category"] as String;
    final media =
        List.from(json["media"]).map((e) => Media.fromJson(e)).toList();
    final user = PostUser.fromJson(json["user"]);
    final liked = json["liked"];
    final likesCount = json["likesCount"];
    const commentCount = 0;
    // final commentCount = json["commentCount"];

    return ResourcePost(
      id: id,
      title: title,
      content: content,
      category: category,
      media: media,
      user: user,
      liked: liked,
      likesCount: likesCount,
      commentCount: commentCount,
    );
  }
}
