
import 'package:get/state_manager.dart';
import 'package:outreach/api/models/user.dart';

class UserController extends GetxController {
  UserData? userData;

  void updateUser(UserData user){
    userData = user;
    update();
  }
}
