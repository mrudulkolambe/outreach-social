import 'dart:convert';
import 'dart:developer';

import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/models/call_request.dart';
import 'package:http/http.dart' as http;

class F {
  static Future<void> sendNotifications(String call_type, String to_token,
      String to_avatar, String to_name,String channel_id) async {
    CallRequestEntity callRequestEntity = CallRequestEntity(
      call_type: call_type,
      to_token: to_token,
      to_profile_image: to_avatar,
      to_name: to_name,
    );
    log("model Urls: ${callNoto + to_token}");
    log("model sendNotifications Area: ${callRequestEntity.toJson()}");
    try {
      final response = await http.post(
        Uri.parse(callNoto + to_token),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(callRequestEntity.toJson()),
      );
      log("on 30 sendNotifications response: ${response.body}");
      if (response.statusCode == 200) {
        print("sendNotifications success");
      } else if (response.statusCode == 404) {
        print("user Cancelled the call");
      } else {
        print("sendNotifications failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("sendNotifications error: $e");
    }
  }
}
