import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/screens/platform_fee/single_platform.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PlatformFeeScreen extends StatefulWidget {
  const PlatformFeeScreen({super.key});

  @override
  State<PlatformFeeScreen> createState() => _PlatformFeeScreenState();
}

class _PlatformFeeScreenState extends State<PlatformFeeScreen> {
  List<dynamic> platformFees = [];

  @override
  void initState() {
    super.initState();
    fetchPlatformFees();
  }

  Future<void> fetchPlatformFees() async {
    final url = Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/PlatformFee/get-platform-fee/all?page=1&limit=1000');

    try {
      final response = await http.get(url,headers: {
        "Authorization": 'Bearer ${UserManager().token}'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          platformFees = data['content'];
        });
      } else {
        print('Failed to load platform fees');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Platform Fee',
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: platformFees.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: platformFees.map((fee) {
                    return TSinglePlatform(
                      name: fee['name'],
                      quantity: fee['quantity'],
                      price: fee['price'].toString(),
                      platformFeeId: fee['id'],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
