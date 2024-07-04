const String baseUrl = 'https://outreach-backend.vercel.app';
const String userEndpoint = '$baseUrl/user';

const String registerUser = '$userEndpoint/register';
const String currentUserAPI = '$userEndpoint/current-user';
const String updateUserAPI = '$userEndpoint/update';

const String supportEndpoint = '$baseUrl/support';

const String createSupportAPI = '$supportEndpoint/register';

const String feedEndpoint = '$baseUrl/feed';

const String createFeedAPI = '$feedEndpoint/create';
const String getFeedAPI = '$feedEndpoint/get';

const String forumEndpoint = '$baseUrl/forum';

const String createForumAPI = '$forumEndpoint/';
const String getForumAPI = '$forumEndpoint/';
const String joinForumAPI = '$forumEndpoint/join';
const String leaveForumAPI = '$forumEndpoint/leave';

const String forumPostEndpoint = '$forumEndpoint/forum-post';
const String getForumPostAPI = forumPostEndpoint;
const String createForumPostAPI = '$forumPostEndpoint/';

const String singlefileUpload = '$baseUrl/upload';
const String multifileUpload = '$baseUrl/multi-upload';
