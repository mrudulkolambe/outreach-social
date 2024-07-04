import 'package:get/state_manager.dart';
import 'package:outreach/api/models/forum.dart';

class ForumController extends GetxController {
  var forums = <Forum>[];

  void addForum(Forum data) {
    forums.add(data);
    update();
  }

  void addAllForums(List<Forum> data) {
    forums.addAll(data);
    update();
  }

  void initAddForums(List<Forum> data) {
    forums = [];
    forums.addAll(data);
    update();
  }
}
