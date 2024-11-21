import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:http/http.dart' as http;

class AgoraChatConfig {
  static const String appKey = "411247955#1440028";

  //cloud Temp User ID Token hai
  static const String userId = "testone";

  //cloud Temp Token hai
  static const String agoraToken =
      "007eJxTYDibxnGzL5nZatP7goNmH58zz43eus+5T3nnHY15x5hXiM1VYEg0MTG1TDQwNjAzNzZJSrGwsDAwME5JSUsyMzM0TDFIuextn94QyMig8aaGgZGBFYgZGUB8FYYkA7Mk01RTA91EC0NLXUPD1DTdRHMjA13DNKPkxBRTixRjc1MAdzMnJg==";
}

class MyHomePagex extends StatefulWidget {
  const MyHomePagex({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePagex> createState() => _MyHomePagexState();
}

class _MyHomePagexState extends State<MyHomePagex> {
  ScrollController scrollController = ScrollController();
  String? _messageContent, _chatId;
  final List<String> _logText = [];

  @override
  void initState() {
    super.initState();
    _initSDK();
    _addChatListener();
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeEventHandler('UNIQUE_HANDLER_ID');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            const Text("login userId: ${AgoraChatConfig.userId}"),
            const Text("agoraToken: ${AgoraChatConfig.agoraToken}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _signIn,
                    child: const Text("SIGN IN"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: _signOut,
                    child: const Text("SIGN OUT"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: (){
                      createAgoraAccount(password: "123456", userName: "testone");
                    },
                    child: const Text("CREATE ACCOUNT"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter recipient's userId",
              ),
              onChanged: (chatId) => _chatId = chatId,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter message",
              ),
              onChanged: (msg) => _messageContent = msg,
            ),
            const SizedBox(height: 10),
            // TextButton(
            //   onPressed: _createAccount,
            //   child: const Text("SEND TEXT"),
            //   style: ButtonStyle(
            //     foregroundColor: MaterialStateProperty.all(Colors.white),
            //     backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
            //   ),
            // ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initSDK() async {
    ChatOptions options = ChatOptions(
      appKey: AgoraChatConfig.appKey,
      autoLogin: true,
    );
    await ChatClient.getInstance.init(options);
  }

  void _addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      'UNIQUE_HANDLER_ID',
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );

    ChatClient.getInstance.chatManager.addMessageEvent(
      'UNIQUE_HANDLER_ID',
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          _addLogToConsole("send message: $_messageContent");
        },
        onError: (msgId, msg, error) {
          _addLogToConsole(
            "send message failed, code: ${error.code}, desc: ${error.description}",
          );
        },
      ),
    );
  }

  void _signIn() async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        AgoraChatConfig.userId,
        AgoraChatConfig.agoraToken,
      );
      _addLogToConsole("login succeed, userId: ${AgoraChatConfig.userId}");
    } on ChatError catch (e) {
      _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void _signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      _addLogToConsole("sign out succeed");
    } on ChatError catch (e) {
      _addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void _sendMessage() async {
    if (_chatId == null || _messageContent == null) {
      _addLogToConsole("single chat id or message content is null");
      return;
    }

    var msg = ChatMessage.createTxtSendMessage(
      targetId: _chatId!,
      content: _messageContent!,
    );

    ChatClient.getInstance.chatManager.sendMessage(msg);
  }

  // void _createAccount() async {
  //   try {
  //     await ChatClient.getInstance.createAccount(
  //       AgoraChatConfig.userId,
  //       AgoraChatConfig.agoraToken,
  //     );
  //     _addLogToConsole("account creation succeed, userId: ${AgoraChatConfig.userId}");
  //   } on ChatError catch (e) {
  //     _addLogToConsole("account creation failed, code: ${e.code}, desc: ${e.description}");
  //   }
  // }

  Future<void> createAgoraAccount({
    required String userName,
    required String password,
  }) async {
    // Agora API endpoint
    const String apiUrl =
        'https://a41.chat.agora.io:443/411247955/1440028/users';

    // Replace with your Agora token
    const String token = 'YOUR_ACCESS_TOKEN';

    // Headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Request body
    final body = jsonEncode({
      'username': userName,
      'password': password,
    });

    try {
      // HTTP POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User registration successful: ${response.body}');
      } else {
        print(
            'User registration failed. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred during user registration: $e');
    }
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            _addLogToConsole(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
          }
          break;
        case MessageType.IMAGE:
          {
            _addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            _addLogToConsole(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            _addLogToConsole(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            _addLogToConsole(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            _addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            _addLogToConsole(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {}
          break;
        case MessageType.COMBINE:
        // TODO: Handle this case.
      }
    }
  }

  void _addLogToConsole(String log) {
    _logText.add(_timeString + ": " + log);
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}
