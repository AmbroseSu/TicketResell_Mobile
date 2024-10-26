import 'package:flutter/material.dart';
import 'package:ticket_resell/screens/request_ticket/all_request_ticket.dart';

class AllTicketScreen extends StatelessWidget {
  AllTicketScreen({super.key});

  final List<Map<String, dynamic>> tickets = [
    {
      'name': 'Concert Ticket',
      'price': 50.0,
      'quantity': 2,
      'expiredDate': '01-12-2024',
    },
    {
      'name': 'Movie Ticket',
      'price': 15.0,
      'quantity': 5,
      'expiredDate': '30-10-2023',
    },
    {
      'name': 'Sports Event Ticket',
      'price': 100.0,
      'quantity': 1,
      'expiredDate': '15-01-2024',
    },
    {
      'name': 'Theater Ticket',
      'price': 75.0,
      'quantity': 3,
      'expiredDate': '20-11-2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tickets"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          final name = ticket['name'];
          final price = ticket['price'];
          final quantity = ticket['quantity'];
          final expiredDate = ticket['expiredDate'];

          return GestureDetector(
            onTap: () {
              // Chuyển đến màn hình AllRequestTicketScreen khi nhấn vào Card
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllRequestTicketScreen(),
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
                    Text("Expired Date: $expiredDate"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
