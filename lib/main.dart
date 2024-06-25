// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/screens/auth/username.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/screens/onboarding.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  BindingBase.debugZoneErrorsAreFatal = true;
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB0CLfKW9mg5xKtPrlGAUmBp8QM9SOXFM0",
        appId: "1:1055951057562:web:0e6d85df8ce9f8371be523",
        messagingSenderId: "1055951057562",
        projectId: "outreach-social",
        authDomain: "outreach-social.firebaseapp.com",
        storageBucket: "outreach-social.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

// Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
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
          Get.offAll(() => const HomePage());
        }
      } else {
        Get.offAll(() => const OnBoarding());
      }
    });
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
    _authSubscription
        ?.cancel();
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
            )
          ],
        ),
      ),
    );
  }
}
