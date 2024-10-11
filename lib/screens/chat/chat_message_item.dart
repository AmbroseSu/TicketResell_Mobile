import 'package:flutter/material.dart';

class ChatMessageItem extends StatelessWidget {
  final bool isMeChatting;
  final String messageBody;

  const ChatMessageItem(
      {super.key, required this.isMeChatting, required this.messageBody});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMeChatting ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: isMeChatting
                ? BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
          color: isMeChatting ? Colors.blueAccent : Colors.white
        ),
        margin: EdgeInsets.all(10),
        child: Text(messageBody,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isMeChatting ? Colors.white : Colors.blueAccent
        ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
