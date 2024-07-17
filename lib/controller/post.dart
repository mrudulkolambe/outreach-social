import 'package:get/state_manager.dart';
import 'package:outreach/models/post.dart';

class PostController extends GetxController {
  var posts = <Post>[];

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

}
