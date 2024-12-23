import 'dart:developer';

import 'package:outreach/api/models/upload.dart';

class PostResponse {
  String message;
  Post post;

  PostResponse({
    required this.message,
    required this.post,
  });

  factory PostResponse.fromJson(dynamic json) {
    final message = json["message"] as String;
    final post = Post.fromJson(json["response"]);

    return PostResponse(
      message: message,
      post: post,
    );
  }
}

List<Post> emptyPost = [];

class PostsResponse {
  bool success;
  String message;
  List<Post> posts;
  int totalFeeds;
  int totalPages;
  int currentPage;

  PostsResponse({
    required this.success,
    required this.message,
    required this.posts,
    required this.totalFeeds,
    required this.currentPage,
    required this.totalPages,
  });

  factory PostsResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final totalPages = json["response"]["totalPages"] as int;
    final totalFeeds = json["response"]["totalFeeds"] as int;
    final currentPage = json["response"]["currentPage"] as int;
    final posts =
        json["response"]["feeds"] == [] || json["response"]["feeds"] == null
            ? emptyPost
            : List.from(json["response"]["feeds"])
                .map((e) => Post.fromJson(e))
                .toList();

    return PostsResponse(
      success: success,
      message: message,
      posts: posts,
      totalFeeds: totalFeeds,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

final List<String> emptyTagList = [];

class Post {
  String id;
  String content;
  List<Media> media;
  bool public;
  PostUser user;
  List<String> tags;
  int likesCount;
  int commentCount;
  bool liked;

  Post(
      {required this.id,
      required this.content,
      required this.public,
      required this.media,
      required this.user,
      required this.tags,
      required this.liked,
      required this.likesCount,
      required this.commentCount});

  factory Post.fromJson(dynamic json) {
    final id = json["_id"] ?? json["id"] as String;
    final content = json["content"] as String;
    final media =
        List.from(json["media"]).map((e) => Media.fromJson(e)).toList();
    final public = json["public"] as bool;
    final user = PostUser.fromJson(json["user"]);
    final liked = json["liked"];
    final likesCount = json["likesCount"];
    final commentCount = json["commentCount"];
    final tags = json["tags"] == null
        ? emptyTagList
        : List.from(json["tags"]).map((e) => e as String).toList();

    return Post(
      id: id,
      content: content,
      media: media,
      public: public,
      tags: tags,
      user: user,
      liked: liked,
      likesCount: likesCount,
      commentCount: commentCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "media": media,
      "public": public,
      "tags": tags,
      "user": user,
      "liked": liked,
      "likesCount": likesCount,
      "commentCount": commentCount,
    };
  }
}

class PostUser {
  String name;
  String username;
  String? imageUrl;
  String? id;
  int? followers;

  PostUser({
    required this.name,
    required this.username,
    this.id,
    this.imageUrl,
    this.followers,
  });

  factory PostUser.fromJson(dynamic json) {
    log(json.toString());
    final name = json["name"] as String;
    final username = json["username"] as String;
    final imageUrl = json["imageUrl"];
    final followers = json["followers"];
    final id = json["_id"];

    return PostUser(
      name: name,
      username: username,
      imageUrl: imageUrl,
      followers: followers,
      id: id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "username": username,
      "imageUrl": imageUrl,
    };
  }
}

class PostUsersResponse {
  String message;
  bool success;
  List<PostUser> response;

  PostUsersResponse({
    required this.message,
    required this.success,
    required this.response,
  });

  factory PostUsersResponse.fromJson(dynamic json) {
    final message = json["message"] as String;
    final success = json["success"] as bool;
    final response = (json["response"] as List)
        .map((postUser) => PostUser.fromJson(postUser))
        .toList();

    return PostUsersResponse(
      message: message,
      success: success,
      response: response,
    );
  }
}
