// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:intl/intl.dart';
// import 'package:ticket_resell/models/notification.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ticket_resell/services/database_service.dart';
//
//
// class NotificationTile extends StatefulWidget {
//   final NotificationModel notification;
//   const NotificationTile({Key? key, required this.notification}) : super(key: key);
//
//   @override
//   State<NotificationTile> createState() => _NotificationTileState();
// }
//
// class _NotificationTileState extends State<NotificationTile> {
//   final GetIt _getIt = GetIt.instance;
//   late DatabaseService _databaseService;
//
//   @override
//   void initState() {
//     super.initState();
//     _databaseService = _getIt.get<DatabaseService>();
//   }
//
//
//
//   String _formatTimestamp(Timestamp timestamp) {
//     return DateFormat('HH:mm dd/MM/yyyy').format(timestamp.toDate());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage('https://i.pinimg.com/564x/e9/2c/42/e92c42e629bfdfcdfdfb1bf2c57039de.jpg'), // Placeholder image
//         radius: 20,
//       ),
//       title: Text(
//         widget.notification.title,
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.notification.body,
//             style: TextStyle(color: Colors.grey[700]),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             _formatTimestamp(widget.notification.timestamp),
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//         ],
//       ),
//       trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
//       onTap: () {
//         _databaseService.markNotificationAsRead(widget.notification.id);
//       },
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/screens/request_ticket/ticket_request_detail.dart';
import 'package:ticket_resell/screens/request_ticket/ticket_request_for_buyer_detail.dart';
import 'package:ticket_resell/services/database_service.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;
  const NotificationTile({Key? key, required this.notification}) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  final GetIt _getIt = GetIt.instance;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('HH:mm dd/MM/yyyy').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.notification.isRead ? Colors.white : Colors.blue[50], // Background color for unread
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://i.pinimg.com/564x/e9/2c/42/e92c42e629bfdfcdfdfb1bf2c57039de.jpg'), // Placeholder image
          radius: 20, 
        ),
        title: Text(
          widget.notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notification.body,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(widget.notification.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: () {
          print("----------==========================--------------------");
          print(widget.notification.id);
          _databaseService.markNotificationAsRead(widget.notification.id);
          getTicketRequest(widget.notification.ticketRequestId!);
          //Get.to(() => const TicketRequestDetailScreen(ticketRequest: ticketRequest));
        },
      ),
    );
  }

  Future<void> getTicketRequest(int ticketRequestId) async {
    final url = 'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/get-ticket-request-by-id?ticketRequestId=$ticketRequestId';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    //final body = jsonEncode({'email': email});

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
        //body: body,
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        TicketRequest ticketRequest = TicketRequest.fromJson(responseData['content']);
        if(widget.notification.status.toLowerCase() == 'request'){
          Get.to(() => TicketRequestDetailScreen(ticketRequest: ticketRequest));
        }else{
          if(widget.notification.status.toLowerCase() == 'accept'){
            Get.to(() => TicketRequestForBuyerDetailScreen(ticketRequest: ticketRequest));
          }
        }

      } else {
        print('Failed to check email');
        Get.snackbar('Error', 'Failed to check email: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar('Error', 'An error occurred: $error');
    }
  }



}

