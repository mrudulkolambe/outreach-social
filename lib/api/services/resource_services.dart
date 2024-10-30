import 'dart:convert';

import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/resource.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/controller/resources.dart';

class ResourceServices {
  final ResourcesController resourcesController = ResourcesController();

  Future<List<ResourceCategory>> getResourceCategory() async {
    final response = await ApiService().get(getResourceCategoryAPI);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final resourceCategoryResponse =
          ResourceCategoriesResponse.fromJson(jsonDecode(response.body));
      return resourceCategoryResponse.response;
    } else {
      return [];
    }
  }

  Future<ResourcePost?> createPost(Map<String, dynamic> body) async {
    final response = await ApiService().post(createResourceFeedAPI, body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results = ResourcePostResponse.fromJson(jsonDecode(response.body));
      return results.feed;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }

  Future<ResourcePostsResponse?> getPosts({
    int page = 1,
    int limit = 10,
  }) async {
    final response =
        await ApiService().get('$getResourceFeedAPI?page=$page&limit=$limit');
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      final results = ResourcePostsResponse.fromJson(jsonDecode(response.body));
      return results;
    } else {
      print(response!.reasonPhrase);
      return null;
    }
  }
}
