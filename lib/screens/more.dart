import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/screens/auth/login.dart';
import 'package:outreach/screens/help_support.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isLoggingOut = false;

  Future<void> handleLogout() async {
    if (_isLoggingOut) return; // Prevent multiple logout attempts

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // First try to logout from Agora
      try {
        /// de-initialization ZegoUIKitPrebuiltCallInvitationService
        /// when app's user is logged out
        ZegoUIKitPrebuiltCallInvitationService().uninit();
      } catch (e) {
        print("Agora logout error: $e");
        // Continue with Firebase logout even if Agora fails
      }

      // Then logout from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to login screen
      Get.offAll(() => const Login());
    } catch (e) {
      print("Logout error: $e");
      // Show error message if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error logging out. Please try again.")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                onTap: _isLoggingOut
                    ? null
                    : handleLogout, // Disable during logout
                child: ListTile(
                  title: const Text("Logout"),
                  trailing: _isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
