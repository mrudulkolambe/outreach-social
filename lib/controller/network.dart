// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NetworkController extends GetxController {
//   final Connectivity _connectivity = Connectivity();
//   final RxBool isConnected = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _connectivity.onConnectivityChanged
//         .listen((event) => _updateConnectionStatus(event.first));
//   }

//   void _updateConnectionStatus(ConnectivityResult connectivityResult) {
//     if (connectivityResult == ConnectivityResult.none) {
//       isConnected.value = false;
//       Get.rawSnackbar(
//         messageText: const Text(
//           'Please connect to internet',
//           style: TextStyle(color: Colors.white),
//         ),
//         isDismissible: false,
//         duration: const Duration(days: 1),
//       );
//     } else {
//       isConnected.value = true;
//       if (Get.isSnackbarOpen) {
//         Get.closeCurrentSnackbar();
//       }
//     }
//   }

//   Future<bool> checkConnection() async {
//     var connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult.last != ConnectivityResult.none;
//   }
// }
