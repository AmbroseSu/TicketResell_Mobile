import 'package:flutter/material.dart';


class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({Key? key}) : super(key: key);

  @override
  _CommentInputWidgetState createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  TextEditingController _commentController = TextEditingController();

  // List of emojis you can extend this list
  final List<String> emojis = ['😀', '😂', '😍', '😎', '🥳', '🤔', '😢', '👍', '👏'];

  void _openEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Number of emojis per row
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Insert selected emoji into the text field
                  _commentController.text += emojis[index];
                  Navigator.pop(context); // Close the emoji picker
                },
                child: Center(
                  child: Text(
                    emojis[index],
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Comment Input Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Comment Input Field
              Expanded(
                child: TextField(
                  controller: _commentController, // Connect text controller
                  decoration: InputDecoration(
                    hintText: 'Enter your comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Icon for selecting emoji or comment options
              GestureDetector(
                onTap: _openEmojiPicker, // Open emoji picker when clicked
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}