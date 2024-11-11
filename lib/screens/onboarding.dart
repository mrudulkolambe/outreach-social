import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/auth/create_account.dart';
import 'package:outreach/screens/auth/login.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Connect",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const CreateAccount()),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "Share.",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: accent),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "Thrive.",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Your Health, Your Voice: Share \nAnonymously, Heal Openly.",
                          style: TextStyle(
                            fontSize: 16,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(child: Image.asset("assets/onboarding/onboarding1.png")),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12)
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p, vertical: 20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Stay",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: accent),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "Connected,",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: accent),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "Stay Healthy!",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: accent),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bringing Health to Your Fingertips: Join\nthe Movement with Outreach",
                          style: TextStyle(
                            fontSize: 16,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Image.asset("assets/onboarding/onboarding2.png"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const Login()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
