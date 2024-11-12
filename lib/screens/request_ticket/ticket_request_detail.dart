import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/push_notification_service.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/notification.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/screens/chat/chat_screen.dart';
import 'package:ticket_resell/screens/request_ticket/all_request_ticket.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/widgets/chat_tile.dart';

class TicketRequestDetailScreen extends StatefulWidget {
  final TicketRequest ticketRequest;

  const TicketRequestDetailScreen({super.key, required this.ticketRequest});

  @override
  _TicketRequestDetailScreen createState() => _TicketRequestDetailScreen();
}

class _TicketRequestDetailScreen extends State<TicketRequestDetailScreen> {
  //final TicketRequest ticketRequest;
  final GetIt _getIt = GetIt.instance;
  UserManager userManager = UserManager();
  late AuthService _authService;
  late NavigationService _navigationService;
  //late AlertService _alertService;
  late DatabaseService _databaseService;

  String? otherFcmToken;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    //_alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 2, color: Colors.grey[300]),

            SizedBox(height: 16.0),
            _buildDetailRow("Buyer:", widget.ticketRequest.userFullname),
            _buildDetailRow("Price:", "\$${widget.ticketRequest.price.toStringAsFixed(2)}"),
            _buildDetailRow("Quantity:", widget.ticketRequest.quantity.toString()),
            //_buildDetailRow("Status:", widget.ticketRequest.status),

