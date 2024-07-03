import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/upload.dart';
import 'package:outreach/api/services/api_services.dart';

class UploadServices {
  // Future<int> uploadSingleFile(File file, String path) async {}
  Future<MultiUploadResponse?> uploadMultipleFiles(
      List<File> files, String path) async {
    print("/");
    var request = http.MultipartRequest('POST', Uri.parse(multifileUpload));
    request.fields.addAll({'path': path});
    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final data = MultiUploadResponse.fromJson(jsonDecode(result));
      print(data);
      return data;
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }
}
