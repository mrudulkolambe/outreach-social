import 'package:get/state_manager.dart';
import 'package:outreach/api/models/feed_comments.dart';

class FeedCommentController extends GetxController {
  var comments = <FeedComment>[];
  var forumFeedComments = <ForumFeedComment>[];

  @override
  void onClose() {
    forumFeedComments = [];
    comments = [];
    update();
    super.onClose();
  }

  void addComment(FeedComment data) {
    comments.add(data);
    update();
  }

  void initComment(List<FeedComment> commentsList) {
    print(commentsList.length);
    comments.addAll(commentsList);
    update();
  }

  void resetComments() {
    comments = [];
    update();
  }

  void addForumComment(ForumFeedComment data) {
    List<ForumFeedComment> tempList = [];
    tempList.addAll(forumFeedComments);
    tempList.add(data);
    tempList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    forumFeedComments = tempList;
    update();
  }

  void addAllForumComment(List<ForumFeedComment> data) {
    List<ForumFeedComment> tempList = [];
    tempList.addAll(forumFeedComments);
    tempList.addAll(data);
    tempList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    forumFeedComments = tempList;
    update();
  }

  void initForumComment(List<ForumFeedComment> commentsList) {
    commentsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    forumFeedComments = commentsList;
    update();
  }

  void resetForumComments() {
    forumFeedComments = [];
    update();
  }
}
