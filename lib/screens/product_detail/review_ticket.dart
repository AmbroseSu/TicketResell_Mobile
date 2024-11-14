import 'package:flutter/material.dart';
import 'package:ticket_resell/api/response/post.dart';
import 'package:ticket_resell/screens/product_detail/post_status.dart';
import 'dart:convert';
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
    fetchTickets();
  }

  Future<List<PostResponse>> fetchTickets() async {
    final int? userId = UserManager().id;

    final response = await http.get(
      Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-by-user?id=$userId&page=1&limit=1000'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );

    if (response.statusCode == 200) {
      // Parse the response body and return the list of tickets
      var data = jsonDecode(response.body);
      setState(() {
        postResponses = (data['content'] as List)
            .map((json) => PostResponse.fromJson(json))
            .toList();
      });

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
          ? Center(child: CircularProgressIndicator())
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
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
