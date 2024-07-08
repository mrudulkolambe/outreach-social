import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/screens/auth/login.dart';
import 'package:outreach/screens/help_support.dart';
import 'package:outreach/widgets/navbar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "More",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () => Get.to(() => const HelpAndSupport()),
                child: const ListTile(
                  title: Text("Help and Support"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const InkWell(
                child: ListTile(
                  title: Text("Privacy Policy"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const InkWell(
                child: ListTile(
                  title: Text("Terms and Conditions"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              const InkWell(
                child: ListTile(
                  title: Text("App updates"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => const Login());
                },
                child: const ListTile(
                  title: Text("Logout"),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
