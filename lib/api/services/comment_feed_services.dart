import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/services/api_services.dart';

class CommentFeedServices {
  Future<int> createComment(postID, body) async {
    final response =
        await ApiService().post('$createFeedCommentAPI/$postID', body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
      return 200;
    } else {
      return 500;
    }
  }
}
