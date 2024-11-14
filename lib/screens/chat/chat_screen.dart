import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/push_notification_service.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/notification.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/media_service.dart';
import 'package:ticket_resell/services/storage_service.dart';
import 'package:ticket_resell/utils.dart';
import 'package:http/http.dart' as http;

import 'chat_message_item.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile chatUser;
  final bool deal;
  final Ticket ticket;

  const ChatScreen({
    super.key,
    required this.chatUser,
    required this.ticket,
    required this.deal,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GetIt _getIt = GetIt.instance;

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  UserManager userManager = UserManager();
  late AuthService _authService;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  String? otherFcmToken;

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    currentUser = ChatUser(
      //id: _authService.user!.uid,
      id: userManager.email!,
      //firstName: _authService.user!.displayName,
      firstName: userManager.fullname,
    );
    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpURL,
    );

    print("))0000-00000000000000000000000000000000000000000000000000000");
    print(widget.deal);
    print(widget.ticket.ticketId);

    _checkAndCreateChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.deal == false && widget.ticket.ticketId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buildUI();
        _showRequestFormForBook();
      });
    }//else{
    //   if(widget.deal == false && widget.ticket.id == 0){
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _buildUI();
    //       //_showRequestFormForBook();
    //     });
    //   }else{
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       _buildUI();
    //       _showRequestForm();
    //     });
    //   }
    // }
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
            padding: const EdgeInsets.only(right: 10.0),
            child: Visibility(
              visible: !(widget.deal == false && widget.ticket.ticketId == 0),
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.lightBlueAccent, // Màu nền xanh nhạt
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: TextButton.icon(
                  icon: Icon(Icons.add, color: Colors.white),
                  // Màu sắc của biểu tượng
                  label: Text(
                    "Request",
                    style:
                        TextStyle(color: Colors.white), // Màu sắc của văn bản
                  ),
                  onPressed: () {
                    _showRequestForm();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0.0),
                    // Padding bên trong nút
                    backgroundColor:
                        Colors.lightBlueAccent, // Màu nền xanh nhạt
                  ),
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
                    final price = double.tryParse(_priceController.text) ?? 0.0;
                    final quantity =
                        int.tryParse(_quantityController.text) ?? 0;
                    final address = _addressController.text;

                    // Kiểm tra nếu price hoặc quantity là 0 (có thể là giá trị không hợp lệ)
                    if (price <= 0 || quantity <= 0 || address.isEmpty) {
                      // Hiển thị thông báo lỗi hoặc xử lý tương ứng
                      Fluttertoast.showToast(
                        msg: "Please enter valid values.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }

                    // Kiểm tra xem các trường có rỗng không
                    if (/*price || quantity.isEmpty || */ address.isEmpty) {
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
                                Navigator.of(context)
                                    .pop(); // Close dialog without sending
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.of(context)
                                    .pop(); // Close bottom sheet
                                print(
                                    ")))))))))))000000000000000000000000000000000000000000000000000000000");
                                print(userManager.id);

                                await createTicketRequest(
                                    price: price,
                                    quantity: quantity,
                                    address: address,
                                    userId: userManager.id!,
                                    ticketId: widget.ticket.ticketId);

                                ChatMessage requestMessage = ChatMessage(
                                  user: currentUser!,
                                  text:
                                      'Ticket: ${widget.ticket.ticketName}\nPrice: $price\nQuantity: $quantity\nAddress: $address',
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

  void _showRequestFormForBook() {
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
                  controller: _priceController..text = '${widget.ticket.price}',
                  decoration: InputDecoration(
                    labelText: 'Price/Ticket',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
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
                    final price = double.tryParse(_priceController.text) ?? 0.0;
                    final quantity =
                        int.tryParse(_quantityController.text) ?? 0;
                    final address = _addressController.text;

                    // Kiểm tra nếu price hoặc quantity là 0 (có thể là giá trị không hợp lệ)
                    if (price <= 0 || quantity <= 0 || address.isEmpty) {
                      // Hiển thị thông báo lỗi hoặc xử lý tương ứng
                      Fluttertoast.showToast(
                        msg: "Please enter valid values.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }

                    // Kiểm tra xem các trường có rỗng không
                    if (/*price || quantity.isEmpty || */ address.isEmpty) {
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
                                Navigator.of(context)
                                    .pop(); // Close dialog without sending
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.of(context)
                                    .pop(); // Close bottom sheet

                                await createTicketRequest(
                                    price: price,
                                    quantity: quantity,
                                    address: address,
                                    userId: userManager.id!,
                                    ticketId: widget.ticket.ticketId);

                                ChatMessage requestMessage = ChatMessage(
                                  user: currentUser!,
                                  text:
                                      'Ticket: ${widget.ticket.ticketName}\nPrice: $price\nQuantity: $quantity\nAddress: $address',
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

  Future<void> createTicketRequest({
    required double price,
    required int quantity,
    required String address,
    required int userId,
    required int ticketId,
  }) async {
    final url = Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/create-ticket-request');
    final body = json.encode({
      'price': price,
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'ticketId': ticketId,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
        "Authorization": 'Bearer ${UserManager().token}'
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Yêu cầu thành công
        print('Ticket request created successfully.');
        final responseData = json.decode(response.body);
        int ticketReId = responseData['content']['id'];
        getUserByEmail(widget.ticket.email, ticketReId);

        // Bạn có thể thêm logic xử lý khi thành công ở đây
      } else {
        // Xử lý lỗi nếu có
        print('Failed to create ticket request: ${response.body}');
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc các lỗi khác
      print('Error: $error');
    }
  }

  Future<void> getUserByEmail(String email, int ticketRequestId) async {
    final url = 'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/get-user-by-email?email=$email';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
        "Authorization": 'Bearer ${UserManager().token}',
    };
    //final body = jsonEncode({'email': email});

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        otherFcmToken = responseData['content']['fcmToken'];
        NotificationModel? notificationModel = NotificationModel(id: "", senderId: userManager.email!, receiverId: widget.ticket.email, title: "Request for ticket ${widget.ticket.ticketName}", body: "You have a request from ${userManager.email}", timestamp: Timestamp.fromDate(DateTime.now()),ticketRequestId: ticketRequestId, status: 'Request');
        String? notificationId = await _databaseService.addNotification(notificationModel);
        print(")000000000000000000000000000000000000000000000000000000000000000000000000000000000");
        NotificationModel? notificationModelUpId = notificationModel.copyWith(id: notificationId);
        print(notificationModelUpId.id);
        print(notificationModelUpId.senderId);
        print(notificationModelUpId.title);
        print(notificationModelUpId.body);
        print(notificationModelUpId.receiverId);
        print(notificationModelUpId.ticketRequestId);



        await PushNotificationService.sendNotificationToSelectedDrivedForRequest(otherFcmToken,context,notificationModelUpId);

        // await PushNotificationService.sendNotificationToSelectedDrived(
        //     otherFcmToken,
        //     context,
        //     "title",
        //     "body"
        // );
        // Chuyển đến OtpVerificationScreen với id và role
        //Get.to(() => OtpVerificationScreen());
      } else {
        print('Failed to check email');
        //Get.snackbar('Error', 'Failed to check email: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      //Get.snackbar('Error', 'An error occurred: $error');
    }
  }

  Future<void> _checkAndCreateChat() async {
    // Lấy chat giữa hai người
    bool chat =
        await _databaseService.checkChatExists(currentUser!.id, otherUser!.id);

    if (!chat) {
      // Nếu chat không tồn tại, tạo chat mớ
      // Lưu chat mới vào cơ sở dữ liệu
      await _databaseService.createNewChat(
        userManager.email!,
        otherUser!.id,
      );
    }
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
