import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_resell/api/response/checkout_package_fee.dart';

// Đảm bảo rằng bạn đã có lớp CheckoutPackageFee và nhập nó từ file của bạn

class QrCodePlatformScreen extends StatelessWidget {
  final CheckoutPackageFee checkoutPackageFee;

  const QrCodePlatformScreen({Key? key, required this.checkoutPackageFee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Hiển thị mã QR
            QrImageView(
              data: checkoutPackageFee.qrCode, // Sử dụng chuỗi QR từ đối tượng
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            // Thông tin bổ sung về giao dịch
            Text(
              "Order Code: ${checkoutPackageFee.orderCode}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Amount: ${checkoutPackageFee.amount.toString()} VND",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: ${checkoutPackageFee.status}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Payment Link ID: ${checkoutPackageFee.paymentLinkId}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Link Checkout
            ElevatedButton(
              onPressed: () {
                // Mở URL thanh toán nếu người dùng muốn
                // Sử dụng phương pháp mở URL bằng trình duyệt hoặc in-app browser
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Go to Checkout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
