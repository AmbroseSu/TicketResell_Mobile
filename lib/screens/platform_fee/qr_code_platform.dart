import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/checkout_package_fee.dart';
import 'package:ticket_resell/screens/explore_screen.dart';

// Đảm bảo rằng bạn đã có lớp CheckoutPackageFee và nhập nó từ file của bạn
class QrCodePlatformScreen extends StatefulWidget {
  final CheckoutPackageFee checkoutPackageFee;

  const QrCodePlatformScreen({Key? key, required this.checkoutPackageFee})
      : super(key: key);

  @override
  _QrCodePlatformScreenState createState() => _QrCodePlatformScreenState();
}

class _QrCodePlatformScreenState extends State<QrCodePlatformScreen> {
  String? status;
  late Timer _timer;  // Declare the Timer object

  // Fetch status function
  Future<void> fetchStatus() async {
    Map<String, String> headers = {
      'x-client-id': '46d20310-c620-4e3b-a687-6c363f6e21a5',
      'x-api-key': '02f8d2e9-cbf0-4bae-a9fd-7d7d6c57537e',
    };
    final response = await http.get(Uri.parse(
        'https://api-merchant.payos.vn/v2/payment-requests/${widget.checkoutPackageFee.orderCode}'), headers: headers);

    print(widget.checkoutPackageFee.orderCode);
    print(response.statusCode); // For debugging
    print(response.body); // For debugging
    var responseData = jsonDecode(response.body);

    if (responseData['code'] == "00") {
      setState(() {
        status = responseData['data']['status'];
      });

      print("Updated status: $status");

      // If the status has changed to PAID or CANCELED, stop the polling
      if (status == 'PAID' || status == 'CANCELED') {
        _timer.cancel();
        await changeStatus(widget.checkoutPackageFee.orderCode);// Stop polling if status is either PAID or CANCELED
      }
    } else {
      print('Failed to load status');
    }
  }

  Future<void> changeStatus(int orderId) async {
    final response = await http.post(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Transaction/update-status-transaction?orderCode=$orderId&status=SUCCESS'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        });

    print(widget.checkoutPackageFee.orderCode);
    print(response.statusCode); // For debugging
    print(response.body); // For debugging
  }

  @override
  void initState() {
    super.initState();
    // Start polling when the screen is loaded
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // Only fetch status if status is not 'PAID' or 'CANCELED'
      if (status != 'PAID' && status != 'CANCELED') {
        fetchStatus();  // Load lại màn hình sau 2 giây
      } else {
        _timer.cancel();  // Stop polling if status is 'PAID' or 'CANCELED'
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();  // Make sure to cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Details"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "If you have paid money for the platform, \nyou must wait for the status to change\nbefore you can go back or continue.",
                  textAlign: TextAlign.center,  // Căn giữa văn bản
                  style: const TextStyle(
                    fontSize: 20,  // Tăng kích thước chữ để dễ đọc
                    fontWeight: FontWeight.bold,  // Làm đậm văn bản
                    color: Colors.black,  // Chọn màu chữ cho dễ nhìn
                    height: 1.5,  // Tăng khoảng cách dòng để văn bản không bị chồng lên nhau
                  ),
                ),
                QrImageView(
                  data: widget.checkoutPackageFee.qrCode,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 20),
                Text(
                  "Order Code: ${widget.checkoutPackageFee.orderCode}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price: ${widget.checkoutPackageFee.amount.toString()} VND",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Status: ${status ?? widget.checkoutPackageFee.status}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: status == 'PAID'
                        ? Colors.green
                        : (status == 'CANCELED' ? Colors.red : Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ExploreScreen(),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //   ),
                //   child: const Text(
                //     "Back to Home",
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}