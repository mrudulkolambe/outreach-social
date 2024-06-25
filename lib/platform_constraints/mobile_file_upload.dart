// mobile_file_upload.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:outreach/api/services/user_services.dart';
import 'dart:convert';
import 'package:outreach/models/cloudinary_upload.dart';

Future<void> uploadToCloudinaryMobile(File imageFile) async {
  final url = Uri.parse('https://api.cloudinary.com/v1_1/mrudul/image/upload');
  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'zgbpewne'
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
  final response = await request.send();
  await handleResponse(response);
}

Future<void> handleResponse(http.StreamedResponse response) async {
  UserService userService = UserService();
  if (response.statusCode == 200) {
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final jsonMap = jsonDecode(responseString);
    var data = CloudinaryUpload.fromJson(jsonMap);
    print(data.secureUrl);
    userService.updateUser({
      "updateData": {"imageUrl": data.secureUrl}
    });
  } else {
    print(response.reasonPhrase);
  }
}
