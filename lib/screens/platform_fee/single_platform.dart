import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/checkout_package_fee.dart';
import 'package:ticket_resell/screens/platform_fee/qr_code_platform.dart';
import 'package:ticket_resell/widgets/rounded_container.dart';
import '../../styles&text&sizes/colors.dart';
import '../../widgets/helper_functions.dart';
import 'package:http/http.dart' as http;


class TSinglePlatform extends StatefulWidget {
  final int platformFeeId;
  final String name;
  final int quantity;
  final String price;

  const TSinglePlatform({
    super.key,
    required this.platformFeeId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  _TSinglePlatform createState() => _TSinglePlatform();
}

class _TSinglePlatform extends State<TSinglePlatform> {

  UserManager userManager = UserManager();
  CheckoutPackageFee? checkoutPackageFee;
  bool isLoading = false;

  Future<void> generateQrCode({required int platformFeeId,
    required int userId,
  required int quantity,}) async {
    final url = Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Transaction/checkout-package-fee');
    final body = json.encode({
      'platformFeeId': platformFeeId,
      'userId': userId,
      'quantity': 1,
    });
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Yêu cầu thành công
        final data = json.decode(response.body);
        setState(() {
          checkoutPackageFee = CheckoutPackageFee.fromJson(data['content']);
        });

        print(checkoutPackageFee!.qrCode);
        //CheckoutPackageFee checkoutPackageFee = CheckoutPackageFee.fromJson(data);

        // Bạn có thể thêm logic xử lý khi thành công ở đây
      } else {
        // Xử lý lỗi nếu có
        print('Failed to create ticket request: ${response.body}');
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc các lỗi khác
      print('Error: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      backgroundColor: Colors.transparent,
      borderColor: dark ? TColors.darkerGrey : TColors.grey,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.quantity} slots',
                style: TextStyle(
                  fontSize: 20,
                  color: dark ? TColors.lightGrey : TColors.darkerGrey,
                ),
              ),
              Text(
                '${widget.price} VND',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

      ElevatedButton(
        onPressed: isLoading ? null : () async {
          setState(() {
            isLoading = true;
          });

          await generateQrCode(
            platformFeeId: widget.platformFeeId,
            userId: userManager.id ?? 0, 
            quantity: widget.quantity,
          );

          setState(() {
            isLoading = false;
          });

          if (checkoutPackageFee != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrCodePlatformScreen(checkoutPackageFee: checkoutPackageFee!),
              ),
            );
          } else {
            print('Failed to generate QR code: checkoutPackageFee is null');
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: TColors.primary,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'Book Now',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
        ],
      ),
    );
  }
}
