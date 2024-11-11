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

  void initAdd(List<ResourcePost> data) {
    print("Controller Data $data");
    resources = [];
    resources.addAll(data);
    update();
  }
}
