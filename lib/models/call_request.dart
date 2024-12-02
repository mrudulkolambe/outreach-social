// models/call_request.dart
class CallRequestEntity {
  final String call_type;
  final String to_token; 
  final String to_profile_image;
  final String to_name;
  final String channel_id;
  // final String caller_token;
  // final String caller_profile_image;
  // final String caller_name;

  CallRequestEntity({
    required this.call_type,
    required this.to_token,
    required this.to_profile_image, 
    required this.to_name,
    required this.channel_id,
    // required this.caller_token,
    // required this.caller_profile_image,
    // required this.caller_name,
  });

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "call_type": call_type,
        "to_token": to_token,
        "to_name": to_name,
        "to_profile_image": to_profile_image,
        "channel_id": channel_id,
        // "caller_token": caller_token,
        // "caller_profile_image": caller_profile_image,
        // "caller_name": caller_name,
      }
    };
  }
}