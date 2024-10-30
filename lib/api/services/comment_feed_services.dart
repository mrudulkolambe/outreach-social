import 'dart:convert';

import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/feed_comments.dart';
import 'package:outreach/api/services/api_services.dart';

class CommentFeedServices {
  Future<FeedComment?> createComment(postID, body) async {
    final response =
        await ApiService().post('$createFeedCommentAPI/$postID', body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final commentResponse =
          FeedCommentResponse.fromJson(jsonDecode(response.body));
      return commentResponse.comment;
    } else {
      return null;
    }
  }

  Future<List<FeedComment>> getPostComments(postID) async {
    final response = await ApiService().get('$createFeedCommentAPI/$postID');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final commentsResponse =
          FeedCommentsResponse.fromJson(jsonDecode(response.body));
      return commentsResponse.comments;
    } else {
      return [];
    }
  }

  // Forum Feed Comments
  Future<ForumFeedComment?> createForumComment(postID, body) async {
    final response =
        await ApiService().post('$createForumFeedCommentAPI/$postID', body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final commentResponse =
          ForumFeedCommentResponse.fromJson(jsonDecode(response.body));
      return commentResponse.comment;
    } else {
      return null;
    }
  }

  Future<ForumFeedCommentsResponse?> getForumPostsComments({
    int page = 1,
    int limit = 10,
    String postID = "",
  }) async {
    final response = await ApiService()
        .get('$getForumFeedCommentsAPI/$postID?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results =
          ForumFeedCommentsResponse.fromJson(jsonDecode(response.body));
      return results;
    } else {
      return null;
    }
  }
}
