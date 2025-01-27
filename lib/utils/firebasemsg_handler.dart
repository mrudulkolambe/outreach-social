import 'dart:developer';
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:outreach/firebase_options.dart';

class FirebasemsgHandler {
  FirebasemsgHandler._();

  static AndroidNotificationChannel channel_call =
      const AndroidNotificationChannel(
    'com.outreach.outreach_notification_channel_id',
    'Outreach Call Notification',
    importance: Importance.max,
    enableLights: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert'),
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print("initialMessage------");
        print(initialMessage);
      }
      var initializationSettingsAndroid =
          const AndroidInitializationSettings("ic_launcher");
      var darwinInitializationSettings = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: darwinInitializationSettings);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (details) async {
        if (details.payload != null) {
          final payloadData = jsonDecode(details.payload!);
          log("payloadData['toToken'] ${payloadData['toToken']}");
          log("payloadData['toToken'] ${payloadData['toName']}");
          log("payloadData['toToken'] ${payloadData['channelId']}");

          if (payloadData['type'] == 'call') {
            if (details.actionId == 'accept') {
              log("payloadData['toToken'] ${payloadData['toToken']}");
              log("payloadData['toToken'] ${payloadData['toName']}");
              log("payloadData['toToken'] ${payloadData['channelId']}");
              if (payloadData['callType'] == 'voice') {
              } else if (payloadData['callType'] == 'video') {}
            } else if (details.actionId == 'reject') {
              FirebasemsgHandler.flutterLocalNotificationsPlugin.cancel(0);
              // F.sendNotifications(
              //   "cancel",
              //   payloadData['toToken'],
              //   payloadData['toProfileImage'],
              //   payloadData['toName'],
              //   payloadData['channelId'],
              // );
            }
          }
        }
      });

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: false, badge: false, sound: false);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("\n notification on onMessage function \n");

        handleNotification(message);
      });
    } on Exception catch (e) {
      print("$e");
    }
  }

  static Future<void> handleNotification(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      _reserveNotification(message);
    }
  }

  static Future<Uint8List?> _getImageBytesFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    return null;
  }

  static Future _reserveNotification(RemoteMessage message) async {
    if (message.data['call_type'] != null) {
      var data = message.data;
      var toToken = data['to_token'];
      var toName = data['to_name'] ?? 'Unknown';
      var toProfileImage = data['to_profile_image'] ?? 'default_image_url';
      var channelId = data['channel_id'] ?? 'default_channel_id';

      if (toToken != null) {
        Uint8List? imageBytes = await _getImageBytesFromUrl(toProfileImage);
        final androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channel_call.id,
          channel_call.name,
          channelDescription: channel_call.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          sound: channel_call.sound,
          icon: '@mipmap/ic_launcher',
          largeIcon:
              imageBytes != null ? ByteArrayAndroidBitmap(imageBytes) : null,
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction(
              'reject',
              'Reject',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'accept',
              'Accept',
              showsUserInterface: true,
            ),
          ],
          timeoutAfter: 60000,
          fullScreenIntent: true,
          autoCancel: true,
        );

        final platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );

        String callType = data['call_type'];
        String notificationTitle =
            callType == 'voice' ? 'Incoming Voice Call' : 'Incoming Video Call';
        String notificationBody = 'Call from $toName';

        await flutterLocalNotificationsPlugin.show(
          0,
          notificationTitle,
          notificationBody,
          platformChannelSpecifics,
          payload: jsonEncode({
            'type': 'call',
            'callType': callType,
            'toToken': toToken,
            'toName': toName,
            'toProfileImage': toProfileImage,
            'channelId': channelId,
          }),
        );

        // Auto cancel call after 30 seconds if not answered
        // Future.delayed(const Duration(seconds: 50), () {
        // F.sendNotifications(
        //   "cancel",
        //   toToken,
        //   toProfileImage,
        //   toName,
        //   channelId,
        // );
        // flutterLocalNotificationsPlugin.cancel(0);
        // });
      }
    } else if (message.data['call_type'] == 'cancel') {
      FirebasemsgHandler.flutterLocalNotificationsPlugin.cancelAll();
      // FirebasemsgHandler.flutterLocalNotificationsPlugin.cancel(0);

      if (Get.currentRoute.contains("/VideoCallPage") ||
          Get.currentRoute.contains("/VoiceCallPage")) {
        Get.back();
        print("Get.currentRoute.isNotEmpty");
      }

      // flutterLocalNotificationsPlugin.show(
      //   0,
      //   'Call Ended',
      //   'The caller has ended the call',
      //   NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       channel_call.id,
      //       channel_call.name,
      //       channelDescription: channel_call.description,
      //       importance: Importance.max,
      //       priority: Priority.defaultPriority,
      //     ),
      //   ),
      // );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("message data: ${message.data}");
    print("message data: $message");
    print("message data: ${message.notification}");

    handleNotification(message);
  }
}
