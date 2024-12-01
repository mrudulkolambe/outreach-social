import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response?> get(String endpoint) async {
    final url = Uri.parse(endpoint);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final token = 'Bearer ${await user.getIdToken(true)}';
    final response = await http.get(
      url,
      headers: {'Authorization': token},
    );
    print(token);
    return response;
  }

  Future<http.Response?> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final response = await http.post(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await user.getIdToken(true)}'
    });
    return response;
  }

  Future<http.Response?> patch(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    print('Bearer ${await user.getIdToken(true)}');
    print(url);
    final response = await http.patch(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await user.getIdToken(true)}'
    });
    return response;
  }
}
