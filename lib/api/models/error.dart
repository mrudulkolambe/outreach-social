class ErrorState {
  String message;

  ErrorState({
    required this.message,
  });

  factory ErrorState.fromJson(dynamic json) {
    final String message = json["message"];
    return ErrorState(
      message: message,
    );
  }
}
