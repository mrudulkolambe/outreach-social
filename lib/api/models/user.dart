import 'package:outreach/models/post.dart';

class UserResponse {
  bool success;
  String message;
  UserData user;
  bool? error;

  UserResponse({
    required this.success,
    required this.message,
    required this.user,
    this.error,
  });

  factory UserResponse.fromJson(dynamic json) {
    final bool success = json["success"];
    final String message = json["message"];
    final UserData user = UserData.fromJson(json["response"]);
    final bool? error = json["error"];
    return UserResponse(
      success: success,
      message: message,
      user: user,
      error: error,
    );
  }
}

class UsersResponse {
  bool success;
  String message;
  List<UserData> users;
  bool? error;

  UsersResponse({
    required this.success,
    required this.message,
    required this.users,
    this.error,
  });

  factory UsersResponse.fromJson(dynamic json) {
    final bool success = json["success"];
    final String message = json["message"];
    final List<UserData> users = List.from(json["response"]).map((user) {
      return UserData.fromJson(user);
    }).toList();
    final bool? error = json["error"];
    return UsersResponse(
      success: success,
      message: message,
      users: users,
      error: error,
    );
  }
}

class UserData {
  String id;
  bool isProfileCompleted;
  String provider;
  bool login;
  String? name;
  String email;
  String? username;
  String? imageUrl;
  String? bio;
  List<String> interest;
  int? rewardPoints;
  bool block;
  List<Post> feeds;
  int? followers;
  int? following;
  bool? isFollowing;

  UserData({
    required this.id,
    required this.isProfileCompleted,
    required this.provider,
    required this.login,
    this.name,
    required this.email,
    this.username,
    this.imageUrl,
    this.bio,
    required this.interest,
    this.rewardPoints,
    required this.block,
    required this.feeds,
    this.followers,
    this.following,
    this.isFollowing,
  });

  factory UserData.fromJson(dynamic json) {
    final String id = json["_id"];
    final bool isProfileCompleted = json["isProfileCompleted"];
    final String provider = json["provider"];
    final bool login = json["login"];
    final String? name = json["name"];
    final String email = json["email"];
    final String? username = json["username"];
    final String? imageUrl = json["imageUrl"];
    final String? bio = json["bio"];
    final bool? isFollowing = json["isFollowing"];
    final List<String> interest =
        List.from(json["interest"]).map((e) => e.toString()).toList();
    final List<Post> feeds = json["feeds"] == null
        ? []
        : List.from(json["feeds"]).map((e) => Post.fromJson(e)).toList();
    final int? rewardPoints = json["rewardPoints"];
    final bool block = json["block"];
    final int? followers = json["followers"];
    final int? following = json["following"];

    return UserData(
      id: id,
      isProfileCompleted: isProfileCompleted,
      provider: provider,
      isFollowing: isFollowing,
      login: login,
      name: name,
      email: email,
      username: username,
      feeds: feeds,
      imageUrl: imageUrl,
      bio: bio,
      rewardPoints: rewardPoints,
      block: block,
      followers: followers,
      following: following,
      interest: interest,
    );
  }
}
