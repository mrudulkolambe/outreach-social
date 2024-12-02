import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/controller/video_call_controlller.dart';

class VideoCallPage extends GetView<VideoCallControlller> {
  final String? to_token;
  final String? to_name;
  final String? to_profile_image;
  final String? doc_id;
  final String? call_role;

  VideoCallPage({
    this.to_token,
    this.to_name,
    this.to_profile_image,
    this.doc_id,
    this.call_role,
  }) {
    Get.put(VideoCallControlller());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () {
          return Container(
            child: controller.isReadyPreview.value
                ? Stack(
                    children: [
                      controller.onRemoteUID.value == 0
                          ? Container()
                          : AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: controller.engine,
                                canvas: VideoCanvas(
                                    uid: controller.onRemoteUID.value),
                                connection: RtcConnection(
                                  channelId: controller.uniqueChannelName.value,
                                  localUid: controller.onRemoteUID.value,
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 80,
                        right: 30,
                        left: 30,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.isJoined.value
                                        ? controller.leaveChannel()
                                        : controller.joinChannel();
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    child: controller.isJoined.value
                                        ? const Icon(
                                            Icons.call_end,
                                            color: Colors.red,
                                            size: 30,
                                          )
                                        : const Icon(
                                            Icons.call,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    controller.isJoined.value
                                        ? "Disconnect"
                                        : "Connected",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Container(),
          );
        },
      ),
    );
  }
}
