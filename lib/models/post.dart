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

  PostsResponse({
    required this.success,
    required this.message,
    required this.posts,
  });

  factory PostsResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final posts = json["response"] == [] || json["response"] == null
        ? emptyPost
        : List.from(json["response"]).map((e) => Post.fromJson(e)).toList();

    return PostsResponse(
      success: success,
      message: message,
      posts: posts,
    );
  }
}

final List<String> emptyTagList = [];

class Post {
  String content;
  List<Media> media;
  bool public;
  PostUser user;
  List<String> tags;

  Post({
    required this.content,
    required this.public,
    required this.media,
    required this.user,
    required this.tags,
  });

  factory Post.fromJson(dynamic json) {
    final content = json["content"] as String;
    final media =
        List.from(json["media"]).map((e) => Media.fromJson(e)).toList();
    final public = json["public"] as bool;
    final user = PostUser.fromJson(json["userId"]);
    final tags = json["tags"] == null
        ? emptyTagList
        : List.from(json["tags"]).map((e) => e as String).toList();

    return Post(
      content: content,
      media: media,
      public: public,
      tags: tags,
      user: user,
    );
  }
}

class PostUser {
  String name;
  String username;
  String? imageUrl;

  PostUser({
    required this.name,
    required this.username,
    this.imageUrl,
  });

  factory PostUser.fromJson(dynamic json) {
    final name = json["name"] as String;
    final username = json["username"] as String;
    final imageUrl = json["imageUrl"];

    return PostUser(
      name: name,
      username: username,
      imageUrl: imageUrl,
    );
  }
}
