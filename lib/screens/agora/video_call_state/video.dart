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
                        top: 100,
                        right: 20,
                        width: 100,
                        height: 150,
                        child: AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: controller.engine,
                            canvas: VideoCanvas(uid: 0),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        right: 30,
                        left: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: controller.isJoined.value
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    child: controller.isJoined.value
                                        ? const Icon(
                                            Icons.call_end,
                                            color: Colors.white,
                                            size: 30,
                                          )
                                        : const Icon(
                                            Icons.call,
                                            color: Colors.white,
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
                      ),
                      controller.isShowAvatar.value
                          ? Positioned(
                              top: 200,
                              left: 30,
                              right: 30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(110),
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: NetworkImage(to_profile_image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      to_name!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
          );
        },
      ),
    );
  }
}
