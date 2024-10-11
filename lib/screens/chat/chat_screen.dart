import 'package:flutter/material.dart';

import 'chat_message_item.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              height: 85,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(),
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/users/Jones Noa.jpg"),
                    maxRadius: 28,
                  ),
                  SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jones Noa",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 8),
                      Text("Ative 5 hours ago",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500
                        ),),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
                ],
              ),
            ),
            Expanded(child: Container(
              color: Colors.grey.shade200,
              child: ListView(
                padding: EdgeInsets.all(15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Today",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ChatMessageItem(isMeChatting: false, messageBody: "Hi, Jones Noa, How are you?"),
                  ChatMessageItem(isMeChatting: true, messageBody: "I am fines"),
                  ChatMessageItem(isMeChatting: false, messageBody: "Congratulations for 10+ Followers on Frodo"),
                  ChatMessageItem(isMeChatting: true, messageBody: "Oh thank you very much. I am working hard on it, so i can drive this ship in days"),
                  ChatMessageItem(isMeChatting: false, messageBody: "Great, I hope you can do more than that"),
                  ChatMessageItem(isMeChatting: true, messageBody: "Thanks"),

                ],
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Container(
          child: Row(
            children: [
              Expanded(child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type something...",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent
                  ),
                ),
                maxLines: 10,
                minLines: 1,
              ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {},
                hoverColor: Colors.white,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(13)
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
