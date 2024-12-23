import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:outreach/models/post.dart';
import 'package:get_storage/get_storage.dart';

class PostController extends GetxController {
  var posts = <Post>[];
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
    loadCachedPosts();
  }

  final List<Post> emptyPost = [];

  void loadCachedPosts() async {
    final cachedPosts = await box.read('posts1');
    if (cachedPosts != null) {
      final List<dynamic> decodedPosts = jsonDecode(cachedPosts);
      posts = decodedPosts
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      posts = emptyPost;
    }
    update();
  }

  void addPosts(Post data) {
    posts.add(data);
    update();
  }

  void addAllPosts(List<Post> data) {
    posts.addAll(data);
    update();
  }

  void initAddPosts(List<Post> data) {
    posts = [];
    posts.addAll(data);
    update();
  }

  void updatePost(Post data) {
    int index = posts.indexWhere((post) => post.id == data.id);
    if (index != -1) {
      posts[index] = data;
      update();
    }
  }

  void deletePost(String id) {
    int index = posts.indexWhere((post) => post.id == id);
    posts.removeAt(index);
    update();
  }
}
