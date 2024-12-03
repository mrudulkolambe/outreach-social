// const String baseUrl = 'https://2d4c-103-127-20-196.ngrok-free.app';
const String baseUrl = 'https://outreach-backend-development.vercel.app';
const String uploadBaseURL = "http://15.207.14.199:8080";

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

const String resourceCategoryEndpoint = '$baseUrl/resource-category';
const String getResourceCategoryAPI = '$resourceCategoryEndpoint/get';

const String resourceFeedEndpoint = '$baseUrl/resource';
const String getResourceFeedAPI = '$resourceFeedEndpoint/get';
const String createResourceFeedAPI = '$resourceFeedEndpoint/create';
const String likeResourceFeedAPI = '$resourceFeedEndpoint/like';

const String storyEndpoint = '$baseUrl/story';
const String shareStoryAPI = '$storyEndpoint/create';
const String getStoryAPI = '$storyEndpoint/get';
const String deleteStoryAPI = '$storyEndpoint/delete';

const String singlefileUpload = '$uploadBaseURL/upload';
const String multifileUpload = '$uploadBaseURL/multi-upload';
const String storyFileUpload = '$uploadBaseURL/story-upload';

const String allUsers = '$baseUrl/user/get';
const String queryUsers = '$baseUrl/user/search';


const String agoraChatTokenAPI = '$baseUrl/agora/chat/token';
const String agoraCallTokenAPI = '$baseUrl/agora/call/token'; 
const String callNoto= '$baseUrl/notification/fcm/send/';
const String messageNoto = '$baseUrl/notification/fcm/message/';

//Chat Config
const String agoraCallId = "911821326f584069b2c5fc4a36264ce1";
const String agoraCallToken = "007eJxTYAje9Or1ozWqJ7QWSL38Uh1y/Ltbqu4Zng+98teK24X/aKxTYEhJSbFMNDdJMU1LtDQxt0iyNDFMM7BMNLUwSDM3tkwyDch2Tm8IZGS4dO0oMyMDBIL4rAyJaeWJeQwMADe6Ik4=";

const String agoraAppID = "711253789#1445631";
const String agoraConfig = 'http://a71.chat.agora.io/711253789/1445631/users';
const String agoraMetaDataConfig = 'http://a71.chat.agora.io/711253789/1445631/metadata/user/';

const String AGROA_USER_PASSWORD = "com.outreach.social.password_for_user";