            // Add other ticket request fields here if needed
            SizedBox(height: 20.0),
            Container(
              width: double.infinity, // Make the button stretch to the width of the container
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Add bottom padding
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.ticketRequest.status == 0
                        ? Colors.blueAccent
                        : (widget.ticketRequest.status == 1 ? Colors.green : Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Increased vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: widget.ticketRequest.status == 0 // Check if status is Pending (0)
                      ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Xác nhận"),
                          content: const Text(
                              "Bạn có chắc chắn muốn chấp nhận yêu cầu này không?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _updateRequestStatus(widget.ticketRequest.id);
                              },
                              child: const Text(
                                "Accept",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                      : () {},
                  child: Text(
                    widget.ticketRequest.status == 0
                        ? "Accept"
                        : (widget.ticketRequest.status == 1 ? "Confirmed" : "Rejected"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Increased font size
                    ),
                  ),
                ),
              ),
            )
,
            // Call _buildUI below the text widgets
            Expanded(child: _buildUI()),
          ],
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 0.0,
        ),
        child: _chatsList(),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // Changes position of shadow
            ),
          ],
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Center( // Center the entire content
          child: Text(
            "$label $value", // Combine label and value
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }






  Future<void> _updateRequestStatus(int ticketRequestId) async {

      // Cập nhật trạng thái của yêu cầu đã xác nhận
      //requests[index]['status'] = 'Confirmed';

      // Cập nhật trạng thái của các yêu cầu khác thành Rejected
      // for (int i = 0; i < requests.length; i++) {
      //   if (i != index) {
      //     requests[i]['status'] = 'Rejected';
      //   }
      // }
      //Get.to(() => AllRequestTicketScreen());

      //final ticketRequestId = requests[index].id;
      final url = Uri.parse(
          'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/confirm-ticket-request?ticketRequestId=$ticketRequestId');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("101010101010101011===========================================");
        await getUserByEmail(widget.ticketRequest.userEmail, ticketRequestId);
        Fluttertoast.showToast(
          msg: "Yêu cầu của ${widget.ticketRequest.userFullname} đã được chấp nhận.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AllRequestTicketScreen(
                ticketId: widget.ticketRequest.ticketId,
              )),
        );
      }
    ;
  }

  Future<void> getUserByEmail(String email, int ticketRequestId) async {
    final url = 'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/User/get-user-by-email?email=$email';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    //final body = jsonEncode({'email': email});

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
        //body: body,
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("000000000000000000000000000000000==========================999999999999999999999");
        final responseData = json.decode(response.body);
        otherFcmToken = responseData['content']['fcmToken'];
        NotificationModel? notificationModel = NotificationModel(id: "", senderId: userManager.email!, receiverId: widget.ticketRequest.userEmail, title: "Request for ticket had confirm", body: "You request had confirm from ${responseData['content']['fullname']}", timestamp: Timestamp.fromDate(DateTime.now()),ticketRequestId: ticketRequestId, status: 'Accept');
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


  Widget _chatsList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfile(widget.ticketRequest.userEmail), // Lấy danh sách người dùng
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to load data."),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile otherUser = users[index].data();

              print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
              //print(_authService.user!.uid);
              print(userManager.email);
              print(otherUser.uid!);

              // Sử dụng FutureBuilder để lấy dữ liệu chat giữa currentUser và otherUser
              return FutureBuilder<DocumentSnapshot<Chat>>(
                future: _databaseService.getChatData(
                  //_authService.user!.uid, // currentUser ID
                  userManager.email!,
                  otherUser.uid!,         // otherUser ID
                ).first, // Lấy bản ghi đầu tiên từ Stream
                builder: (context, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (chatSnapshot.hasError) {
                    return const Center(child: Text("Error loading chat."));
                  }

                  if (!chatSnapshot.hasData || chatSnapshot.data == null) {
                    // Nếu không có dữ liệu, trả về một widget trống
                    return const SizedBox.shrink();
                  }

                  // Lấy dữ liệu từ DocumentSnapshot
                  final chatData = chatSnapshot.data!.data();
                  if (chatData == null || chatData.messages == null) {
                    return const SizedBox.shrink();
                  }

                  Chat? chat = chatSnapshot.data!.data();

                  // Kiểm tra nếu không có tin nhắn giữa currentUser và otherUser
                  if (chat != null && (chat.messages == null || chat.messages!.isEmpty)) {
                    return const SizedBox(); // Không hiển thị nếu không có tin nhắn
                  }

                  // Nếu có tin nhắn, hiển thị ChatTile
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ChatTile(
                      userProfile: otherUser,
                      onTap: () async {
                        final chatExists = await _databaseService.checkChatExists(
                          // _authService.user!.uid,
                          userManager.email!,
                          otherUser.uid!,
                        );

                        if (chatExists) {
                          // Lấy tất cả tin nhắn từ chat hiện tại
                          final chatData = await _databaseService.getChatData(
                            // _authService.user!.uid,
                            userManager.email!,
                            otherUser.uid!,
                          ).first;

                          Chat? chat = chatData.data();

                          if (chat != null && chat.messages != null) {
                            // Kiểm tra và cập nhật trạng thái isRead cho các tin nhắn chưa đọc
                            for (Message message in chat.messages!) {
                              if (message.senderID != userManager.id && !message.isRead) {
                                message.isRead = true;
                                await _databaseService.updateMessageReadStatus(
                                  // _authService.user!.uid,
                                  userManager.email!,
                                  otherUser.uid!,
                                  message,
                                );
                              }
                            }
                          }
                        } else {
                          // Tạo cuộc trò chuyện mới nếu chưa tồn tại
                          await _databaseService.createNewChat(
                            //_authService.user!.uid,
                            userManager.email!,
                            otherUser.uid!,
                          );
                        }

                        Ticket emptyTicket = Ticket(id: 0, ticketName: "", price: 0, quantity: 0, expirationDate: "", venue: "", status: 0, categoryName: "", postTitle: "", postDescription: "", createdDate: "", userId: 0, email: "", imageUrls: [], categoryId: 0);

                        // Điều hướng đến màn hình chat
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
                                deal: false,
                                ticket: emptyTicket,
                                chatUser: otherUser,
                              );
                            },
                          ),
                        );
                      },
                      messages: chat!.messages!, // Truyền danh sách tin nhắn vào ChatTile
                    ),
                  );
                },
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }



}
