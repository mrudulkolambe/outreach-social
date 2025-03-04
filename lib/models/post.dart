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

  PostsResponse(
      {required this.success,
      required this.message,
      required this.posts,
      required this.totalFeeds,
      required this.currentPage,
      required this.totalPages,
      });

  factory PostsResponse.fromJson(dynamic json) {
    print(json);
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
      currentPage: currentPage
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
  bool liked;

  Post(
      {required this.id,
      required this.content,
      required this.public,
      required this.media,
      required this.user,
      required this.tags,
      required this.liked,
      required this.likesCount});

  factory Post.fromJson(dynamic json) {
    final id = json["_id"] as String;
    final content = json["content"] as String;
    final media =
        List.from(json["media"]).map((e) => Media.fromJson(e)).toList();
    final public = json["public"] as bool;
    final user = PostUser.fromJson(json["user"]);
    final liked = json["liked"];
    final likesCount = json["likesCount"];
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
        likesCount: likesCount);
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
    print("POST USER");
    print(json);
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
