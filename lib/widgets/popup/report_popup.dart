import 'package:flutter/material.dart';
import 'package:outreach/api/services/report_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/utils/toast_manager.dart';
import 'package:outreach/widgets/button.dart';
import 'package:outreach/widgets/styled_button.dart';

class ReportPopup extends StatefulWidget {
  List<String> reasons;
  String type;
  String postId;
  String userID;

  ReportPopup({
    super.key,
    required this.reasons,
    required this.type,
    required this.postId,
    required this.userID,
  });
  @override
  _ReportPopupState createState() => _ReportPopupState();
}

class _ReportPopupState extends State<ReportPopup> {
  String selectedReason = "";
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;
  ReportServices reportServices = ReportServices();
  void handleReport() async {
    if (selectedReason.isEmpty) {
      ToastManager.showToast("Please select the reason", context);
    } else if (descriptionController.text.isEmpty) {
      ToastManager.showToast("Please enter the description", context);
    } else {
      setState(() {
        loading = true;
      });
      await reportServices.createReport({
        "user": widget.userID,
        "post": widget.postId,
        "description": descriptionController.text,
        "title": selectedReason,
        "type": widget.type
      });
      setState(() {
        selectedReason = "";
        descriptionController.text = "";
        loading = false;
      });
      Navigator.pop(context);
    }
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
                // height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
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
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Report',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Are you sure you want to report the post?',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select the reason',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...widget.reasons.asMap().entries.map((reason) {
                        return Column(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => accent.withOpacity(0.2),
                                ),
                                shadowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent,
                                ),
                                shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedReason = reason.value;
                                });
                              },
                              child: Text(
                                reason.value,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: reason.value == selectedReason
                                        ? accent
                                        : Colors.black.withOpacity(0.3)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Write description"),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: 10,
                          controller: descriptionController,
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: loading ? () {} : handleReport,
                            child: StyledButton(
                              text: "Report",
                              loading: loading,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const CustomButton(text: "Cancel"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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
