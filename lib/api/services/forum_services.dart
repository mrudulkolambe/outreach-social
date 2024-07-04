import 'dart:convert';

import 'package:http/http.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/forum.dart';
import 'package:outreach/api/services/api_services.dart';

class ForumServices {
  Future<int> createForum(Map<String, dynamic> body) async {
    final response = await ApiService().post(createForumAPI, body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      return 500;
    }
  }

  Future<List<Forum>?> getForums() async {
    final response = await ApiService().get(getForumAPI);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final forums = ForumResponse.fromJson(jsonDecode(response.body));
      return forums.forums;
    } else {
      return null;
    }
  }

  Future<int> joinForum(String forumID) async {
    final response = await ApiService().patch('$joinForumAPI/$forumID', {});
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      print(response!.reasonPhrase);
      return 500;
    }
  }

  Future<int> leaveForum(String forumID) async {
    final response = await ApiService().patch('$leaveForumAPI/$forumID', {});
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      print(response!.reasonPhrase);
      return 500;
    }
  }

  Future<List<ForumPost>?> getForumPosts(String forumID) async {
    print(('$getForumPostAPI/$forumID'));
    final response = await ApiService().get('$getForumPostAPI/$forumID');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results = ForumPostResponse.fromJson(jsonDecode(response.body));
      return results.forumPosts;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }
}
