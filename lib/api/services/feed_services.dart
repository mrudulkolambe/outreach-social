import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/utils/toast_manager.dart';

class FeedService {
  PostController postController = Get.put(PostController());

  Future<void> blockedUser() async {
    await FirebaseAuth.instance.signOut();
    ToastManager.showToastApp("User blocked");
  }

  Future<Post?> createFeed(Map<String, dynamic> body) async {
    final response = await ApiService().post(createFeedAPI, body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final createdPost = PostResponse.fromJson(jsonDecode(response.body));
      postController.addPosts(createdPost.post);
      return createdPost.post;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return null;
  }

  Future<PostsResponse?> getFeed({int page = 1, int limit = 10}) async {
    final response =
        await ApiService().get('$getFeedAPI?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final postsData = PostsResponse.fromJson(jsonDecode(response.body));
      return postsData;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return null;
  }

  Future<int> likeOnPost(Post post) async {
    final tempPost = Post(
        id: post.id,
        content: post.content,
        public: post.public,
        media: post.media,
        user: post.user,
        tags: post.tags,
        liked: post.liked ? false : true,
        likesCount: post.liked ? post.likesCount - 1 : post.likesCount + 1,
        commentCount: post.commentCount);
    postController.updatePost(tempPost);
    final updatedPost =
        await ApiService().patch('$likeStatusFeedAPI/${post.id}', {});
    if (updatedPost != null) {
      final updatedPostData =
          PostResponse.fromJson(jsonDecode(updatedPost.body));
      postController.updatePost(updatedPostData.post);
      return 200;
    } else {
      ToastManager.showToastApp("Something went wrong");
      return 500;
    }
  }
}
