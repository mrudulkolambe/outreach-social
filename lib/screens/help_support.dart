// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/help_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/home.dart';
import 'package:outreach/screens/main.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/styled_button.dart';
import 'package:outreach/widgets/styled_textfield.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool loading = false;
  HelpService helpService = HelpService();

  void submitReq() async {
    setState(() {
      loading = true;
    });
    final body = {
      "name": nameController.text,
      "email": emailController.text,
      "message": messageController.text,
      "contact": contactController.text
    };
    final statusCode = await helpService.createSupportRequest(body);
    if (statusCode == 200) {
      ToastManager.showToast("Request submitted", context);
      Get.offAll(() => MainStack());
    } else {
      ToastManager.showToast("Something went wrong!", context);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Help and Support",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "We always ready to help you from Monday until Friday on 09.00 AM until 05.00 PM. Contact us with this following contact",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                StyledTextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  hintText: "Name",
                  label: "Name",
                  next: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Email address",
                  label: "Email address",
                  next: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  hintText: "Contact Number",
                  label: "Contact Number",
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Text("Message:"),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 10,
                  controller: messageController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Message",
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
                InkWell(
                  onTap: submitReq,
                  child: StyledButton(
                    text: "Submit",
                    loading: loading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
