import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/auth/profile_pic.dart';
import 'package:outreach/validators/name.dart';
import 'package:outreach/validators/username.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:outreach/widgets/styled_textfield.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  UserService userService = UserService();
  bool loading = false;
  void saveInfo() async {
    print("called");
    setState(() {
      loading = true;
    });
    final Map<String, String> body = {
      'username': usernameController.text,
      'name': nameController.text,
    };
    final status = await userService.updateUser({"updateData": body});
    if (status == 200) {
      Get.offAll(() => const ProfilePic());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          // key: UsernameFormKey,
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
                        Expanded(
                          child: Text(
                            "Tell us name & Create\nUsername",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "We're thrilled to have you onboard.",
                            style: TextStyle(fontSize: 16, color: grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    StyledTextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      hintText: "Name",
                      validator: nameValidator,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    StyledTextField(
                      controller: usernameController,
                      keyboardType: TextInputType.name,
                      hintText: "Username",
                      validator: usernameValidator,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "*User names must be 6-20 characters long, no uppercase, numbers, and underscores.",
                            style: TextStyle(
                              color: grey,
                              fontSize: 14,
                            ),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: saveInfo,
                            child: StyledButton(
                              loading: loading,
                              text: "Continue",
                            ),
                          ),
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
