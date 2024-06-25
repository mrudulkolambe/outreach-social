import 'dart:html' as html;
import 'dart:typed_data';

class WebMediaFiles {
  Uint8List file;
  String filename;
  String extension;

  WebMediaFiles({
    required this.file,
    required this.filename,
    required this.extension,
  });
}

Future<List<WebMediaFiles>> pickFilesPost() async {
  List<WebMediaFiles> mediaList = [];
  html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = "image/jpeg, image/jpg, image/png, video/mp4, video/quicktime"; // Include MOV files
  uploadInput.multiple = true;
  uploadInput.draggable = true;
  uploadInput.click();

  await uploadInput.onChange.first;
  final files = uploadInput.files;
  if (files != null && files.isNotEmpty) {
    for (var file in files) {
      final filename = file.name;
      final extension = extractExtension(filename);
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoadEnd.first;
      final data = Uint8List.fromList(reader.result as List<int>);
      mediaList.add(WebMediaFiles(file: data, filename: filename, extension: extension));
    }
  }
  return mediaList;
}
String extractExtension(String filename) {
  int dotIndex = filename.lastIndexOf('.');
  
  if (dotIndex != -1 && dotIndex < filename.length - 1) {
    String extensionWithDot = filename.substring(dotIndex);
    return extensionWithDot.substring(1);
  } else {
    return ''; 
  }
}
