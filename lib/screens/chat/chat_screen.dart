import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/media_service.dart';
import 'package:ticket_resell/services/storage_service.dart';
import 'package:ticket_resell/utils.dart';

import 'chat_message_item.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile chatUser;

  const ChatScreen({
    super.key,
    required this.chatUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SafeArea(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(8),
  //             height: 85,
  //             color: Colors.white,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 BackButton(),
  //                 SizedBox(width: 5),
  //                 CircleAvatar(
  //                   backgroundImage: AssetImage("assets/users/Jones Noa.jpg"),
  //                   maxRadius: 28,
  //                 ),
  //                 SizedBox(width: 20,),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text("Jones Noa",
  //                     style: TextStyle(
  //                       fontSize: 19,
  //                       fontWeight: FontWeight.bold
  //                     ),),
  //                     SizedBox(height: 8),
  //                     Text("Ative 5 hours ago",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500,
  //                         color: Colors.grey.shade500
  //                       ),),
  //                   ],
  //                 ),
  //                 Spacer(),
  //                 IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
  //               ],
  //             ),
  //           ),
  //           Expanded(child: Container(
  //             color: Colors.grey.shade200,
  //             child: ListView(
  //               padding: EdgeInsets.all(15),
  //               scrollDirection: Axis.vertical,
  //               shrinkWrap: true,
  //               children: [
  //                 Align(
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     "Today",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.grey
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 20),
  //                 ChatMessageItem(isMeChatting: false, messageBody: "Hi, Jones Noa, How are you?"),
  //                 ChatMessageItem(isMeChatting: true, messageBody: "I am fines"),
  //                 ChatMessageItem(isMeChatting: false, messageBody: "Congratulations for 10+ Followers on Frodo"),
  //                 ChatMessageItem(isMeChatting: true, messageBody: "Oh thank you very much. I am working hard on it, so i can drive this ship in days"),
  //                 ChatMessageItem(isMeChatting: false, messageBody: "Great, I hope you can do more than that"),
  //                 ChatMessageItem(isMeChatting: true, messageBody: "Thanks"),
  //
  //               ],
  //             ),
  //           ))
  //         ],
  //       ),
  //     ),
  //     bottomNavigationBar: Container(
  //       height: 70,
  //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(13),
  //       ),
  //       child: Container(
  //         child: Row(
  //           children: [
  //             Expanded(child: TextField(
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 hintText: "Type something...",
  //                 hintStyle: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.blueAccent
  //                 ),
  //               ),
  //               maxLines: 10,
  //               minLines: 1,
  //             ),
  //             ),
  //             SizedBox(width: 20),
  //             InkWell(
  //               onTap: () {},
  //               hoverColor: Colors.white,
  //               child: Container(
  //                 width: 50,
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                   color: Colors.blueAccent,
  //                   borderRadius: BorderRadius.circular(13)
  //                 ),
  //                 alignment: Alignment.center,
  //                 child: Icon(
  //                   Icons.send_rounded,
  //                   color: Colors.white,
  //                   size: 25,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatUser.name!,
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
      stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
      builder: (context, snapshot) {
        Chat? chat = snapshot.data?.data();
        List<ChatMessage> messages = [];
        if (chat != null && chat.messages != null) {
          messages = _generateChatMessagesList(
            chat.messages!,
          );
        }
        return DashChat(
          messageOptions: const MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true,
          ),
          inputOptions: InputOptions(
            alwaysShowSend: true,
            trailing: [
              _mediaMessageButton(),
            ],
          ),
          currentUser: currentUser!,
          onSend: _sendMessage,
          messages: messages,
        );
      },
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: chatMessage.user.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
          isRead: false,
        );
        await _databaseService.sendChatMessage(
            currentUser!.id, otherUser!.id, message);
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
        isRead: false,
      );
      await _databaseService.sendChatMessage(
        currentUser!.id,
        otherUser!.id,
        message,
      );
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          createdAt: m.sentAt!.toDate(),
          medias: [
            ChatMedia(
              url: m.content!,
              fileName: "",
              type: MediaType.image,
            ),
          ],
        );
      } else {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          String chatID = generateChatID(
            uid1: currentUser!.id,
            uid2: otherUser!.id,
          );
          String? downloadURL = await _storageService.uploadImageToChat(
              file: file, chatID: chatID);
          if (downloadURL != null) {
            ChatMessage chatMessage = ChatMessage(
                user: currentUser!,
                createdAt: DateTime.now(),
                medias: [
                  ChatMedia(
                      url: downloadURL, fileName: "", type: MediaType.image)
                ]);
            _sendMessage(chatMessage);
          }
        }
      },
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
