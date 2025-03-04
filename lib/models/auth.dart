class SignInResponse {
  bool error;
  String message;
  String? token;

  SignInResponse({
    required this.error,
    required this.message,
    this.token,
  });

  factory SignInResponse.fromJson(dynamic json) {
    final error = json['error'] as bool;
    final message = json['message'] as String;
    final token = json['token'];
    return SignInResponse(
      error: error,
      message: message,
      token: token,
    );
  }
}

class UserDataResponse {
  bool error;
  String message;
  SUser user;

  UserDataResponse({
    required this.error,
    required this.message,
    required this.user,
  });

  factory UserDataResponse.fromJson(dynamic json) {
    final error = json['error'] as bool;
    final message = json['message'] as String;
    final user = SUser.fromJson(json['user']);
    return UserDataResponse(
      error: error,
      message: message,
      user: user,
    );
  }
}

class SUser {
  String fullname;
  String mobileno;
  String usecase;
  bool verified;
  String role;
  double wallet;
  double holdAmount;
  String image;

  SUser({
    required this.fullname,
    required this.mobileno,
    required this.usecase,
    required this.verified,
    required this.role,
    required this.wallet,
    required this.holdAmount,
    required this.image,
  });

  factory SUser.fromJson(dynamic json) {
    final fullname = json['fullname'] as String;
    final mobileno = json['mobileno'] as String;
    final usecase = json['usecase'] as String;
    final verified = json['verified'] as bool;
    final role = json['role'] as String;
    final wallet = json['wallet'] + 0.0;
    final holdAmount = json['holdAmount'] + 0.0;
    final image = json['image'];
    return SUser(
      fullname: fullname,
      mobileno: mobileno,
      usecase: usecase,
      verified: verified,
      role: role,
      wallet: wallet,
      holdAmount: holdAmount,
      image: image,
    );
  }
}
