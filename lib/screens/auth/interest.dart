// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/models/interest.dart';
import 'package:outreach/screens/auth/congo.dart';
import 'package:outreach/screens/profile.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/interest/interest_choice.dart';
import 'package:outreach/widgets/styled_button.dart';

class InterestedIn extends StatefulWidget {
  final bool update;
  final List<String> choosenInterest;

  const InterestedIn(
      {super.key, required this.update, required this.choosenInterest});

  @override
  State<InterestedIn> createState() => _InterestedInState();
}

class _InterestedInState extends State<InterestedIn> {
  bool _loading = false;
  UserService userService = UserService();
  List<String> interests = []; // Ensure this is a mutable list

  void handleClick(String item) {
    if (interests.contains(item)) {
      interests.remove(item);
    } else {
      interests.add(item);
    }
    setState(() {}); // Update the state to reflect changes
  }

  @override
  void initState() {
    setState(() {
      if (widget.update) {
        interests = widget.choosenInterest;
      }
    });
    super.initState();
  }

  void saveInfo() async {
    setState(() {
      _loading = true;
    });
    final statusCode = await userService.updateUser({
      "updateData": {"interest": interests}
    });
    if (statusCode == 200 || statusCode == 201) {
      if (widget.update) {
        Get.offAll(() => const MyProfile());
      } else {
        Get.offAll(() => const Congo());
      }
    } else {
      ToastManager.showToast("Something went wrong!", context);
    }
    setState(() {
      _loading = false;
    });
  }

  final List<String> testing = [
    'Baby Foods',
    'Confectionery',
    'Coffee',
    'Packets & Units',
    'Packets & Units unis',
    'Processed Cheese',
    'Factional Care',
    'Sauce',
    'Sauc'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
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
                            "Tell us what you're\ninterested in ",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!widget.update)
                          TextButton(
                            onPressed: () => Get.to(() => const Congo()),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => handleClick(
                              interestsOptions[index].interest,
                            ),
                            child: InterestChoice(
                              interestType: interestsOptions[index],
                              selected: interests,
                            ),
                          );
                        },
                        itemCount: interestsOptions.length,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontal_p,
                      ),
                      child: SizedBox(
                        height: 56,
                        child: InkWell(
                          onTap: saveInfo,
                          child: StyledButton(
                            loading: _loading,
                            text: "Continue",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
