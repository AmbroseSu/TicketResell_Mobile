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
  final GetIt _getIt = GetIt.instance;

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0), // Khoảng cách bên phải
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.lightBlueAccent, // Màu nền xanh nhạt
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: TextButton.icon(
                icon: Icon(Icons.add, color: Colors.white), // Màu sắc của biểu tượng
                label: Text(
                  "Request",
                  style: TextStyle(color: Colors.white), // Màu sắc của văn bản
                ),
                onPressed: () {
                  _showRequestForm();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0), // Padding bên trong nút
                  backgroundColor: Colors.lightBlueAccent, // Màu nền xanh nhạt
                ),
              ),
            ),
          ),
        ],
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

  void _showRequestForm() {
    showModalBottomSheet(
      isScrollControlled: true, // Allows the sheet to resize for the keyboard
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                20.0, // Add space for keyboard
          ),
          child: SingleChildScrollView(
            // Allows the bottom sheet to scroll
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price/Ticket',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC2E9FB),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    final price = _priceController.text;
                    final quantity = _quantityController.text;
                    final address = _addressController.text;

                    // Kiểm tra xem các trường có rỗng không
                    if (price.isEmpty || quantity.isEmpty || address.isEmpty) {
                      // Hiển thị hộp thoại nếu có trường rỗng
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Thông báo'),
                            content: Text('Bạn phải nhập đủ thông tin!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return; // Kết thúc hàm nếu có trường rỗng
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Request Information'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Price: $price'),
                              Text('Quantity: $quantity'),
                              Text('Address: $address'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.of(context)
                                    .pop(); // Close bottom sheet
                                ChatMessage requestMessage = ChatMessage(
                                  user: currentUser!,
                                  text:
                                      'Price: $price\nQuantity: $quantity\nAddress: $address',
                                  createdAt: DateTime.now(),
                                );
                                _sendMessage(requestMessage);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Send Request',
                    style: TextStyle(
                      fontWeight: FontWeight.w800, // In đậm chữ
                    ),
                  ),
                ),
              ],
            ),
          ),
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
