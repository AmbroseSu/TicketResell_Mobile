import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/response/post.dart';
import 'package:ticket_resell/styles&text&sizes/post_card_vertical.dart';
import '../../api/global_variables/user_manage.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/grid_layout.dart';


class AllYourPost extends StatefulWidget {
  const AllYourPost({super.key});

  @override
  _AllYourPostState createState() => _AllYourPostState();
}

class _AllYourPostState extends State<AllYourPost> {
  List<PostResponse> posts = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final int? userId = UserManager().id;

    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-by-user?status=ACTIVE&id=$userId&page=1&limit=100'));
    print(response.statusCode);
    var responseData = jsonDecode(response.body);
    if (responseData['statusCode'] == 200) {
      final data = json.decode(response.body);
      setState(() {
        posts = (data['content'] as List)
            .map((json) => PostResponse.fromJson(json))
            .toList();
      });
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
        title: Text('All Your Posts', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TGridLayout(itemCount: posts.length, itemBuilder: (_, index) => PostCardVertical(postResponse: posts[index],))
            ],
          ),
        ),
      ),
    );
  }
}
