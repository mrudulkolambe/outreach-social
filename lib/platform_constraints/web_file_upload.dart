// import 'dart:html' as html;
// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';

// void uploadToFirebaseWeb()async {
//   html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//       uploadInput.accept = "image/*";
//       uploadInput.multiple = false;
//       uploadInput.draggable = true;
//       uploadInput.click();

//       uploadInput.onChange.listen((e) async {
//         final files = uploadInput.files;
//         if (files != null && files.isNotEmpty) {
//           for (var file in files) {
//             final reader = html.FileReader();
//             reader.readAsArrayBuffer(file);
//             await reader.onLoadEnd.first;
//             final data = Uint8List.fromList(reader.result as List<int>);
//             final FirebaseStorage storage = FirebaseStorage.instance;
//             TaskSnapshot uploadTask =
//                 await storage.ref().child("testfile").putData(data);
      
//           }
//         } 
//       });
// }