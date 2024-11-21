// import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AgoraChatService {
//   static final AgoraChatService _instance = AgoraChatService._internal();
//   factory AgoraChatService() => _instance;
//   AgoraChatService._internal();

//   Future<void> initializeChat(String appKey) async {
//     try {
//       await ChatClient.getInstance.init(ChatOptions(
//         appKey: appKey,
//         autoLogin: false,
//       ));
//     } catch (e) {
//       print('Error initializing Agora Chat: $e');
//     }
//   }

//   Future<void> loginToAgoraChat() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) return;

//     try {
//       String agoraChatToken = await _getAgoraChatToken(currentUser.uid);

//       await ChatClient.getInstance.createAccount(
//         "673300018d31e183a7e1a702",
//         "007eJxTYLj1fFnyy50JU547srYbTd2wsSdvioLZ+l538/h31VsqFrIrMCSamJhaJhoYG5iZG5skpVhYWBgYGKekpCWZmRkaphikHHayT28IZGR4OGsFCyMDKwMjEIL4KgwmacZJFikpBrqJFoYmuoaGqWm6FiZphrqW5pap5qYWxibmZhYA16snrg==",
//       );
      

//       print('Logged into Agora Chat successfully');
//     } catch (e) {
//       print('Error logging into Agora Chat: $e');
//     }
//   }

//   Future<String> _getAgoraChatToken(String userId) async {
//     try {
//       String? firebaseToken =
//           await FirebaseAuth.instance.currentUser!.getIdToken(true);

//       return firebaseToken!;
//     } catch (e) {
//       print('Error getting token: $e');
//       rethrow;
//     }
//   }

//   Future<void> sendMessage(String receiverId, String messageContent) async {
//     try {
//       final message = ChatMessage.createTxtSendMessage(
//         targetId: receiverId,
//         content: messageContent,
//       );
//       await ChatClient.getInstance.chatManager.sendMessage(message);
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   Future<void> logout() async {
//     try {
//       await ChatClient.getInstance.logout();
//     } catch (e) {
//       print('Error logging out of Agora Chat: $e');
//     }
//   }
// }
