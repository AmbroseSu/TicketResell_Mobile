import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/screens/request_ticket/ticket_request_detail.dart';
import 'package:ticket_resell/screens/request_ticket/ticket_request_for_buyer_detail.dart';

class AllTicketRequestBuyScreen extends StatefulWidget {
  const AllTicketRequestBuyScreen({super.key});

  @override
  _AllTicketRequestBuyScreenState createState() =>
      _AllTicketRequestBuyScreenState();
}

class _AllTicketRequestBuyScreenState extends State<AllTicketRequestBuyScreen> {
  List<TicketRequest> requests = [];
  Ticket? ticket;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final userId = UserManager().id;

    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/get-ticket-request-for-buyer?userId=$userId&page=1&limit=1000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        requests = (data['content'] as List)
            .map((json) => TicketRequest.fromJson(json))
            .toList();
      });
    } else {
      print('Failed to load tickets');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Sort the requests by date, most recent first
    requests.sort((a, b) => b.ticketRequestDate.compareTo(a.ticketRequestDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Request Tickets"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          final senderName = request.userFullname;
          final price = request.price;
          final quantity = request.quantity;
          fetchTickets(request.ticketId);
          final requestDate = request.ticketRequestDate;
          final formattedDate =
          DateFormat('dd/MM/yyyy').format(request.ticketRequestDate); // Including time
          final status = request.status;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TicketRequestForBuyerDetailScreen(ticketRequest: request),
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
                          senderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quantity: $quantity"),
                            Text("Request Date: $formattedDate"),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: status == 0
                                ? Colors.blueAccent
                                : (status == 1 ? Colors.green : Colors.red),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            status == 0
                                ? "Accept"
                                : (status == 1 ? "Confirmed" : "Rejected"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchTickets(int ticketId) async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${ticketId}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ticket = Ticket.fromJson(data['content']);
      });
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }
}
