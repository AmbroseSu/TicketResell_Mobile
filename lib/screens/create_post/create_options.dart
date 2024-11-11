import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ticket_resell/styles&text&sizes/colors.dart';

import 'create_ticket.dart';
//
// class CreatePage extends StatelessWidget {
//   const CreatePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create Options"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Create Ticket Button
//             ElevatedButton(
//               onPressed: () {
//                 // Điều hướng đến trang CreateTicket
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CreateTicket()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50), // Kích thước nút
//                 backgroundColor: Colors.blueAccent, // Màu nền nút
//               ),
//               child: Text(
//                 'Create Ticket',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Create Post Button
//             ElevatedButton(
//               onPressed: () {
//                 // Điều hướng đến trang CreatePost
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CreatePost()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50), // Kích thước nút
//                 backgroundColor: Colors.greenAccent, // Màu nền nút
//               ),
//               child: Text(
//                 'Create Post',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Options"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Nút Create Ticket
              ElevatedButton(
                onPressed: () {
                  // Điều hướng đến trang CreateTicket
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateTicket()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  backgroundColor: TColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.confirmation_num, size: 40, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Create Ticket',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Nút Create Post
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePost()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.create, size: 40, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Create Post',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Mẫu trang CreatePost (giả sử đã có sẵn)
class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Center(child: Text("Post Creation Form")),
    );
  }
}

