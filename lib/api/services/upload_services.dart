import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/upload.dart';

class UploadServices {
  Future<MultiUploadResponse?> uploadMultipleFiles(
      List<File> files, String path) async {
    var request = http.MultipartRequest('POST', Uri.parse(multifileUpload));
    request.fields.addAll({'path': path});
    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final data = MultiUploadResponse.fromJson(jsonDecode(result));
      return data;
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }

  Future<SingleUploadResponse?> uploadSingleFile(File file, String path) async {
    var request = http.MultipartRequest('POST', Uri.parse(singlefileUpload));
    request.fields.addAll({'path': path});
    request.files.add(await http.MultipartFile.fromPath('files', file.path));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final data = SingleUploadResponse.fromJson(jsonDecode(result));
      return data;
    } else {
      return null;
    }
  }

  Future<StoryUploadResponse?> storyUpload(File file, String path) async {
    var request = http.MultipartRequest('POST', Uri.parse(storyFileUpload));
    request.fields.addAll({'path': path});
    request.files.add(await http.MultipartFile.fromPath('files', file.path));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final data = StoryUploadResponse.fromJson(jsonDecode(result));
      return data;
    } else {
      return null;
    }
  }
}
