import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crypto/crypto.dart';

class VideoCallControlller extends GetxController {
  // RxString url = "".obs;
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeakerphone = true.obs;
  RxString callTime = "00:00".obs;
  RxString callStatus = 'Not Connected'.obs;

  RxString personalID = "".obs;
  // RxString personalProfileImage = "".obs;
  // RxString personalName = "".obs;

  RxString nextPersonID = "".obs;
  // RxString nextPersonName = "".obs;
  // RxString nextPersonPic = "".obs;

  RxString callerRole = "anchor ".obs;
  RxString uniqueChannelName = "".obs;
  RxBool isReadyPreview = false.obs;
  RxBool isShowAvatar = true.obs; //for user if no join show the avatar
  //camera for front and rear
  RxBool switchCamera = true.obs;

  RxInt onRemoteUID = 0.obs;

  late final RtcEngine engine;
  late final Timer calltimer;

  String AppId = agoraCallId;
  final player = AudioPlayer();

  bool is_calltimer = false;
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

  //Agora engine initialization
  Future<void> initEngine() async {
    await player.setAsset('assets/illustrations/ringtone.mp3');
    engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(
      appId: AppId,
    ));

    //Video Call engine event handler
    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print("Error on line 34: $err, $msg");
      },
      onJoinChannelSuccess: (rtcConnection, elapsed) async {
        print(
            "onJoinChannelSuccess: ${rtcConnection.toJson()}, this is the time $elapsed");
        isJoined.value = true;
        // await player.play();
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        onRemoteUID.value = remoteUid; // added
        isShowAvatar.value = false;

        await player.pause();
        startCallTimer();
        callStatus.value = "Connected";
      },
      onLeaveChannel: (connection, stats) {
        print("onLeaveChannel: ${connection.toJson()}, $stats");
        isJoined.value = false;
        onRemoteUID.value = 0; // added
        isShowAvatar.value = true; // added
        openMicrophone.value = false;
        stopCallTimer();
      },
      onRtcStats: (connection, stats) {
        print("onRtcStats: ${connection.toJson()}, $stats");
      },
    ));

    await engine.enableVideo(); // added video
    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
    await engine.startPreview();
    isReadyPreview.value = true;

    await joinChannel();

    if (callerRole.value == "anchor") {
      // F.sendNotifications(
      //   "video",
      //   nextPersonID.value,
      //   personalProfileImage.value,
      //   personalName.value,
      //   uniqueChannelName.value,
      // );
      await player.setLoopMode(LoopMode.all);
      await player.play();

      log("on Video Call Line 68: ${personalID.value} ${nextPersonID.value}");
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
    await Permission.camera.request();
    String clientNewID = await getCallToken();
    String? channelIdToken = await fetchTokenWithChannelID();

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

  ///

  Future<void> leaveChannel() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    switchCamera.value = true;
    await engine.stopLastmileProbeTest();
    await player.stop();
    Get.back();
    // sendNotificaiton for Video call cancel
    // isJoined.value = false;
    // openMicrophone.value = false;
    // isOpenSpeaker.value = false;
    // Get.back();
  }

  Future<void> switchCameraToggle() async {
    //toggle the video camera
    await engine.switchCamera();
    switchCamera.value = !switchCamera.value;
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
    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
