import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/platform_fee/platform.dart';
import '../../api/global_variables/user_manage.dart';
import '../../navigation_menu.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String? selectedTicket;
  List<String> tickets = [];
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketDescriptionController = TextEditingController();

  TimeOfDay? selectedTime;
  Map<String, int> TicketMap = {};

  @override
  void initState() {
    super.initState();
    fetchTicketNames();  // Fetch categories when the widget is initialized
  }

  @override
  void dispose() {
    _dateController.dispose();
    _ticketNameController.dispose();
    _ticketDescriptionController.dispose();
    super.dispose();
  }

// Fetch categories from the API
  Future<void> fetchTicketNames() async {
    final int? userId = UserManager().id;

    final response = await http.get(
      Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get-user?id=$userId&page=1&limit=100"),
    );
    final data = json.decode(response.body);

    if (data['statusCode'] == 200) {

      // Populate tickets and TicketMap if 'content' exists
      if (data.containsKey('content') && data['content'] is List) {
        List<String> fetchedTickets = [];
        for (var ticket in data['content']) {
          String ticketName = ticket['ticketName'];
          int ticketId = ticket['ticketId'];

          fetchedTickets.add(ticketName);
          TicketMap[ticketName] = ticketId;
        }
        setState(() {
          tickets = fetchedTickets;
        });
      } else {
        print('Content field missing or is not a List');
      }
    } else {
      print('Failed to load tickets: ${response.statusCode}');
    }
  }

// Create post
  Future<void> createPost() async {
    try {
      if (_ticketNameController.text.isEmpty ||
          _ticketDescriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
        return;
      }

      // Check if selectedTicket exists in TicketMap
      int? ticketId = TicketMap[selectedTicket];
      if (ticketId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a valid ticket')));
        return;
      }

      final response = await http.post(
        Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Post/new"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": _ticketNameController.text,
          "description": _ticketDescriptionController.text,
          "ticketId": ticketId, // Use the ticketId from TicketMap
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message'] ?? "Post created successfully"),
        ));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlatformFeeScreen()),
        );
      } else {
        print("Error: ${response.statusCode}");
        print("Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create ticket: ${response.body}')),
        );
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while creating ticket: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Create New Post', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationMenu()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Form
              Form(
                child: Column(
                  children: [
                    /// Post Title
                    TextFormField(
                      controller: _ticketNameController,
                      decoration: const InputDecoration(
                        labelText: 'Post Title',
                        prefixIcon: Icon(Icons.post_add),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Description
                    TextFormField(
                      controller: _ticketDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Ticket Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Ticket',
                        prefixIcon: Icon(Iconsax.user_tag),
                      ),
                      dropdownColor: Colors.white,
                      value: selectedTicket,
                      items: tickets.isEmpty
                          ? [DropdownMenuItem(child: Text("Loading..."))]
                          : tickets.toSet().map((String value) {  // Convert to Set to ensure unique items
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedTicket = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Terms & Conditions Checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            checkColor: Colors.white,
                            activeColor: Colors.blueAccent,
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: 'By using TicketResell, you agree to ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: 'Terms ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                    color: Colors.black,
                                    decorationColor: Colors.black)),
                            TextSpan(
                                text: 'and ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: '\nPrivacy Policy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                    color: Colors.black,
                                    decorationColor: Colors.black)),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Create New Post Button
                    GestureDetector(
                      onTap: createPost,
                      //     () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const PlatformFeeScreen()),
                      //   );
                      // },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent,
                        ),
                        child: Center(
                          child: Text(
                            "Create",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
