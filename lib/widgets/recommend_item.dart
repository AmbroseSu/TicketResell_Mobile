import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// class RecommendCard extends StatelessWidget {
//   final String title;
//   final String duration;
//   final String deal;
//   final String image;
//   final VoidCallback? onTap;
//
//   const RecommendCard(
//       {super.key,
//       required this.title,
//       required this.duration,
//       required this.deal,
//       required this.image,
//         this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 175,
//         decoration: BoxDecoration(
//           border: Border.all(color: Color(0xFFF4F4F4)),
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x2B97A0B2),
//               offset: Offset(0, 4),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.asset(
//                     image,
//                     width: double.infinity,
//                     height: 100,
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 8,
//                   right: 8,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color(0xFF3A544F),
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
//                     child: Text(
//                       duration,
//                       style: GoogleFonts.montserrat(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(8),
//               child: Text(
//                 title,
//                 style: GoogleFonts.montserrat(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                     color: Color(0xFF232323)),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   SvgPicture.asset("assets/vectors/shape_x2.svg",
//                   height: 12,
//                   width: 12,
//                   ),
//                   SizedBox(width: 5.5),
//                   Text(
//                     deal,
//                     style: GoogleFonts.montserrat(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         color: Color(0xFF3A544F)),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/post.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/response/ticket.dart';

import '../api/response/post_element.dart';
import '../screens/product_detail/place_screen.dart';

class RecommendCard extends StatefulWidget {

  final PostResponse postResponse;

  const RecommendCard({
    super.key, required this.postResponse,

  });

  @override
  _RecommendCardState createState() => _RecommendCardState();


}


class _RecommendCardState extends State<RecommendCard>{
  Ticket? ticket;
  PostElement? activePostElement;

  @override
  void initState() {
    super.initState();
    findActivePostElement();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${widget.postResponse.ticketId}'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        });
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
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get?ticketId=${widget.postResponse.ticketId}'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        });
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





  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fetchTicketsOnTap,
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFF4F4F4)),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x2B97A0B2),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.postResponse.imageUrls.isNotEmpty
                        ? widget.postResponse.imageUrls[0]
                        : 'https://i.pinimg.com/736x/d7/07/84/d70784b885602af2877dd7a7230bba2c.jpg',
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF3A544F),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Text(
                      // widget.postResponse.expirationDate,
                      formatDate(widget.postResponse.expirationDate),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                activePostElement!.title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF232323),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/vectors/shape_x2.svg",
                    height: 12,
                    width: 12,
                  ),
                  SizedBox(width: 5.5),
                  Text(
                    'Hot deal',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF3A544F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}