import 'package:outreach/models/post.dart';

class FeedCommentsResponse {
  bool success;
  String message;
  List<FeedComment> comments;

  FeedCommentsResponse({
    required this.success,
    required this.message,
    required this.comments,
  });

  factory FeedCommentsResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final comments = List.from(json["response"]).map((comment) {
      return FeedComment.fromJson(comment);
    }).toList();

    return FeedCommentsResponse(
      success: success,
      message: message,
      comments: comments,
    );
  }
}

class FeedCommentResponse {
  bool success;
  String message;
  FeedComment comment;

  FeedCommentResponse({
    required this.success,
    required this.message,
    required this.comment,
  });

  factory FeedCommentResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final comment = FeedComment.fromJson(json["response"]);

    return FeedCommentResponse(
      success: success,
      message: message,
      comment: comment,
    );
  }
}

class FeedComment {
  String text;
  PostUser author;
  int createdAt;
  String? parentID;
  String postID;

  FeedComment({
    required this.text,
    required this.author,
    required this.createdAt,
    required this.parentID,
    required this.postID,
  });

  factory FeedComment.fromJson(dynamic json) {
    final text = json["text"] as String;
    final author = PostUser.fromJson(json["author"]);
    final createdAt = json["createdAt"] as int;
    final parentID = json["parentID"];
    final postID = json["postID"] as String;

    return FeedComment(
      text: text,
      author: author,
      createdAt: createdAt,
      parentID: parentID,
      postID: postID,
    );
  }
}

class ForumFeedCommentsResponse {
  bool success;
  String message;
  int totalComments;
  int totalPages;
  int currentPage;
  List<ForumFeedComment> comments;

  ForumFeedCommentsResponse({
    required this.success,
    required this.message,
    required this.totalPages,
    required this.currentPage,
    required this.totalComments,
    required this.comments,
  });

  factory ForumFeedCommentsResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final comments = List.from(json["response"]["comments"]).map((comment) {
      return ForumFeedComment.fromJson(comment);
    }).toList();
    final totalComments = json["response"]["totalComments"] as int;
    final totalPages = json["response"]["totalPages"] as int;
    final currentPage = json["response"]["currentPage"] as int;

    return ForumFeedCommentsResponse(
      totalComments: totalComments,
      totalPages: totalPages,
      currentPage: currentPage,
      comments: comments,
      message: message,
      success: success,
    );
  }
}

class ForumFeedCommentResponse {
  bool success;
  String message;
  ForumFeedComment comment;

  ForumFeedCommentResponse({
    required this.success,
    required this.message,
    required this.comment,
  });

  factory ForumFeedCommentResponse.fromJson(dynamic json) {
    final success = json["success"] as bool;
    final message = json["message"] as String;
    final comment = ForumFeedComment.fromJson(json["response"]);

    return ForumFeedCommentResponse(
      success: success,
      message: message,
      comment: comment,
    );
  }
}

class ForumFeedComment {
  String text;
  PostUser author;
  int createdAt;
  bool liked;
  int likes;

  ForumFeedComment({
    required this.text,
    required this.author,
    required this.createdAt,
    required this.liked,
    required this.likes,
  });

  factory ForumFeedComment.fromJson(dynamic json) {
    print(json);
    final text = json["text"] as String;
    final author = PostUser.fromJson(json["author"]);
    final createdAt = json["createdAt"] as int;
    final liked = json["liked"] as bool;
    final likes = json["likesCount"] as int;

    return ForumFeedComment(
      text: text,
      author: author,
      createdAt: createdAt,
      liked: liked,
      likes: likes,
    );
  }
}
