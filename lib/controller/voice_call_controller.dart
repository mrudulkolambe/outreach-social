import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/controller/video_call_controlller.dart';
import 'package:outreach/utils/f.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallController extends GetxController {
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool isMuted = false.obs;
  RxBool isOpenSpeaker = true.obs;
  RxString callTime = "00:00".obs;
  RxString callStatus = 'Calling'.obs;

  RxString personalID = "".obs;
  RxString personalProfileImage = "".obs;
  RxString personalName = "".obs;

  RxString nextPersonID = "".obs;
  RxString nextPersonName = "".obs;
  RxString nextPersonPic = "".obs;

  RxString uniqueChannelName = "".obs;
  RxString callerRole = "anchor ".obs;

  String AppId = agoraCallId;
  final player = AudioPlayer();

  late final RtcEngine engine;
  Timer? _timer;
  int _seconds = 0;

  @override
  void onInit() {
    initEngine();
    super.onInit();
  }

  void startCallTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      final minutes = _seconds ~/ 60;
      final seconds = _seconds % 60;
      callTime.value =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  void stopCallTimer() {
    _timer?.cancel();
    _seconds = 0;
    callTime.value = "00:00";
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
      onJoinChannelSuccess: (rtcConnection, elapsed) async {
        print(
            "onJoinChannelSuccess: ${rtcConnection.toJson()}, this is the time $elapsed");
        isJoined.value = true;
        await player.play();
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        await player.pause();
        startCallTimer();
        callStatus.value = "Connected";
      },
      onUserOffline: (connection, remoteUid, reason) {
        print("onUserOffline: ${connection.toJson()}, $remoteUid, $reason");
        leaveChannel();
      },
      onLeaveChannel: (connection, stats) {
        print("onLeaveChannel: ${connection.toJson()}, $stats");
        isJoined.value = false;
        openMicrophone.value = false;
        stopCallTimer();
        Get.back();
      },
      onRtcStats: (connection, stats) {
        print("onRtcStats: ${connection.toJson()}, $stats");
      },
    ));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming);

    await joinChannel();

    if (callerRole.value == "anchor") {
      F.sendNotifications(
        "voice",
        nextPersonID.value,
        personalProfileImage.value,
        personalName.value,
        uniqueChannelName.value,
      );
      await player.setLoopMode(LoopMode.all);
      await player.play();

      log("on Line 68: ${personalID.value} ${nextPersonID.value}");
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
    await [Permission.camera, Permission.microphone].request();
    String clientNewID = await getCallToken();
    String? channelIdToken = await fetchTokenWithChannelID();

    if (channelIdToken != null) {
      log("on Line 98 ChannelID: ${clientNewID} ${personalID.value} ${nextPersonID.value} ${channelIdToken}");
      await engine.joinChannel(
        token: channelIdToken,
        channelId: clientNewID,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } else {
      log("Failed to fetch token for channel");
    }
  }

  void toggleSpeaker() {
    isOpenSpeaker.value = !isOpenSpeaker.value;
    engine.setEnableSpeakerphone(isOpenSpeaker.value);
  }

  void toggleMic() {
    openMicrophone.value = !openMicrophone.value;
    engine.enableLocalAudio(openMicrophone.value);
  }

  Future<void> leaveChannel() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await engine.stopLastmileProbeTest();
    await player.stop();
  }

  Future<void> _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
    super.dispose();
  }

  @override
  void onClose() {
    leaveChannel();
    // stopCallTimer();
    // isJoined.value = false;
    // openMicrophone.value = true;
    // isMuted.value = false;
    // isOpenSpeaker.value = true;
    // callTime.value = "00:00";
    // callStatus.value = 'Calling';

    // uniqueChannelName.value = "";
    // nextPersonID.value = "";
    // nextPersonName.value = "";
    // nextPersonPic.value = "";

    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
