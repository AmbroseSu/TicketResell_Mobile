import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
class AllChatsScreen extends StatelessWidget {
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

  AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(),
                        Text(
                          "Messages",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.search, size: 35))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Recent",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  images[index],
                                ),
                                minRadius: 33,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                names[index],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 20),

                  ListView.builder(
                    itemCount: images
                        .length, // Ensure itemCount is based on `images` list
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            images[index],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(names[index]),
                        subtitle: Text(messages[index]),
                        trailing: Text(msgTiming[index]),
                      );
                    },
                  ),

                  // ListView.builder(
                  //   // itemCount: images.length,
                  //     itemCount: [images.length, names.length, msgs.length, msgTiming.length].reduce((a, b) => a < b ? a : b),
                  //
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, index){
                  //     return ListTile(
                  //       leading: CircleAvatar(
                  //         backgroundImage: AssetImage(images[index],),
                  //       ),
                  //       title: Text(names[index]),
                  //       subtitle: Text(msgs[index]),
                  //       trailing: Text(msgTiming[index]),
                  //     );
                  //     }
                  // )
                  // ListView.builder(
                  //   itemCount: [images.length, names.length, msgs.length, msgTiming.length].reduce((a, b) => a < b ? a : b),  // Use the smallest list length
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       leading: CircleAvatar(
                  //         backgroundImage: AssetImage(images[index],),
                  //       ),
                  //       title: Text(names[index]),
                  //       subtitle: Text(msgs[index]),
                  //     );
                  //   },
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
