import 'package:get/state_manager.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/models/post.dart';

class ForumPostController extends GetxController {
  var posts = <ForumPost>[];

  void addPosts(ForumPost data) {
    posts.add(data);
    update();
  }

  void addAllPosts(List<ForumPost> data) {
    posts.addAll(data);
    update();
  }

  void initAddPosts(List<ForumPost> data) {
    posts = [];
    posts.addAll(data);
    update();
  }

  void updatePost(ForumPost data) {
    int index = posts.indexWhere((post) => post.id == data.id);
    if (index != -1) {
      posts[index] = data;
      update();
    }
  }
}
