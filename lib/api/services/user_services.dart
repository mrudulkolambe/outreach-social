import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/error.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/utils/toast_manager.dart';

class UserService {

  UserController userController = Get.put(UserController());

  Future<void> blockedUser() async {
    await FirebaseAuth.instance.signOut();
    ToastManager.showToastApp("User blocked");
  }

  Future<UserData?> currentUser() async {
    final response = await ApiService().get(currentUserAPI);
    if (response.statusCode == 200) {
      final data = UserResponse.fromJson(jsonDecode(response.body));
      userController.updateUser(data.user);
      return data.user;
    } else {
      blockedUser();
    }
    return null;
  }

  Future<int> updateUser(Map<String, dynamic> body) async {
    final response = await ApiService().patch(updateUserAPI, body);
    if (response.statusCode == 200) {
      final data = UserResponse.fromJson(jsonDecode(response.body));
      userController.updateUser(data.user);
      return 200;
    } else {
      final error = ErrorState.fromJson(jsonDecode(response.body));
      ToastManager.showToastApp(error.message);
    }
    return 500;
  }

  Future<void> createSupportRequest(Map<String, dynamic> body) async {
    final response = await ApiService().post(createSupportAPI, body);
    if (response.statusCode == 200) {
    } else {
      final error = ErrorState.fromJson(jsonDecode(response.body));
      ToastManager.showToastApp(error.message);
    }
  }
}
