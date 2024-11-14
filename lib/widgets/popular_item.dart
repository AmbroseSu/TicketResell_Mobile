import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/api/response/post.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/response/post_element.dart';
import 'package:ticket_resell/api/response/ticket.dart';

import '../screens/product_detail/place_screen.dart';

class PopularItem extends StatefulWidget {
  final PostResponse postResponse;

  const PopularItem({
    super.key,
    required this.postResponse,
  });

  @override
  _PopularItemState createState() => _PopularItemState();
}

class _PopularItemState extends State<PopularItem> {

  Ticket? ticket;
  PostElement? activePostElement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceScreen(ticket: ticket),));
      },
      child: Container(
        width: 240,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
          image: DecorationImage(
            image: NetworkImage(
              widget.postResponse.imageUrls.isNotEmpty
                  ? widget.postResponse.imageUrls[0]
                  : 'https://i.pinimg.com/736x/d7/07/84/d70784b885602af2877dd7a7230bba2c.jpg',
            ),
            opacity: 0.9,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFF4D5652),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        activePostElement!.title,
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF4D5652),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/vectors/star_1_x2.svg',
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              "rating",
                              style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${widget.postResponse.ticketId}'));
    print(response.statusCode);
    var responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 200) {

      ticket = Ticket.fromJson(responseData['content']);
      print(ticket!.ticketId);
      print(ticket!.expirationDate);
      print("0101010101010101010101010101010101010101");

    } else {
      print('Failed to load tickets');
    }
  }

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);

      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return 'Invalid date format';
    }
  }


  Future<void> fetchTicketsOnTap() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${widget.postResponse.ticketId}'));
    print(response.statusCode);
    var responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 200) {

      ticket = Ticket.fromJson(responseData['content']);
      print(ticket!.ticketId);

      String formattedDate = formatDate(ticket!.expirationDate);
      print(formattedDate);
      print("0101010101010101010101010101010101010101");
      Get.to(() => PlaceScreen(ticket: ticket!));
    } else {
      print('Failed to load tickets');
    }
  }
  void findActivePostElement() {
    activePostElement = widget.postResponse.postElements
        .firstWhere((postElement) => postElement.status == 'ACTIVE');
    print('Active Post Element: $activePostElement');
  }

}
