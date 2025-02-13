// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/zego_config.dart';
import 'package:outreach/controller/post.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/firebase_options.dart';
import 'package:outreach/screens/auth/login.dart';
import 'package:outreach/screens/auth/username.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/screens/onboarding.dart';
import 'package:outreach/utils/firebasemsg_handler.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/zego_notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase first
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    // Request necessary permissions
    await requestPermissions();
    
    // Initialize Firebase messaging and notifications
    await fireBaseCallingNoto();
    FirebasemsgHandler.config();

    // Initialize ZIMKit with proper error handling
    await initializeZIMKit();

    // Initialize Zego UI Kit
    await initializeZegoUIKit();

    // Initialize local notifications
    await NotificationManager().init();

    runApp(MyApp(navigatorKey: navigatorKey));
  } catch (e) {
    log("Error in main: $e");
    runApp(const ErrorApp());
  }
}

Future<void> requestPermissions() async {
  if (GetPlatform.isAndroid) {
    // Request overlay permission first
    if (!await Permission.systemAlertWindow.isGranted) {
      await Permission.systemAlertWindow.request();
    }
    
    // Request other necessary permissions
    await [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ].request();
  }
}

Future<void> initializeZIMKit() async {
  try {
    await ZIMKit().init(
      appID: ZegoConfig.appId,
      appSign: ZegoConfig.appSign,
      notificationConfig: ZegoZIMKitNotificationConfig(
        resourceID: 'outreach-zim',
        supportOfflineMessage: true,
        androidNotificationConfig: ZegoZIMKitAndroidNotificationConfig(
          channelID: 'outreach-zim',
          channelName: "outreach",
        ),
      ),
    );
    log("ZIMKit initialized successfully");
  } catch (e) {
    log("Error initializing ZIMKit: $e");
    rethrow;
  }
}

Future<void> initializeZegoUIKit() async {
  try {
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
    await ZegoUIKit().initLog();
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    log("Zego UI Kit initialized successfully");
  } catch (e) {
    log("Error initializing Zego UI Kit: $e");
    rethrow;
  }
}

Future<void> fireBaseCallingNoto() async {
  try {
    FirebaseMessaging.onBackgroundMessage(
      FirebasemsgHandler.firebaseMessagingBackground,
    );
    if (GetPlatform.isAndroid) {
      await FirebasemsgHandler.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(FirebasemsgHandler.channel_call);
    }
  } catch (e) {
    log("Error in fireBaseCallingNoto: $e");
    rethrow;
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing app. Please restart.'),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: widget.navigatorKey,
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final PostController postController = Get.put(PostController());
  final userService = UserService();
  UserController userController = Get.put(UserController());
  StreamSubscription<User?>? _authSubscription;

  Future<void> saveFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        final Map<String, String> body = {'fcmToken': fcmToken};
        final status = await userService.updateUser({"updateData": body});
        if (status == 200) {
          log("FCM token saved: $fcmToken");
        } else {
          log("FCM token not saved");
        }
      } else {
        log("FCM token is null or empty");
      }
    } catch (e) {
      log("Error saving FCM token: $e");
    }
  }

  Future<void> _initializeServices() async {
    try {
      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (!mounted) return;
        
        if (user != null) {
          try {
            final UserData? userData = await userService.currentUser();
            if (!mounted) return;

            if (userData == null) {
              await userService.blockedUser();
            } else if (userData.username == null ||
                userData.username!.isEmpty ||
                userData.name == null ||
                userData.name!.isEmpty) {
              ToastManager.showToast("Please fill the form first", context);
              Get.offAll(() => const Username());
            } else if (userData.username != null) {
              // Initialize ZIMKit user connection
              try {
                await ZIMKit().connectUser(id: userData.id, name: userData.username!);
                
                // Initialize Zego call service
                await ZegoUIKitPrebuiltCallInvitationService().init(
                  appID: ZegoConfig.appId,
                  appSign: ZegoConfig.appSign,
                  userID: userData.id,
                  userName: userData.username!,
                  plugins: [ZegoUIKitSignalingPlugin()],
                );
                
                Get.offAll(() => const MainStack());
              } catch (e) {
                log("Error initializing chat services: $e");
                ToastManager.showToast("Error initializing chat services", context);
              }
            }
          } catch (e) {
            log("Error processing user data: $e");
            ToastManager.showToast("Error loading user data", context);
          }
        } else {
          Get.offAll(() => const OnBoarding());
        }
      });
    } catch (e) {
      if (!mounted) return;
      log("Error in _initializeServices: $e");
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
    try {
      await Future.delayed(const Duration(seconds: 4));
      await _initializeServices();
      await saveFcmToken();
    } catch (e) {
      log("Error in _initialize: $e");
      if (mounted) {
        ToastManager.showToast("Error initializing app", context);
      }
    }
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
            Image.asset(
              "assets/main.gif",
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
