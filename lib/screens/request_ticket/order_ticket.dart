import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/order.dart';
import 'package:ticket_resell/api/response/ticket.dart';
import 'package:ticket_resell/screens/product_detail/place_screen.dart';

class AllOrderTicketScreen extends StatefulWidget {
  const AllOrderTicketScreen({super.key});

  @override
  _AllOrderTicketScreenState createState() => _AllOrderTicketScreenState();
}

class _AllOrderTicketScreenState extends State<AllOrderTicketScreen> {
  List<Order> orders = [];
  Map<int, Ticket> tickets = {}; // Sử dụng một Map để lưu các Ticket theo ticketId

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final userId = UserManager().id;

    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Order/get-order-by-userid?userId=$userId&page=1&limit=1000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        orders = (data['content'] as List)
            .map((json) => Order.fromJson(json))
            .toList();

        // Sắp xếp đơn hàng theo thứ tự giảm dần của orderDate
        orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      });

      // Lấy danh sách các ticketId từ orders để tải ticket một lần
      for (var order in orders) {
        if (!tickets.containsKey(order.ticketId)) {
          fetchTicket(order.ticketId);
        }
      }
    } else {
      print('Failed to load orders');
    }
  }


  Future<void> fetchTicket(int ticketId) async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=$ticketId'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        tickets[ticketId] = Ticket.fromJson(data['content']);
      });
    } else {
      print('Failed to load ticket');
    }
  }

  @override
  Widget build(BuildContext context) {
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Order Tickets"),
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
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final ticket = tickets[order.ticketId]; // Lấy ticket từ Map
          final ticketName = ticket?.ticketName ?? "Loading..."; // Hiển thị tên ticket
          final address = order.address;
          final price = order.price;
          final quantity = order.quantity;
          final orderDate = order.orderDate;
          final formattedDate =
          DateFormat('HH:mm dd/MM/yyyy').format(order.orderDate);
          final status = order.orderStatusIds ?? 0; // Giả định trạng thái null là 0

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaceScreen(ticket: ticket!),
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
                          ticketName, // Hiển thị tên của ticket
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
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
                            Text("Address: $address"),
                            Text("Order Date: $formattedDate"),
                          ],
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
}
