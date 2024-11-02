import 'dart:convert';

import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/story.dart';
import 'package:outreach/api/services/api_services.dart';

class StoryServices {

  Future<int> createStory(Map<String, dynamic> body) async {
    final response = await ApiService().post(shareStoryAPI, body);
      print(response!.body);
    if (response != null && response.statusCode == 200 || response != null && response.statusCode == 201) {
      return 200;
    } else {
      return 500;
    }
  }
  Future<UserStoryResponse?> getUserStories() async {
    final response = await ApiService().get(getStoryAPI);
      print(response!.body);
    if (response != null && response.statusCode == 200 || response != null && response.statusCode == 201) {
      return UserStoryResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
