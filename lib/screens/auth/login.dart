// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:outreach/api/models/user.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/main.dart';
import 'package:outreach/screens/auth/create_account.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outreach/screens/auth/username.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:outreach/widgets/styled_textfield.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  UserService userService = UserService();

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

  void login() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print("credential $credential");
      final UserData? userData = await userService.currentUser();
      if (!mounted) return;

      if (userData == null) {
        // userService.blockedUser();
      } else if (userData.username == "" ||
          userData.username == null ||
          userData.name == null ||
          userData.name == "") {
        Get.offAll(() => const Username());
      } else {
        print("INIT");
        Get.offAll(() => const SplashScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ToastManager.showToast(
          'No user found for that email.',
          context,
        );
      } else if (e.code == 'wrong-password') {
        ToastManager.showToast(
          'Wrong password provided for that user.',
          context,
        );
      } else if (e.code == "invalid-email") {
        ToastManager.showToast(
          'Invalid Email',
          context,
        );
      } else if (e.code == "invalid-credential") {
        ToastManager.showToast(
          'Invalid credentials',
          context,
        );
      } else if (e.code == "missing-password") {
        ToastManager.showToast(
          'Missing password',
          context,
        );
      }
    } catch (e) {
      print(e);
      ToastManager.showToast(
        e.toString(),
        context,
      );
    }

    setState(() {
      loading = false;
    });
  }

  void resetPass() async {
    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      ToastManager.showToast("Invalid email", context);
    } else {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ToastManager.showToast("Password reset link sent to email", context);
    }
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      try {
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
        final UserData? userData = await userService.currentUser();

        if (!mounted) return;

        if (userData == null) {
          userService.blockedUser();
        } else if (userData.username == "" ||
            userData.username == null ||
            userData.name == null ||
            userData.name == "") {
          Get.offAll(() => const Username());
        } else {
          // final token =
          //     await FirebaseAuth.instance.currentUser?.getIdToken(true);
          await ZIMKit()
              .connectUser(id: userData.id, name: userData.username!)
              .then((value) {
            Get.offAll(() => const MainStack());
          });
        }
      } catch (e) {
        ToastManager.showToast(
          e.toString(),
          context,
        );
      }
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final UserData? userData = await userService.currentUser();

      if (!mounted) return;

      if (userData == null) {
        userService.blockedUser();
      } else if (userData.username == "" ||
          userData.username == null ||
          userData.name == null ||
          userData.name == "") {
        Get.offAll(() => const Username());
      } else {
        // final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
        await ZIMKit()
            .connectUser(id: userData.id, name: userData.username!)
            .then((value) {
          Get.offAll(() => const MainStack());
        });
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: loginFormKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hey,\nWelcome!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "To proceed, please enter your name & password.",
                            style: TextStyle(fontSize: 16, color: grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    StyledTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Email address",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StyledTextField(
                      controller: passwordController,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: "Password",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        InkWell(
                          enableFeedback: false,
                          splashColor: Colors.transparent,
                          onTap: resetPass,
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(color: accent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontal_p,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1.5,
                                    color: grey,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text("OR"),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.5,
                                    color: grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/facebook.svg",
                                height: 45,
                              ),
                              GestureDetector(
                                onTap: signInWithGoogle,
                                child: SvgPicture.asset(
                                  "assets/icons/google.svg",
                                  height: 45,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icons/apple.svg",
                                height: 42,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: login,
                            child: StyledButton(
                              text: "Continue",
                              loading: loading,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                onTap: () =>
                                    Get.to(() => const CreateAccount()),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
