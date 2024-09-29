import 'dart:convert';

import 'package:get/get.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/controller/forum_post.dart';
import 'package:outreach/utils/toast_manager.dart';

class ForumServices {
  ForumPostController forumPostController = Get.put(ForumPostController());

  Future<int> createForum(Map<String, dynamic> body) async {
    final response = await ApiService().post(createForumAPI, body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      return 500;
    }
  }

  Future<List<Forum>?> getForums() async {
    final response = await ApiService().get(getForumAPI);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final forums = ForumResponse.fromJson(jsonDecode(response.body));
      return forums.forums;
    } else {
      return null;
    }
  }

  Future<int> joinForum(String forumID) async {
    final response = await ApiService().patch('$joinForumAPI/$forumID', {});
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      print(response!.reasonPhrase);
      return 500;
    }
  }

  Future<int> leaveForum(String forumID) async {
    final response = await ApiService().patch('$leaveForumAPI/$forumID', {});
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      print(response!.reasonPhrase);
      return 500;
    }
  }

  Future<ForumPostsResponse?> getForumPosts({
    int page = 1,
    int limit = 10,
    String forumID = "",
  }) async {
    final response = await ApiService()
        .get('$getForumPostAPI/$forumID?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results = ForumPostsResponse.fromJson(jsonDecode(response.body));
      return results;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }

  Future<ForumPost?> createForumPost(
      String forumID, Map<String, dynamic> body) async {
    final response =
        await ApiService().post('$createForumPostAPI/$forumID', body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results = ForumPostResponse.fromJson(jsonDecode(response.body));
      return results.forumPost;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }

  Future<int> likeOnPost(ForumPost post) async {
    final tempPost = ForumPost(
        id: post.id,
        content: post.content,
        public: post.public,
        media: post.media,
        user: post.user,
        liked: post.liked ? false : true,
        likesCount: post.liked ? post.likesCount - 1 : post.likesCount + 1,
        commentCount: post.commentCount);
    forumPostController.updatePost(tempPost);
    final updatedPost =
        await ApiService().patch('$likeStatusForumFeedAPI/${post.id}', {});
    if (updatedPost != null) {
      final updatedPostData =
          ForumPostResponse.fromJson(jsonDecode(updatedPost.body));
      forumPostController.updatePost(updatedPostData.forumPost!);
      return 200;
    } else {
      ToastManager.showToastApp("Something went wrong");
      return 500;
    }
  }
}
