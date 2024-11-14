import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/post.dart';
import 'package:ticket_resell/styles&text&sizes/post_card_vertical.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/grid_layout.dart';



class SearchAllResult extends StatefulWidget {
  final String query;

  const SearchAllResult({super.key, required this.query});

  @override
  _SearchAllResultState createState() => _SearchAllResultState();
}

class _SearchAllResultState extends State<SearchAllResult> {
  List<PostResponse> searchResults = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    try {
      final response = await http.get(Uri.parse(
          'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/get-lists?status=ACTIVE&searchTerm=${widget.query}&page=1&limit=100'),
          headers: {
            "Authorization": 'Bearer ${UserManager().token}'
          });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          searchResults = (data['content'] as List)
              .map((json) => PostResponse.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load search results');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching search results: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Search Results',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : searchResults.isEmpty
          ? Center(child: Text("No results found")) // Message if no results
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: TGridLayout(
            itemCount: searchResults.length,
            itemBuilder: (_, index) => PostCardVertical(
              postResponse: searchResults[index],
            ),
          ),
        ),
      ),
    );
  }
}





