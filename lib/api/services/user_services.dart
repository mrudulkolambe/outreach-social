import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/error.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/utils/toast_manager.dart';

class UserService {
  UserController userController = Get.put(UserController());

  Future<void> blockedUser() async {
    await FirebaseAuth.instance.signOut();
    // ToastManager.showToastApp("User blocked");
  }

  Future<UserData?> currentUser() async {
    final response = await ApiService().get(currentUserAPI);
    if (response != null) {
      log(response.body);
      if (response.statusCode == 200) {
        final data = UserResponse.fromJson(jsonDecode(response.body));
        userController.updateUser(data.user);
        return data.user;
      } else {
        print("test error ${response.reasonPhrase}");
        blockedUser();
      }
    } else {}
    return null;
  }

  Future<UserData?> getUserProfile(String id, String userId) async {
    final response = await ApiService().get("$getUserProfileAPI/$id/$userId");
    if (response != null) {
      if (response.statusCode == 200) {
        final data = UserResponse.fromJson(jsonDecode(response.body));
        return data.user;
      }
    } else {}
    return null;
  }

  Future<int> followUser(String userID, String id) async {
    final response = await ApiService().post("$followUserAPI/$userID/$id", {});
    if (response != null) {
      if (response.statusCode == 201) {
        return 200;
      } else {
        return 500;
      }
    } else {}
    return 500;
  }

  Future<int> updateUser(Map<String, dynamic> body) async {
    final response = await ApiService().patch(updateUserAPI, body);
    if (response != null && response.statusCode == 200) {
      final data = UserResponse.fromJson(jsonDecode(response.body));
      userController.updateUser(data.user);
      return 200;
    } else if (response != null && response.body.isNotEmpty) {
      final error = ErrorState.fromJson(jsonDecode(response.body));
      ToastManager.showToastApp(error.message);
    }
    return 500;
  }

  Future<void> createSupportRequest(Map<String, dynamic> body) async {
    final response = await ApiService().post(createSupportAPI, body);
    if (response != null && response.statusCode == 200) {
    } else {
      final error = ErrorState.fromJson(jsonDecode(response!.body));
      ToastManager.showToastApp(error.message);
    }
  }

  Future<List<UserData>?> getAllUsers() async {
    final response = await ApiService().get(allUsers);
    if (response != null && response.statusCode == 200) {
      final data = UsersResponse.fromJson(jsonDecode(response.body));
      return data.users;
    } else {
      final error = ErrorState.fromJson(jsonDecode(response!.body));
      ToastManager.showToastApp(error.message);
      return null;
    }
  }

  Future<List<UserData>?> searchUsers(String query) async {
    final response = await ApiService().get("$queryUsers?query=$query");
    if (response != null && response.statusCode == 200) {
      final data = UsersResponse.fromJson(jsonDecode(response.body));
      return data.users;
    } else {
      final error = ErrorState.fromJson(jsonDecode(response!.body));
      ToastManager.showToastApp(error.message);
      return null;
    }
  }

  Future<List<PostUser>?> globalSearch(String query, String user) async {
    final response =
        await ApiService().get("$globalSearchAPI?query=$query&user=$user");
    if (response != null && response.statusCode == 200) {
      final data = PostUsersResponse.fromJson(jsonDecode(response.body));
      return data.response;
    } else {
      final error = ErrorState.fromJson(jsonDecode(response!.body));
      ToastManager.showToastApp(error.message);
      return null;
    }
  }
}
