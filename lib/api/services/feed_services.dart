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
    if (response.statusCode == 200 || response.statusCode == 201) {
      final posts = await getFeed();
      postController.addAllPosts(posts);
      // final postData = PostResponse.fromJson(jsonDecode(response.body));
      // postController.addPosts(postData.post);
      // return postData.post;
      return null;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return null;
  }

  Future<List<Post>> getFeed() async {
    // Future<void> getFeed() async {
    final response = await ApiService().get(getFeedAPI);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final postsData = PostsResponse.fromJson(jsonDecode(response.body));
      return postsData.posts;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return [];
  }
}
