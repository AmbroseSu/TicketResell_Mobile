import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/models/user_profile.dart';
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

  List messages = [
    "Hi, How are you?",
    "Where are you now?",
    "Bye",
    "Hi",
    "How much for this ticket?",
    "Welcome",
  ];

  final GetIt _getIt = GetIt.instance;

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

  //AllChatsScreen({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     child: Container(
  //       color: Colors.white,
  //       child: SingleChildScrollView(
  //         child: SafeArea(
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 15, left: 15),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Padding(
  //                 //   padding: const EdgeInsets.only(right: 15),
  //                 //   child: Row(
  //                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 //     children: [
  //                 //       BackButton(),
  //                 //       Text(
  //                 //         "Messages",
  //                 //         style: TextStyle(
  //                 //           fontSize: 30,
  //                 //           fontWeight: FontWeight.bold,
  //                 //           letterSpacing: 1,
  //                 //           color: Colors.black87,
  //                 //         ),
  //                 //       ),
  //                 //       IconButton(
  //                 //           onPressed: () {}, icon: Icon(Icons.search, size: 35))
  //                 //     ],
  //                 //   ),
  //                 // ),
  //                 // SizedBox(
  //                 //   height: 5,
  //                 // ),
  //                 // Text(
  //                 //   "Recent",
  //                 //   style: TextStyle(
  //                 //     fontSize: 18,
  //                 //     fontWeight: FontWeight.w500,
  //                 //     letterSpacing: 1,
  //                 //     color: Colors.black54,
  //                 //   ),
  //                 // ),
  //                 // SizedBox(height: 20),
  //                 // SizedBox(
  //                 //   height: 100,
  //                 //   child: ListView.builder(
  //                 //     scrollDirection: Axis.horizontal,
  //                 //     shrinkWrap: true,
  //                 //     itemCount: images.length,
  //                 //     itemBuilder: (context, index) {
  //                 //       return Padding(
  //                 //         padding: EdgeInsets.only(right: 25),
  //                 //         child: Column(
  //                 //           children: [
  //                 //             CircleAvatar(
  //                 //               backgroundImage: AssetImage(
  //                 //                 images[index],
  //                 //               ),
  //                 //               minRadius: 33,
  //                 //             ),
  //                 //             SizedBox(
  //                 //               height: 8,
  //                 //             ),
  //                 //             Text(
  //                 //               names[index],
  //                 //               style: TextStyle(
  //                 //                 fontSize: 17,
  //                 //                 fontWeight: FontWeight.w500,
  //                 //                 letterSpacing: 1,
  //                 //                 color: Colors.black,
  //                 //               ),
  //                 //             ),
  //                 //           ],
  //                 //         ),
  //                 //       );
  //                 //     },
  //                 //   ),
  //                 // ),
  //                 // SizedBox(height: 10),
  //                 // Divider(),
  //                 // SizedBox(height: 20),
  //                 _chatsList(),
  //
  //                 // ListView.builder(
  //                 //   itemCount: images
  //                 //       .length, // Ensure itemCount is based on `images` list
  //                 //   shrinkWrap: true,
  //                 //   physics: NeverScrollableScrollPhysics(),
  //                 //   itemBuilder: (context, index) {
  //                 //     return ListTile(
  //                 //       onTap: () {
  //                 //         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatUser: UserProfile(uid: "uid", name: "name", pfpURL: "pfpURL"),)));
  //                 //       },
  //                 //       leading: ClipRRect(
  //                 //         borderRadius: BorderRadius.circular(60),
  //                 //         child: Image.asset(
  //                 //           images[index],
  //                 //           height: 60,
  //                 //           width: 60,
  //                 //           fit: BoxFit.cover,
  //                 //         ),
  //                 //       ),
  //                 //       title: Text(names[index]),
  //                 //       subtitle: Text(messages[index]),
  //                 //       trailing: Text(msgTiming[index]),
  //                 //     );
  //                 //   },
  //                 // ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
        ),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     bool result = await _authService.logout();
          //     if (result) {
          //       _alertService.showToast(
          //         text: "Successfully logged out!",
          //         icon: Icons.check,
          //       );
          //       _navigationService.pushReplacementNamed("/login");
          //     }
          //   },
          //   icon: const Icon(
          //     Icons.logout,
          //   ),
          // ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: _chatsList(),
      ),
    );
  }


  Widget _chatsList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfiles(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to load data."),
          );
        }
        print(snapshot.data);
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ChatTile(
                  userProfile: user,
                  onTap: () async {
                    final chatExists = await _databaseService.checkChatExists(
                      _authService.user!.uid,
                      user.uid!,
                    );
                    if (!chatExists) {
                      await _databaseService.createNewChat(
                        _authService.user!.uid,
                        user.uid!,
                      );
                    }
                    _navigationService.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatScreen(
                            chatUser: user,
                          );
                        },
                      ),
                    );
                  },
                ),
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
