import 'package:flutter/material.dart';
import 'package:ticket_resell/api/response/post.dart';
import 'package:ticket_resell/screens/product_detail/post_status.dart';

//
// class ReviewTicketPage extends StatelessWidget {
//   final List<Map<String, dynamic>> tickets = [
//     {
//       "ticketName": "2 Ngay 1 Dem",
//       "price": 500,
//       "quantity": 10,
//       "expirationDate": "2024-11-14T21:00:00+07:00",
//     },
//     // Thêm các vé khác nếu cần
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Review Ticket'),
//       ),
//       body: ListView.builder(
//         itemCount: tickets.length,
//         itemBuilder: (context, index) {
//           var ticket = tickets[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             elevation: 5,
//             child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     ticket['ticketName'],
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Text('Price: \$${ticket['price']}'),
//                   Text('Quantity: ${ticket['quantity']}'),
//                   Text('Expiration Date: ${ticket['expirationDate']}'),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Xử lý sự kiện khi nhấn nút "View Post"
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('View Post'),
//                             content: Text('Here is the post content for ${ticket['ticketName']}'),
//                             actions: <Widget>[
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text('Close'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     child: TextButton(
//                        onPressed: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => PostStatusPage()),
//                          );
//                        }, child: Text( 'View Post'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/global_variables/user_manage.dart';


class ReviewTicketPage extends StatefulWidget {

  @override
  _ReviewTicketPageState createState() => _ReviewTicketPageState();
}

class _ReviewTicketPageState extends State<ReviewTicketPage> {
  List<PostResponse> postResponses = [];

  @override
  void initState() {
    super.initState();
    fetchTickets(); // Lấy dữ liệu khi widget được khởi tạo
  }

  Future<List<PostResponse>> fetchTickets() async {
    final int? userId = UserManager().id;

    final response = await http.get(
      Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-by-user?id=$userId&page=1&limit=1000'),
    );

    if (response.statusCode == 200) {
      // Parse the response body and return the list of tickets
      var data = jsonDecode(response.body);
      setState(() {
        postResponses = (data['content'] as List)
            .map((json) => PostResponse.fromJson(json))
            .toList();
      });
      // List<Map<String, dynamic>> tickets = [];
      // for (var item in data['content']) {
      //   tickets.add({
      //     'ticketName': item['ticketName'],
      //     'price': item['price'],
      //     'quantity': item['quantity'],
      //     'expirationDate': item['expirationDate'],
      //     'imageUrl': item['imageTicketDTOs'][0]['imageUrl'], // Use the first image URL
      //   });
      // }
      return postResponses;
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Review Ticket', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: postResponses.isEmpty
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi chưa có dữ liệu
          : ListView.builder(
        itemCount: postResponses.length,
        itemBuilder: (context, index) {
          var ticket = postResponses[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.ticketName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Price: \$${ticket.price}'),
                  Text('Quantity: ${ticket.quantity}'),
                  Text('Expiration Date: ${ticket.expirationDate}'),
                  SizedBox(height: 10),
                  // Nếu có hình ảnh, bạn có thể hiển thị nó như thế này:
                  // Image.network(ticket.imageUrl),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to PostStatusPage or handle other logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostStatusPage(postResponse: postResponses[index]),
                        ),
                      );
                      //print(postResponses[index].ticketId);
                    },
                    child: Text('View Post'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
