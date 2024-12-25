import 'dart:developer';

import 'package:get/state_manager.dart';
import 'package:outreach/api/models/resource.dart';

class ResourcesController extends GetxController {
  var resources = <ResourcePost>[];

  void add(ResourcePost data) {
    resources.add(data);
    update();
  }

  void addAll(List<ResourcePost> data) {
    resources.addAll(data);
    update();
  }

  void deletePost(String id) {
    int index = resources.indexWhere((post) => post.id == id);
    resources.removeAt(index);
    update();
  }

  void initAdd(List<ResourcePost> data) {
    print("Controller Data $data");
    resources = data;
    update();
  }

  void updatePost(ResourcePost data) {
    log(resources.toString());
    log(data.id.toString());
    log(resources.map((item) => item.id).toString());
    int index = resources.indexWhere((post) => post.id == data.id);
    print(index);
    if (index != -1) {
      resources[index] = data;
      update();
    }
  }
}
