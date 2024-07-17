import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response?> get(String endpoint) async {
    final url = Uri.parse(endpoint);
    final token = 'Bearer ${await FirebaseAuth.instance.currentUser!.getIdToken(true)}';
    final response = await http.get(
      url,
      headers: {'Authorization': token},
    );
    return response;
  }

  Future<http.Response?> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    final response = await http.post(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${await FirebaseAuth.instance.currentUser!.getIdToken(true)}'
    });
    return response;
  }

  Future<http.Response?> patch(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    final response = await http.patch(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${await FirebaseAuth.instance.currentUser!.getIdToken(true)}'
    });
    return response;
  }
}
