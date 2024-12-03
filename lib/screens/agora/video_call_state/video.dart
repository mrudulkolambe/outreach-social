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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: Obx(() {
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
                                      channelId:
                                          controller.uniqueChannelName.value),
                                ),
                              ),
                        Positioned(
                          top: 30,
                          right: 15,
                          child: SizedBox(
                            width: 80,
                            height: 120,
                            child: AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: controller.engine,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                            ),
                          ),
                        ),
                        controller.isShowAvatar.value
                            ? Container()
                            : Positioned(
                                top: 10,
                                left: 30,
                                right: 30,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "${controller.callTime.value}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ])),
                        controller.isShowAvatar.value
                            ? Positioned(
                                top: 10,
                                left: 30,
                                right: 30,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "${controller.callTime.value}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsets.only(top: 150),
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${to_profile_image}"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "${to_name}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    ]))
                            : Container(),
                        Positioned(
                            bottom: 80,
                            left: 30,
                            right: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(children: [
                                  GestureDetector(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: controller.isJoined.value
                                            ? Colors.red
                                            : Colors.blue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: controller.isJoined.value
                                          ? Icon(
                                              Icons.call,
                                              color: Colors.white,
                                            )
                                          : Icon(
                                              Icons.call_end,
                                              color: Colors.white,
                                            ),
                                    ),
                                    onTap: controller.isJoined.value
                                        ? controller.leaveChannel
                                        : controller.joinChannel,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      controller.isJoined.value
                                          ? "Disconnect"
                                          : "Connected",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ]),
                                Column(children: [
                                  GestureDetector(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: controller.switchCamera.value
                                            ? Colors.red
                                            : Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: controller.switchCamera.value
                                          ? Icon(Icons.cameraswitch_outlined,
                                              color: Colors.white)
                                          : Icon(Icons.cameraswitch,
                                              color: Colors.white),
                                    ),
                                    onTap: controller.switchCamera,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "switchCamera",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  )
                                ]),
                              ],
                            ))
                      ],
                    )
                  : Container());
        })));
  }
}
