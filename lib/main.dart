// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/agora_chat_service.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/firebase_options.dart';
import 'package:outreach/screens/auth/login.dart';
import 'package:outreach/screens/auth/username.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/screens/onboarding.dart';
import 'package:outreach/utils/firebasemsg_handler.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  fireBaseCallingNoto().whenComplete(() {
    FirebasemsgHandler.config();
  });
  await ChatClient.getInstance.init(
    ChatOptions(
      appKey: agoraAppID,
      autoLogin: true,
      debugModel: true,
    ),
  );
  runApp(const MyApp());
}

Future fireBaseCallingNoto() async {
  FirebaseMessaging.onBackgroundMessage(
    FirebasemsgHandler.firebaseMessagingBackground,
  );
  if (GetPlatform.isAndroid) {
    await FirebasemsgHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebasemsgHandler.channel_call);
  }
}

Future<bool> checkStoragePermission() async {
  var status = await [
    Permission.storage,
    Permission.camera,
    Permission.microphone
  ].request();
  return status.values.every((element) => element.isGranted);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Outreach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
        useMaterial3: true,
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final PostController postController = Get.put(PostController());
  final userService = UserService();
  final AgoraService _agoraService = AgoraService();
  UserController userController = Get.put(UserController());
  StreamSubscription<User?>? _authSubscription;

  Future<void> saveFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final Map<String, String> body = {
      'fcmToken': fcmToken!,
    };
    final status = await userService.updateUser({"updateData": body});
    if (status == 200) {
      log("FCM token saved $fcmToken");
    } else {
      log("FCM token not saved");
    }
  }

  Future<void> _initializeServices() async {
    try {
      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (!mounted) return;
        if (user != null) {
          final UserData? userData = await userService.currentUser();
          if (!mounted) return;

          if (userData == null) {
            userService.blockedUser();
          } else if (userData.username == "" ||
              userData.username == null ||
              userData.name == null ||
              userData.name == "") {
            ToastManager.showToast("Please fill the form first", context);
            Get.offAll(() => const Username());
          } else {
            final token = await user.getIdToken(true);
            try {
              await _agoraService.createAttribute(
                userName: userData.name!,
                userImage: userData.imageUrl!,
                cId: userData.id,
              );
              await _agoraService.loginToAgoraChat(userData.id, token);
              Get.offAll(() => const MainStack());
            } catch (e) {
              if (e.toString().contains("already logged in")) {
                Get.offAll(() => const MainStack());
              } else {
                log("Agora Chat login error: $e");
                ToastManager.showToast(
                    "Chat login failed. Please try again.", context);
              }
            } catch (e) {
              log("Agora Chat initialization error: $e");
            }
          }
        } else {
          Get.offAll(() => const OnBoarding());
        }
      });
    } catch (e) {
      if (!mounted) return;
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const Login());
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await saveFcmToken();
    await Future.delayed(const Duration(seconds: 4));
    await _initializeServices();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _agoraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Image.asset(
                "assets/main.gif",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
