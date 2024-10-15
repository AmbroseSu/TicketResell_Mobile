//
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:ticket_resell/models/message.dart';
// import 'package:ticket_resell/models/user_profile.dart';
//
// class ChatTile extends StatefulWidget {
//   final UserProfile userProfile;
//   final Function onTap;
//
//   const ChatTile({
//     super.key,
//     required this.userProfile,
//     required this.onTap,
//   });
//
//   @override
//   State<ChatTile> createState() => _ChatTileState();
// }
//
//
// class _ChatTileState extends State<ChatTile> {
//
//   ChatUser? currentUser, otherUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         onTap();
//       },
//       dense: false,
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(
//           userProfile.pfpURL!,
//         ),
//       ),
//       title: Text(
//         userProfile.name!,
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   ChatMessage? _getLatestChatMessage(List<Message> messages) {
//     // Tìm tin nhắn gần nhất
//     Message? latestMessage;
//
//     for (var message in messages) {
//       if (latestMessage == null ||
//           message.sentAt!.toDate().isAfter(latestMessage.sentAt!.toDate())) {
//         latestMessage = message;
//       }
//     }
//
//     if (latestMessage == null) {
//       return null; // Không có tin nhắn nào
//     }
//
//     // Tạo ChatMessage từ tin nhắn gần nhất
//     if (latestMessage.messageType == MessageType.Image) {
//       return ChatMessage(
//         user: latestMessage.senderID == currentUser!.id ? currentUser! : otherUser!,
//         createdAt: latestMessage.sentAt!.toDate(),
//         medias: [
//           ChatMedia(
//             url: latestMessage.content!,
//             fileName: "",
//             type: MediaType.image,
//           ),
//         ],
//       );
//     } else {
//       return ChatMessage(
//         user: latestMessage.senderID == currentUser!.id ? currentUser! : otherUser!,
//         text: latestMessage.content!,
//         createdAt: latestMessage.sentAt!.toDate(),
//       );
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';

class ChatTile extends StatefulWidget {
  final UserProfile userProfile;
  final Function onTap;
  final List<Message> messages; // Thêm danh sách tin nhắn

  const ChatTile({
    super.key,
    required this.userProfile,
    required this.onTap,
    required this.messages, // Nhận danh sách tin nhắn
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late DatabaseService _databaseService;
  ChatUser? currentUser, otherUser;
  Message? latestMessage;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    otherUser = ChatUser(
      id: widget.userProfile.uid!,
      firstName: widget.userProfile.name,
      profileImage: widget.userProfile.pfpURL,
    );

  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot<Chat>>(
      stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Hiển thị giao diện chờ khi chưa có dữ liệu
        }

        Chat? chat = snapshot.data?.data();
        if (chat == null || chat.messages == null) {
          return ListTile(
            onTap: () {
              widget.onTap();
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.userProfile.pfpURL!,
              ),
            ),
            title: Text(
              widget.userProfile.name!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "No messages yet", // Nếu không có tin nhắn nào
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // Gọi hàm để lấy tin nhắn gần nhất từ danh sách
        Message? latestMessage = _getLatestMessageFromList(chat.messages!);
        print("0000000000000000000000000000111111111111111111111111111111111111111111111111");
        print(latestMessage!.isRead);
        print(latestMessage.senderID);
        print(otherUser!.id);
        print(currentUser!.id);

        int unreadCount = _getUnreadMessageCount(chat.messages!, otherUser!.id);
        return ListTile(
          onTap: () {
            widget.onTap();
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              widget.userProfile.pfpURL!,
            ),
          ),
          title: Text(
            widget.userProfile.name!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: latestMessage != null
          //     ? Text(
          //   latestMessage.content ?? "Image message", // Hiển thị tin nhắn gần nhất
          //   style: TextStyle(color: (latestMessage.senderID == currentUser!.id)
          //       ? Colors.grey  // Tin nhắn của currentUser không bao giờ in đậm
          //       : (latestMessage.isRead ? Colors.grey : Colors.black),
          //     fontWeight: (latestMessage.senderID == currentUser!.id)
          //         ? FontWeight.normal  // Tin nhắn của currentUser không bao giờ in đậm
          //         : (latestMessage.isRead ? FontWeight.normal : FontWeight.bold), // In đậm nếu tin nhắn chưa đọc
          //   ),
          //   maxLines: 1, // Chỉ hiển thị 1 dòng
          //   overflow: TextOverflow.ellipsis,
          // )
              ? Row(
            children: [
              Expanded(
                child: Text(
                  latestMessage.content ?? "Image message", // Hiển thị tin nhắn gần nhất
                  style: TextStyle(
                    color: (latestMessage.senderID == currentUser!.id)
                        ? Colors.grey // Tin nhắn của currentUser không bao giờ in đậm
                        : (latestMessage.isRead
                        ? Colors.grey
                        : Colors.red),
                    fontWeight:
                    (latestMessage.senderID == currentUser!.id)
                        ? FontWeight.normal // Không in đậm
                        : (latestMessage.isRead
                        ? FontWeight.normal
                        : FontWeight.bold), // In đậm nếu tin nhắn chưa đọc
                  ),
                  maxLines: 1, // Chỉ hiển thị 1 dòng
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          )
              : Text(
            "No messages yet",
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  // Hàm này lấy tin nhắn gần nhất từ danh sách tin nhắn
  Message? _getLatestMessageFromList(List<Message> messages) {
    Message? latestMessage;

    for (var message in messages) {
      if (latestMessage == null ||
          message.sentAt!.toDate().isAfter(latestMessage.sentAt!.toDate())) {
        latestMessage = message;
      }
    }

    return latestMessage;
  }
  int _getUnreadMessageCount(List<Message> messages, String otherUserId) {
    int count = 0;
    for (var message in messages) {
      if (message.senderID == otherUserId && message.isRead == false) {
        count++;
      }
    }
    return count;
  }
}
