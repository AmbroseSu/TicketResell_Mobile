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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedTicket;
  List<String> tickets = [];
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketDescriptionController = TextEditingController();

  TimeOfDay? selectedTime;
  Map<String, int> TicketMap = {};
  int? number;

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

  Future<void> getnumber() async {
    final response = await http.get(Uri.parse(
        'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Quota/get-total-quota/${UserManager().id}'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        });
    print(response.statusCode);
    var responseData = jsonDecode(response.body);
    if (responseData['statusCode'] == 200) {
      final data = json.decode(response.body);
      setState(() {
        number = int.parse(data['content']);
      });
    } else {
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi hoặc xử lý khác)
      print('Failed to load tickets');
    }
  }

// Fetch categories from the API
  Future<void> fetchTicketNames() async {
    final int? userId = UserManager().id;

    final response = await http.get(
      Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/get-user?status=ACTIVE&id=$userId&page=1&limit=100"),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
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
      if (!_formKey.currentState!.validate()) {
        return; // Nếu có lỗi, dừng lại và không gọi API
      }
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
        headers: {"Content-Type": "application/json",
            "Authorization": 'Bearer ${UserManager().token}'
          },
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Sử dụng GlobalKey để quản lý trạng thái form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _ticketNameController,
                  decoration: InputDecoration(
                    labelText: 'Post Title',
                    prefixIcon: Icon(Icons.post_add),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a post title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ticketDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Ticket',
                    prefixIcon: Icon(Iconsax.user_tag),
                    border: OutlineInputBorder(),
                  ),
                  value: selectedTicket,
                  items: tickets.isEmpty
                      ? [DropdownMenuItem(child: Text("Loading..."))]
                      : tickets.map((String value) {
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a ticket';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      createPost();
                    }
                  },
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
        ),
      ),
    );
  }
}
