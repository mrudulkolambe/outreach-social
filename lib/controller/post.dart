import 'package:get/state_manager.dart';
import 'package:outreach/models/post.dart';

class PostController extends GetxController {
  var posts = <Post>[];

  void addPosts(Post data) {
    posts.add(data);
    update();
  }
  void addAllPosts(List<Post> data) {
    posts = [];
    posts.addAll(data);
    update();
  }
}
