// lib/screens/upload_web.dart
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/utils/toast_manager.dart';

void uploadToFirebaseWebProfile() async {
  UserService userService = UserService();
  final userID = FirebaseAuth.instance.currentUser!.uid;
  html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = "image/*";
  uploadInput.multiple = false;
  uploadInput.draggable = true;
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        final filename = file.name;
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoadEnd.first;
        final data = Uint8List.fromList(reader.result as List<int>);
        final FirebaseStorage storage = FirebaseStorage.instance;
        TaskSnapshot uploadTask =
            await storage.ref().child("$userID/uploads/$userID-$filename").putData(data);
        String downloadUrl = await uploadTask.ref.getDownloadURL();
        final responseStatus = await userService.updateUser({
          "updateData": {"imageUrl": downloadUrl}
        });
        if (responseStatus == 200 || responseStatus == 201) {
          ToastManager.showToastApp("Profile updated");
        } else {
          ToastManager.showToastApp("Something went wrong");
        }

        print("File uploaded to: $downloadUrl");
      }
    }
  });
}
