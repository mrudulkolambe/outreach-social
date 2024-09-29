// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/firebase_options.dart';
import 'package:outreach/screens/auth/login.dart';
import 'package:outreach/screens/auth/username.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/screens/onboarding.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ZIMKit().init(
    appID: 1326692995,
    appSign: "b692aa52fba5fcffb670e4f40af132ddc4668255866d687dfe8675bad2d19a2a",
  );
  runApp(const MyApp());
}

Future<bool> checkStoragePermission() async {
  var status = await Permission.storage.request();
  return status.isGranted;
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

  StreamSubscription<User?>? _authSubscription;

  Future<void> _isAuthed() async {
    try {
      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (!mounted) return;

        if (user != null) {
          await ZIMKit().requestPermission();
          final UserData? userData = await userService.currentUser();
          final zegoResult = await ZIMKit().connectUser(
            id: userData!.id,
            name: userData.username!,
            avatarUrl: userData.imageUrl!,
          );
          print("zegoResult, $zegoResult");
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
            Get.offAll(() => const MainStack());
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
    await Future.delayed(const Duration(seconds: 4));
    await _isAuthed();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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
