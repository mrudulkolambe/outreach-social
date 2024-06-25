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
    final posts =
        List.from(json["response"]).map((e) => Post.fromJson(e)).toList();

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
    final tags = json["tags"] == null ? emptyTagList : List.from(json["tags"]).map((e) => e as String).toList();

    return Post(
      content: content,
      media: media,
      public: public,
      tags: tags,
      user: user,
    );
  }
}

class Media {
  String url;
  String type;

  Media({
    required this.url,
    required this.type,
  });

  factory Media.fromJson(dynamic json) {
    final type = json["type"] as String;
    final url = json["url"] as String;

    return Media(
      url: url,
      type: type,
    );
  }
}

class PostUser {
  String name;
  String username;
  String imageUrl;

  PostUser({
    required this.name,
    required this.username,
    required this.imageUrl,
  });

  factory PostUser.fromJson(dynamic json) {
    final name = json["name"] as String;
    final username = json["username"] as String;
    final imageUrl = json["imageUrl"] as String;

    return PostUser(
      name: name,
      username: username,
      imageUrl: imageUrl,
    );
  }
}
