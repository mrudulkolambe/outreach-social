import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/controller/video_call_controlller.dart';
import 'package:outreach/controller/voice_call_controller.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  final String? to_token;
  final String? to_name;
  final String? to_profile_image;
  final String? doc_id;
  final String? call_role;

  VoiceCallPage({
    this.to_token,
    this.to_name,
    this.to_profile_image,
    this.doc_id,
    this.call_role,
  }) {
    Get.put(VoiceCallController());
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () {
          return Container(
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.callTime.value}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(to_profile_image!),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "$to_name",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${controller.callStatus.value}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'micButton',
                        onPressed: controller.toggleMic,
                        backgroundColor: controller.openMicrophone.value
                            ? Colors.green
                            : Colors.grey,
                        child: Icon(
                          controller.openMicrophone.value
                              ? Icons.mic
                              : Icons.mic_off,
                          color: Colors.white,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'callButton',
                        onPressed: controller.isJoined.value
                            ? () {
                                controller.leaveChannel();
                                Get.back();
                              }
                            : controller.joinChannel,
                        backgroundColor: controller.isJoined.value
                            ? Colors.red
                            : Colors.green,
                        child: Icon(
                          controller.isJoined.value
                              ? Icons.call_end
                              : Icons.call,
                          color: Colors.white,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'speakerButton',
                        onPressed: controller.toggleSpeaker,
                        backgroundColor: controller.isOpenSpeaker.value
                            ? Colors.green
                            : Colors.grey,
                        child: Icon(
                          controller.isOpenSpeaker.value
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
