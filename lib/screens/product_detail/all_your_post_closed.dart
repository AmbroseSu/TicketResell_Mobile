import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/response/post.dart';
import 'package:ticket_resell/styles&text&sizes/my_post_card_vertical.dart';
import 'package:ticket_resell/styles&text&sizes/post_card_vertical.dart';
import '../../api/global_variables/user_manage.dart';
import '../../api/response/post_element.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/grid_layout.dart';


class AllYourPostClosed extends StatefulWidget {
  final PostResponse postResponse;
  final List<PostElement> postElements;
  const AllYourPostClosed({super.key, required this.postResponse, required this.postElements});

  @override
  _AllYourPostClosedState createState() => _AllYourPostClosedState();
}



class _AllYourPostClosedState extends State<AllYourPostClosed> {
  //List<PostResponse> posts = [];

  @override
  void initState() {
    super.initState();
    //fetchTickets();
  }

  // Future<void> fetchTickets() async {
  //   final int? userId = UserManager().id;
  //
  //   final response = await http.get(Uri.parse(
  //       'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-by-user?status=CLOSED&id=$userId&page=1&limit=100'));
  //   print(response.statusCode);
  //   var responseData = jsonDecode(response.body);
  //   if (responseData['statusCode'] == 200) {
  //     final data = json.decode(response.body);
  //     setState(() {
  //       posts = (data['content'] as List)
  //           .map((json) => PostResponse.fromJson(json))
  //           .toList();
  //     });
  //   } else {
  //     // Handle error
  //     print('Failed to load tickets');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Your Closed Posts', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Check if posts is not empty
              if (widget.postElements.isEmpty)
                Center(
                  child: Text('No posts available', style: Theme.of(context).textTheme.bodyMedium),
                )
              else
                TGridLayout(
                  itemCount: widget.postElements.length,
                  itemBuilder: (_, index) => MyPostCardVertical(postResponse: widget.postResponse, postElement: widget.postElements[index], ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
