// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/auth/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:outreach/screens/auth/username.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:outreach/widgets/styled_textfield.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPassword = TextEditingController();
  bool loading = false;

  void registerUserDB(String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('POST', Uri.parse(registerUser));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      ToastManager.showToast(
        'Account created successfully',
        context,
      );
      Get.to(() => const Username());
    } else {
      ToastManager.showToast(
        response.reasonPhrase!,
        context,
      );
    }
  }

  void createAcc() async {
    if (passwordController.text == confPassword.text) {
      setState(() {
        loading = true;
      });
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        final token = await credential.user!.getIdToken();
        registerUserDB(token!);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ToastManager.showToast(
            'The password provided is too weak.',
            context,
          );
        } else if (e.code == 'email-already-in-use') {
          ToastManager.showToast(
            'The account already exists for that email.',
            context,
          );
        }
      } catch (e) {
        ToastManager.showToast(
          e.toString(),
          context,
        );
      }
      setState(() {
        loading = false;
      });
    } else {
      ToastManager.showToast("Passwords doesn't match", context);
    }
  }

  Future<void> signUpWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
        final token = await userCredential.user!.getIdToken();
        registerUserDB(token!);
      } catch (e) {
        print(e);
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

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final token = await userCredential.user!.getIdToken();
      registerUserDB(token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                          "To proceed, please enter your name, password and confirm it.",
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
                    next: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StyledTextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Password",
                    next: true,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StyledTextField(
                    controller: confPassword,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Confirm Password",
                    next: false,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 8,
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
                              onTap: signUpWithGoogle,
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
                          onTap: createAcc,
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
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const Login()),
                              child: const Text(
                                "Sign In",
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
    );
  }
}
