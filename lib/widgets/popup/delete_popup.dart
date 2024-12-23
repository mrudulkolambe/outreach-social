import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/feed_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/widgets/styled_button.dart';

class DeleteConfirmPopup extends StatefulWidget {
  final String id;
  final String type;

  const DeleteConfirmPopup({super.key, required this.id, required this.type});

  @override
  State<DeleteConfirmPopup> createState() => _DeleteConfirmPopupState();
}

class _DeleteConfirmPopupState extends State<DeleteConfirmPopup> {
  final FeedService feedService = FeedService();
  bool loading = false;
  void handleDelete() async {
    setState(() {
      loading = true;
    });
    if (widget.type == "feed") {
      await feedService.deletePost(widget.id);
    }
    setState(() {
      loading = false;
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you sure you want to delete the post?. This process cannot be undone.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: handleDelete,
                              child: StyledButton(
                                loading: loading,
                                text: "Delete",
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: const StyledButton(
                                loading: false,
                                text: "Cancel",
                                filled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
