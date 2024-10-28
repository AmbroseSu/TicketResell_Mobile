import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/models/chat.dart';
import 'package:ticket_resell/models/message.dart';
import 'package:ticket_resell/models/user_profile.dart';
import 'package:ticket_resell/screens/request_ticket/all_ticket_seller.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/widgets/chat_tile.dart';

import 'chat_screen.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  // Mark these lists as final to make them immutable.
  List images = [
    "assets/users/Christine.jpg",
    "assets/users/Davis.jpg",
    "assets/users/Johnson.jpg",
    "assets/users/Jones Noa.jpg",
    "assets/users/Parker Bee.jpg",
    "assets/users/Smith.jpg",
  ];

  List names = [
    "Christine",
    "Davis",
    "Johnson",
    "Jones Noa",
    "Parker Bee",
    "Smith",
  ];

  List msgTiming = [
    "Mon",
    "12:30",
    "Sun",
    "05:41",
    "22:12",
    "Wed", // Matching the number of messages
  ];

  final GetIt _getIt = GetIt.instance;
  UserManager userManager = UserManager();
  late AuthService _authService;
  late NavigationService _navigationService;
  //late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    //_alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: const Text(
  //         "Messages",
  //       ),
  //       actions: [
  //       ],
  //     ),
  //     body: _buildUI(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Trả về false để vô hiệu hóa nút back của điện thoại
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Bỏ nút back trong AppBar
          title: const Text("Messages"),
          actions: [],
        ),
        //body: _buildUI(),
        body: Stack(
          children: [
            _buildUI(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => AllTicketSellerScreen());
                    // Xử lý sự kiện khi nhấn nút View Request
                    // Ví dụ: Điều hướng đến màn hình yêu cầu
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Màu nền của nút
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9), // Kích thước nút nằm ngang
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Đặt border radius cho nút bo tròn
                    ),
                  ),
                  child: const Text(
                    "View Request",
                    style: TextStyle(
                      color: Colors.white, // Màu chữ trắng
                      fontWeight: FontWeight.bold, // In đậm chữ
                      fontSize: 17, // Kích thước chữ lớn hơn nếu cần
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 0.0,
        ),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfiles(userManager.email!), // Lấy danh sách người dùng
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to load data."),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;

          return ListView.builder(
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
                              if (message.senderID != _authService.user!.uid && !message.isRead) {
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

                        Ticket emptyTicket = Ticket(id: 0, ticketName: "", price: 0, quantity: 0, expirationDate: "", venue: "", status: 0, categoryName: "", postId: 0, postTitle: "", postDescription: "", createdDate: "", postStatus: false, userId: 0, email: "");

                        // Điều hướng đến màn hình chat
                        _navigationService.push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
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

  // Widget _chatsList() {
  //   return StreamBuilder(
  //     stream: _databaseService.getUserProfiles(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Center(
  //           child: Text("Unable to load data."),
  //         );
  //       }
  //       print(snapshot.data);
  //       if (snapshot.hasData && snapshot.data != null) {
  //         final users = snapshot.data!.docs;
  //         return ListView.builder(
  //           itemCount: users.length,
  //           itemBuilder: (context, index) {
  //             UserProfile user = users[index].data();
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 10.0,
  //               ),
  //               child: ChatTile(
  //                 userProfile: user,
  //                 onTap: () async {
  //                   final chatExists = await _databaseService.checkChatExists(
  //                     _authService.user!.uid,
  //                     user.uid!,
  //                   );
  //                   if (!chatExists) {
  //                     await _databaseService.createNewChat(
  //                       _authService.user!.uid,
  //                       user.uid!,
  //                     );
  //                   }
  //                   _navigationService.push(
  //                     MaterialPageRoute(
  //                       builder: (context) {
  //                         return ChatScreen(
  //                           chatUser: user,
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 }, messages: [],
  //               ),
  //             );
  //           },
  //         );
  //       }
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }

}
