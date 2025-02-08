// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/auth/interest.dart';
import 'package:outreach/screens/profile.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/styled_button.dart';

class Bio extends StatefulWidget {
  final bool update;
  final String bio;

  const Bio({super.key, required this.update, required this.bio});

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
  final TextEditingController bioController = TextEditingController();
  UserService userService = UserService();
  bool _loading = false;

  @override
  void initState() {
    bioController.text = widget.bio;
    super.initState();
  }

  void saveInfo() async {
    setState(() {
      _loading = true;
    });
    final statusCode = await userService.updateUser({
      "updateData": {"bio": bioController.value.text}
    });
    if (statusCode == 200 || statusCode == 201) {
      if (widget.update) {
        Get.offAll(() => const MyProfile());
      } else {
        Get.offAll(() => const InterestedIn(
              update: false,
              choosenInterest: [],
            ));
      }
    } else {
      ToastManager.showToast("Something went wrong!", context);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          // key: BioFormKey,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "Share your bio with us",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                        ),
                        if (!widget.update)
                          TextButton(
                            onPressed: () => Get.offAll(
                              () => const InterestedIn(
                                update: false,
                                choosenInterest: [],
                              ),
                            ),
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                color: grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
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
                            "Write about you...",
                            style: TextStyle(fontSize: 16, color: grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: bioController,
                      minLines: 5,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Write your bio",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: accent,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                              loading: _loading,
                              text: "Proceed",
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
