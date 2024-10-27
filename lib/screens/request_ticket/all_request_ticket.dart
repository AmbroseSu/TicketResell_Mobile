import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticket_resell/screens/request_ticket/all_ticket.dart';

class AllRequestTicketScreen extends StatefulWidget {
  const AllRequestTicketScreen({super.key});

  @override
  _AllRequestTicketScreenState createState() => _AllRequestTicketScreenState();
}

class _AllRequestTicketScreenState extends State<AllRequestTicketScreen> {
  final List<Map<String, dynamic>> requests = [
    {
      'senderName': 'John Doe',
      'price': 120.0,
      'quantity': 2,
      'requestDate': '2024-10-12',
      'status': 'Pending', // Trạng thái ban đầu
    },
    {
      'senderName': 'Jane Smith',
      'price': 75.0,
      'quantity': 1,
      'requestDate': '2024-10-15',
      'status': 'Reject', // Trạng thái ban đầu
    },
    {
      'senderName': 'Alice Johnson',
      'price': 200.0,
      'quantity': 3,
      'requestDate': '2024-10-08',
      'status': 'Confirmed', // Trạng thái ban đầu
    },
    {
      'senderName': 'Bob Brown',
      'price': 50.0,
      'quantity': 5,
      'requestDate': '2024-10-20',
      'status': 'Pending', // Trạng thái ban đầu
    },
    {
      'senderName': 'Ambrose',
      'price': 80.0,
      'quantity': 6,
      'requestDate': '2024-10-20',
      'status': 'Confirmed', // Trạng thái ban đầu
    },
    {
      'senderName': 'NamLee',
      'price': 80.0,
      'quantity': 6,
      'requestDate': '2024-10-20',
      'status': 'Rejected', // Trạng thái ban đầu
    },
    {
      'senderName': 'Tan Loc',
      'price': 90.0,
      'quantity': 6,
      'requestDate': '2024-10-20',
      'status': 'Pending', // Trạng thái ban đầu
    },
    {
      'senderName': 'Wiramin',
      'price': 20.0,
      'quantity': 6,
      'requestDate': '2024-10-20',
      'status': 'Pending', // Trạng thái ban đầu
    },
  ];

  void _updateRequestStatus(int index) {
    setState(() {
      // Cập nhật trạng thái của yêu cầu đã xác nhận
      requests[index]['status'] = 'Confirmed';

      // Cập nhật trạng thái của các yêu cầu khác thành Rejected
      // for (int i = 0; i < requests.length; i++) {
      //   if (i != index) {
      //     requests[i]['status'] = 'Rejected';
      //   }
      // }
      //Get.to(() => AllRequestTicketScreen());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllRequestTicketScreen()),
      );
    });

    // Hiển thị thông báo xác nhận
    Fluttertoast.showToast(
      msg: "Yêu cầu của ${requests[index]['senderName']} đã được chấp nhận.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sắp xếp danh sách requests
    requests.sort((a, b) {
      // Sắp xếp theo thứ tự: Pending > Confirmed > Rejected
      int getStatusPriority(String status) {
        if (status == 'Pending') return 0;
        if (status == 'Confirmed') return 1;
        if (status == 'Rejected') return 2;
        return 3; // Trường hợp không xác định
      }

      // So sánh thứ tự ưu tiên
      int statusComparison = getStatusPriority(a['status']).compareTo(getStatusPriority(b['status']));
      if (statusComparison != 0) return statusComparison;

      // Nếu cả hai đều là Pending, sắp xếp theo giá giảm dần
      if (a['status'] == 'Pending' && b['status'] == 'Pending') {
        return b['price'].compareTo(a['price']);
      }

      return 0; // Giữ nguyên thứ tự nếu trạng thái giống nhau và không phải Pending
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
          final senderName = request['senderName'];
          final price = request['price'];
          final quantity = request['quantity'];
          final requestDate = request['requestDate'];
          final status = request['status'];

          return Card(
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
                          Text("Request Date: $requestDate"),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: status == 'Pending'
                              ? Colors.blueAccent
                              : (status == 'Confirmed' ? Colors.green : Colors.red),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: status == 'Pending'
                            ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Xác nhận"),
                                content: const Text("Bạn có chắc chắn muốn chấp nhận yêu cầu này không?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _updateRequestStatus(index);
                                    },
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                            : () {},
                        child: Text(
                          status == 'Pending' ? "Accept" : (status == 'Confirmed' ? "Confirm" : "Reject"),
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
          );
        },
      ),
    );
  }
}
