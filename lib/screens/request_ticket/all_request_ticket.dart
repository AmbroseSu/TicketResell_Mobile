import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/ticket_request.dart';
import 'package:ticket_resell/screens/request_ticket/all_ticket_seller.dart';
import 'package:ticket_resell/screens/request_ticket/ticket_request_detail.dart';

class AllRequestTicketScreen extends StatefulWidget {
  final int ticketId;

  const AllRequestTicketScreen({super.key, required this.ticketId});

  @override
  _AllRequestTicketScreenState createState() => _AllRequestTicketScreenState();
}

class _AllRequestTicketScreenState extends State<AllRequestTicketScreen> {
  List<TicketRequest> requests = [];

  @override
  void initState() {
    super.initState();
    print(")))))))))))))))))))))))))))))))))0000000000000000000");
    print(widget.ticketId);
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/get-ticket-request?ticketId=${widget.ticketId}&page=1&limit=1000'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        requests = (data['content'] as List)
            .map((json) => TicketRequest.fromJson(json))
            .toList();
      });
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }

  Future<void> _updateRequestStatus(int index) async {
    setState(() async {
      // Cập nhật trạng thái của yêu cầu đã xác nhận
      //requests[index]['status'] = 'Confirmed';

      // Cập nhật trạng thái của các yêu cầu khác thành Rejected
      // for (int i = 0; i < requests.length; i++) {
      //   if (i != index) {
      //     requests[i]['status'] = 'Rejected';
      //   }
      // }
      //Get.to(() => AllRequestTicketScreen());

      final ticketRequestId = requests[index].id;
      final url = Uri.parse(
          'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketRequest/confirm-ticket-request?ticketRequestId=$ticketRequestId');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
          "Authorization": 'Bearer ${UserManager().token}'

      };
      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Yêu cầu của ${requests[index].userFullname} đã được chấp nhận.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AllRequestTicketScreen(
                    ticketId: widget.ticketId,
                  )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sắp xếp danh sách requests
    // Sắp xếp danh sách requests
    requests.sort((a, b) {
      // Hàm xác định mức độ ưu tiên của các trạng thái
      int getStatusPriority(int status) {
        if (status == 0) return 0; // Pending
        if (status == 1) return 1; // Confirmed
        if (status == 2) return 2; // Rejected
        return 3; // Trường hợp không xác định
      }

      // So sánh thứ tự ưu tiên của trạng thái
      int statusComparison =
          getStatusPriority(a.status).compareTo(getStatusPriority(b.status));
      if (statusComparison != 0) return statusComparison;

      // Nếu cả hai đều là Pending (status == 0), sắp xếp theo giá giảm dần
      if (a.status == 0 && b.status == 0) {
        return b.price.compareTo(a.price); // Giá cao hơn lên trên
      }

      // Nếu cả hai đều là Confirmed (status == 1), sắp xếp theo ngày gần nhất (giảm dần)
      if (a.status == 1 && b.status == 1) {
        DateTime dateA = a.ticketRequestDate;
        DateTime dateB = b.ticketRequestDate;
        return dateB.compareTo(dateA); // Ngày gần nhất lên trên (giảm dần)
      }

      return 0; // Giữ nguyên thứ tự nếu trạng thái giống nhau và không phải Pending hoặc Confirmed
    });

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
          final requestDate = request.ticketRequestDate;
          final formattedDate =
              DateFormat('dd/MM/yyyy').format(request.ticketRequestDate);
          final status = request.status;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TicketRequestDetailScreen(ticketRequest: request),
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
}
