const String baseUrl = 'https://outreach-backend-development.vercel.app';
// const String baseUrl = 'http://192.168.0.105:2000';
const String uploadBaseURL = "http://13.233.246.217:8080";

const String userEndpoint = '$baseUrl/user';

const String registerUser = '$userEndpoint/register';
const String currentUserAPI = '$userEndpoint/current-user';
const String getUserProfileAPI = '$userEndpoint/profile';
const String updateUserAPI = '$userEndpoint/update';
const String globalSearchAPI = '$userEndpoint/global/search';
const String followUserAPI = '$baseUrl/follow';

const String supportEndpoint = '$baseUrl/support';

const String createSupportAPI = '$supportEndpoint/register';

const String feedEndpoint = '$baseUrl/feed';

const String createFeedAPI = '$feedEndpoint/create';
const String getFeedAPI = '$feedEndpoint/get';
const String likeStatusFeedAPI = '$feedEndpoint/like';

const String forumEndpoint = '$baseUrl/forum';

const String createForumAPI = '$forumEndpoint/';
const String getForumAPI = '$forumEndpoint/';
const String joinForumAPI = '$forumEndpoint/join';
const String leaveForumAPI = '$forumEndpoint/leave';

const String forumPostEndpoint = '$forumEndpoint/forum-post';
const String getForumPostAPI = forumPostEndpoint;
const String createForumPostAPI = forumPostEndpoint;
const String likeStatusForumFeedAPI = '$forumPostEndpoint/like';

const String feedCommentEndpoint = '$baseUrl/feed-comment';
const String createFeedCommentAPI = feedCommentEndpoint;
const String getFeedCommentsAPI = feedCommentEndpoint;

const String forumFeedCommentEndpoint = '$baseUrl/forum-feed-comment';
const String createForumFeedCommentAPI = forumFeedCommentEndpoint;
const String getForumFeedCommentsAPI = forumFeedCommentEndpoint;

const String singlefileUpload = '$uploadBaseURL/upload';
const String multifileUpload = '$uploadBaseURL/multi-upload';

const String allUsers = '$baseUrl/user/get';
const String queryUsers = '$baseUrl/user/search';
