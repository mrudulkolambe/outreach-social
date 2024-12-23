import 'dart:convert';
import 'dart:developer';

import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/resource.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/controller/resources.dart';
import 'package:outreach/utils/toast_manager.dart';

class ResourceServices {
  final ResourcesController resourcesController = ResourcesController();

  Future<List<ResourceCategory>> getResourceCategory() async {
    final response = await ApiService().get(getResourceCategoryAPI);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final resourceCategoryResponse =
          ResourceCategoriesResponse.fromJson(jsonDecode(response.body));
      return resourceCategoryResponse.response;
    } else {
      return [];
    }
  }

  Future<ResourcePost?> createPost(Map<String, dynamic> body) async {
    final response = await ApiService().post(createResourceFeedAPI, body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results = ResourcePostResponse.fromJson(jsonDecode(response.body));
      return results.feed;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }

  Future<int> deletePost(String id) async {
    final deletePost = await ApiService().delete('$deleteResourcefeedAPI/$id');
    log(deletePost!.body);
    if (deletePost.statusCode == 200) {
      // postController.deletePost(id);
      ToastManager.showToastApp("Post deleted successfully!");
      return 200;
    } else {
      ToastManager.showToastApp("Something went wrong");
      return 500;
    }
  }

  Future<ResourcePostsResponse?> getPosts({
    int page = 1,
    int limit = 10,
  }) async {
    final response =
        await ApiService().get('$getResourceFeedAPI?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      log(response.body);
      final results = ResourcePostsResponse.fromJson(jsonDecode(response.body));
      return results;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }

  Future<int> likeOnPost(ResourcePost post) async {
    print(post.id);
    final tempPost = ResourcePost(
      title: post.title,
      id: post.id,
      category: post.category,
      content: post.content,
      media: post.media,
      user: post.user,
      liked: post.liked ? false : true,
      likesCount: post.liked ? post.likesCount - 1 : post.likesCount + 1,
      commentCount: post.commentCount,
    );
    resourcesController.updatePost(tempPost);
    final updatedPost =
        await ApiService().patch('$likeResourceFeedAPI/${post.id}', {});
    if (updatedPost != null) {
      print(updatedPost.body);
      final updatedPostData =
          ResourcePostResponse.fromJson(jsonDecode(updatedPost.body));
      resourcesController.updatePost(updatedPostData.feed!);
      return 200;
    } else {
      ToastManager.showToastApp("Something went wrong");
      return 500;
    }
  }
}
