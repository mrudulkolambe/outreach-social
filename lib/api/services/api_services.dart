import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:outreach/controller/network.dart';

class ApiService {
  final NetworkController _networkController = Get.find<NetworkController>();

  Future<http.Response?> get(String endpoint) async {
    // if (!await _networkController.checkConnection()) {
    final url = Uri.parse(endpoint);
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    print(token);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
    // } else {
    //   return null;
    // }
  }

  Future<http.Response?> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    final response = await http.post(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${await FirebaseAuth.instance.currentUser!.getIdTokenResult().then((value) => value.token)}'
    });
    return response;
  }

  Future<http.Response?> patch(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    final response = await http.patch(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${await FirebaseAuth.instance.currentUser!.getIdTokenResult().then((value) => value.token)}'
    });
    return response;
  }
}
