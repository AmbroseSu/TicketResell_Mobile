import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/screens/request_ticket/all_request_ticket.dart';
import 'package:http/http.dart' as http;

class AllTicketSellerScreen extends StatefulWidget {
  const AllTicketSellerScreen({super.key});

  @override
  _AllTicketSellerScreenState createState() => _AllTicketSellerScreenState();
}


class _AllTicketSellerScreenState extends State<AllTicketSellerScreen> {

  // final List<Map<String, dynamic>> tickets = [
  //   {
  //     'name': 'Concert Ticket',
  //     'price': 50.0,
  //     'quantity': 2,
  //     'expiredDate': '01-12-2024',
  //   },
  //   {
  //     'name': 'Movie Ticket',
  //     'price': 15.0,
  //     'quantity': 5,
  //     'expiredDate': '30-10-2023',
  //   },
  //   {
  //     'name': 'Sports Event Ticket',
  //     'price': 100.0,
  //     'quantity': 1,
  //     'expiredDate': '15-01-2024',
  //   },
  //   {
  //     'name': 'Theater Ticket',
  //     'price': 75.0,
  //     'quantity': 3,
  //     'expiredDate': '20-11-2024',
  //   },
  // ];

  List<Ticket> tickets = [];
  UserManager userManager = UserManager();

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get/user?email=${userManager.email}&page=1&limit=10'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        tickets = (data['content'] as List)
            .map((json) => Ticket.fromJson(json))
            .toList();
      });
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false; // Ngăn thao tác back
    },
     child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("All Tickets"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          final name = ticket.ticketName;
          final price = ticket.price;
          final quantity = ticket.quantity;
          //final expiredDate = ticket.expirationDate;
          print("))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))");
          print(ticket.id);

          final dateTime = DateTime.parse(ticket.expirationDate);
          final formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);


          return GestureDetector( 
            onTap: () {
              // Chuyển đến màn hình AllRequestTicketScreen khi nhấn vào Card
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllRequestTicketScreen(ticketId: ticket.id,),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 10.0),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0, // Kích thước font lớn hơn cho Name
                          ),
                        ),
                        Text(
                          "\$${price.toStringAsFixed(2)} / Ticket",
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text("Quantity: $quantity"),
                    Text("Expired Date: $formattedDate"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
     ),
    );
  }
}
