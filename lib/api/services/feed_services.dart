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
    print(response);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final posts = await getFeed(page: 1, limit: 10);
      postController.initAddPosts(posts);
      return null;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return null;
  }

  Future<List<Post>> getFeed({int page = 1, int limit = 10}) async {
    print("From Get Feed Page $page $limit");
    final response =
        await ApiService().get('$getFeedAPI?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final postsData = PostsResponse.fromJson(jsonDecode(response.body));
      return postsData.posts;
    } else {
      ToastManager.showToastApp("Something went wrong");
    }
    return [];
  }
}
