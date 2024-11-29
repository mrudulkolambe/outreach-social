// models/call_request.dart
class CallRequestEntity {
  final String call_type;
  final String to_token; 
  final String to_profile_image;
  final String to_name;

  CallRequestEntity({
    required this.call_type,
    required this.to_token,
    required this.to_profile_image, 
    required this.to_name,
  });

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "call_type": call_type,
        "to_token": to_token,
        "to_name": to_name,
        "to_profile_image": to_profile_image
      }
    };
  }
}