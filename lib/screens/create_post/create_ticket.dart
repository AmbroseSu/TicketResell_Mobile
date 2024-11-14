import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/navigation_menu.dart';
import 'package:ticket_resell/screens/create_post/upload_file.dart';
import '../../api/global_variables/user_manage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  _CreateTicketState createState() => _CreateTicketState();
}


class _CreateTicketState extends State<CreateTicket> {
  final int? userId = UserManager().id;
  String? selectedCategory;
  List<String> categories = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  DateTime? pickedDate;
  TimeOfDay? selectedTime;
  Map<String, int> categoryMap = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories on initialization
  }

  @override
  void dispose() {
    _dateController.dispose();
    _ticketNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketCategory/categories?page=1&limit=1000"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> fetchedCategories = [];

      for (var category in data['content']) {
        fetchedCategories.add(category['name']);
        categoryMap[category['name']] = category['id'];
      }

      setState(() {
        categories = fetchedCategories;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> createTicket() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final expirationDate = _dateController.text.isNotEmpty ? _dateController.text : null;

      // Validate expiration date
      if (expirationDate != null) {
        DateTime selectedDate = DateFormat("dd/MM/yyyy HH:mm").parse(expirationDate);

        DateTime currentDate = DateTime.now();
        DateTime oneYearLater = currentDate.add(Duration(days: 365));

        if (selectedDate.isBefore(currentDate) || selectedDate.isAfter(oneYearLater)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid date. Please choose expiration date again')),
          );
          return;
        }
      }

      final response = await http.post(
        Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/new"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _ticketNameController.text,
          "price": int.tryParse(_priceController.text) ?? 0,
          "quantity": int.tryParse(_quantityController.text) ?? 1,
          "expirationDate": expirationDate,
          "venue": _venueController.text,
          "categoryId": categoryMap[selectedCategory] ?? 0, // Ensure categoryId is valid
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ticketId = data['content']['id']; // Get ticketId from response

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message'] ?? "Ticket created successfully"),
        ));

        // Navigate to UploadFile screen and pass ticketId
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadFile(ticketId: ticketId)),
        );
      } else {
        print("Error: ${response.statusCode}");
        print("Response: ${response.body}"); // Print error response
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



  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _dateController.text = DateFormat("dd/MM/yyyy HH:mm").format(DateTime(
          pickedDate!.year,
          pickedDate!.month,
          pickedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Create New Ticket', style: Theme.of(context).textTheme.headlineMedium),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _ticketNameController,
                  decoration: const InputDecoration(
                    labelText: 'Ticket Name',
                    prefixIcon: Icon(Iconsax.ticket),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ticket name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Iconsax.money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final price = int.tryParse(value ?? '');
                    if (price == null || price < 20000) {
                      return 'Price must be at least 20,000';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Iconsax.password_check),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final quantity = int.tryParse(value ?? '');
                    if (quantity == null || quantity <= 0) {
                      return 'Quantity must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),


                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Expire Date',
                    prefixIcon: Icon(Iconsax.calendar),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Expiration date is required';
                    }

                    try {
                      DateTime selectedDate = DateFormat("dd/MM/yyyy HH:mm").parse(value);

                      DateTime currentDate = DateTime.now();
                      DateTime oneYearLater = currentDate.add(Duration(days: 365));

                      if (selectedDate.isBefore(currentDate) || selectedDate.isAfter(oneYearLater)) {
                        return 'Invalid date. Please choose expiration date again';
                      }
                    } catch (e) {
                      return 'Please enter a valid date';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _venueController,
                  decoration: const InputDecoration(
                    labelText: 'Venue',
                    prefixIcon: Icon(Iconsax.location),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Venue is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Iconsax.user_tag),
                  ),
                  dropdownColor: Colors.white,
                  value: selectedCategory,
                  items: categories.isEmpty
                      ? [DropdownMenuItem(child: Text("Loading..."))]
                      : categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Category is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: createTicket,
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
                          fontSize: 18,
                          color: Colors.white,
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
