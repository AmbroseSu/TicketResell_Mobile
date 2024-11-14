import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/screens/chat/chat_screen.dart';
import 'package:ticket_resell/screens/product_detail/place_screen.dart';
import 'package:ticket_resell/screens/request_ticket/all_request_ticket.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/widgets/chat_tile.dart';

class TicketRequestForBuyerDetailScreen extends StatefulWidget {
  final TicketRequest ticketRequest;

  const TicketRequestForBuyerDetailScreen({super.key, required this.ticketRequest});

  @override
  _TicketRequestForBuyerDetailScreen createState() => _TicketRequestForBuyerDetailScreen();
}

class _TicketRequestForBuyerDetailScreen extends State<TicketRequestForBuyerDetailScreen> {
  //final TicketRequest ticketRequest;
  final GetIt _getIt = GetIt.instance;
  UserManager userManager = UserManager();
  late AuthService _authService;
  late NavigationService _navigationService;
  //late AlertService _alertService;
  late DatabaseService _databaseService;

  Ticket? ticket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    //_alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
    fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if data is still loading
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 2, color: Colors.grey[300]),
            const SizedBox(height: 16.0),
            _buildDetailRow("Ticket Name:", ticket!.ticketName),
            _buildDetailRow("Price:", "\$${widget.ticketRequest.price.toStringAsFixed(2)}"),
            _buildDetailRow("Quantity:", widget.ticketRequest.quantity.toString()),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: double.infinity, // Cho nút 'Accept' rộng bằng với ô
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.ticketRequest.status == 0
                            ? Colors.blueAccent
                            : (widget.ticketRequest.status == 1 ? Colors.green : Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12), // Điều chỉnh padding nếu cần
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Thêm hành động cho nút 'Accept'
                      },
                      child: Text(
                        widget.ticketRequest.status == 0
                            ? "Accept"
                            : (widget.ticketRequest.status == 1 ? "Confirmed" : "Rejected"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0), // Khoảng cách giữa các nút
                  if (widget.ticketRequest.status == 1) // Chỉ hiển thị nút 'View Ticket' nếu status là 'Confirmed'
                    Container(
                      width: double.infinity, // Cho nút 'View Ticket' rộng bằng với ô
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(vertical: 12), // Điều chỉnh padding nếu cần
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Hành động cho nút 'View Ticket'
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaceScreen(ticket: ticket!),
                            ),
                          );
                        },
                        child: const Text(
                          "View Ticket",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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


  Future<void> fetchTickets() async {
    final ticketId = widget.ticketRequest.ticketId;

    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=$ticketId'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ticket = Ticket.fromJson(data['content']);
        _isLoading = false;
        print("9=========================================================");
        print(ticket);
      });
    } else {
      print('Failed to load tickets');
      setState(() {
        _isLoading = false; // Even if fetching fails, stop loading state
      });
    }
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




  Widget _chatsList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfile(ticket!.email), // Lấy danh sách người dùng
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

                        Ticket emptyTicket = Ticket(ticketId: 0, ticketName: "", price: 0, quantity: 0, expirationDate: "", venue: "", status: "", isDeleted: false, categoryId: 0, categoryName: "", postId: 0, postTitle: "", postDescription: "", currentPostStatus: "", createdDate: "", userId: 0, email: "", imageUrls: [], feedbackDTOs: []);

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
