import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/styles&text&sizes/product_card_vertical_fav.dart';
import '../../api/response/ticket.dart';
import '../../styles&text&sizes/product_card_vertical.dart';
import '../../styles&text&sizes/product_card_vertical_fav.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/appbar.dart';
import '../../widgets/grid_layout.dart';
import '../../widgets/t_circular_icon.dart';
import '../explore_screen.dart';

class AllTicket extends StatefulWidget {
  const AllTicket({super.key});

  @override
  _AllTicketState createState() => _AllTicketState();
}

class _AllTicketState extends State<AllTicket> {
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get-list?page=1&limit=1000'));
    print(response.statusCode);
    var responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 200) {

      final data = json.decode(response.body);
      setState(() {
        tickets = (data['content'] as List)
            .map((json) => Ticket.fromJson(json))
            .toList();
      });
      print("0101010101010101010101010101010101010101");
      print(tickets[1]);
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('All Tickets', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TGridLayout(itemCount: tickets.length, itemBuilder: (_, index) => TProductCardVertical(ticket: tickets[index],))
            ],
          ),
        ),
      ),
    );
  }
}
