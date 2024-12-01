import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/models/call_request.dart';
import 'package:outreach/utils/f.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallController extends GetxController {
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool isMuted = false.obs;
  RxBool isOpenSpeaker = true.obs;
  RxString callTime = "00.00".obs;
  RxString callStatus = 'Calling'.obs;

  RxString personalID = "".obs;
  RxString nextPersonID = "".obs;
  RxString nextPersonName = "".obs;
  RxString nextPersonPic = "".obs;

  RxString uniqueChannelName = "".obs;
  RxString callerRole = "anchor".obs;

  String AppId = agoraCallId;
  final player = AudioPlayer();

  late final RtcEngine engine;

  @override
  void onInit() {
    initEngine();
    super.onInit();
  }

  Future<String?> fetchTokenWithChannelID() async {
    final Map<String, dynamic> requestBody = {
      "channelName": uniqueChannelName.value,
      "uid": 0,
      "role": "publisher",
      "expirationTimeInSeconds": 3600,
    };

    try {
      final response = await http.post(
        Uri.parse(agoraCallTokenAPI),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['token'];
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null;
    }
  }

  Future<void> initEngine() async {
    await player.setAsset('assets/illustrations/ringtone.mp3');
    engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(
      appId: AppId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print("Error on line 34: $err, $msg");
      },
      onJoinChannelSuccess: (rtcConnection, elapsed) {
        print("onJoinChannelSuccess: ${rtcConnection.toJson()}, $elapsed");
        isJoined.value = true;
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        await player.pause();
      },
      onLeaveChannel: (connection, stats) {
        print("onLeaveChannel: ${connection.toJson()}, $stats");
        isJoined.value = false;
      },
      onRtcStats: (connection, stats) {
        print("onRtcStats: ${connection.toJson()}, $stats");
        print("On Line 49 ${stats.duration}");
      },
    ));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioDefault);

    await joinChannel();

    if (callerRole.value == "anchor") {
      F.sendNotifications("voice", nextPersonID.value, nextPersonPic.value,
          nextPersonName.value, uniqueChannelName.value);
      await player.setLoopMode(LoopMode.all);
      await player.play();
    }
  }

  Future<String> getCallToken() async {
    if (callerRole.value == "anchor") {
      uniqueChannelName.value = md5
          .convert(utf8.encode("${personalID.value}_${nextPersonID.value}"))
          .toString();
    } else {
      uniqueChannelName.value = md5
          .convert(utf8.encode("${nextPersonID.value}_${personalID.value}"))
          .toString();
    }
    return uniqueChannelName.value;
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();
    String clientNewID = await getCallToken();
    String? channelIdToken = await fetchTokenWithChannelID();

    log("on Line 98 ChannelID: ${clientNewID} ${personalID.value} ${nextPersonID.value} ${channelIdToken}");
    await engine.joinChannel(
      token: channelIdToken!,
      channelId: clientNewID,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  void leaveChannel() async {
    await player.pause();
    isJoined.value = false;
    // // PermissionStatus.denied;
    // await engine.leaveChannel();
    Get.back();
  }

  void _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
    super.dispose();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
