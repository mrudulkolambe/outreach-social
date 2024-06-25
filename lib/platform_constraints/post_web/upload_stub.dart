// lib/platform_constraints/post_web/upload_stub.dart
import 'dart:typed_data';

class WebMediaFiles {
  final Uint8List file;
  final String filename;
  final String extension;

  WebMediaFiles({required this.file, required this.filename, required this.extension});
}

Future<List<WebMediaFiles>> pickFilesPost() async {
  throw UnsupportedError("This function is only supported on the web.");
}
