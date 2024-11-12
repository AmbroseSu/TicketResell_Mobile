import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/navigation_menu.dart';
import 'package:ticket_resell/screens/create_post/upload_file.dart';
import '../../api/global_variables/user_manage.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../../widgets/appbar.dart';
import '../../widgets/t_circular_icon.dart';
import '../login/login.dart';
import 'package:http/http.dart' as http;
//
// class CreateTicket extends StatefulWidget {
//   const CreateTicket({super.key});
//
//   @override
//   _CreateTicketState createState() => _CreateTicketState();
// }
//
// class _CreateTicketState extends State<CreateTicket> {
//   String? selectedCategory;
//   List<String> categories = [];
//   TextEditingController _dateController = TextEditingController(); // Controller for the Date field
//   TextEditingController _timeController = TextEditingController(); // Controller for the Time field
//   TimeOfDay? selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories(); // Gọi API khi trang được tải
//   }
//
//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchCategories() async {
//     final response = await http.get(
//       Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketCategory/categories?page=1&limit=100'),
//     );
//
//     if (response.statusCode == 200) {
//       // Parse JSON và cập nhật danh sách categories
//       final data = json.decode(response.body);
//       setState(() {
//         categories = List<String>.from(data['data'].map((category) => category['name']));
//       });
//     } else {
//       // Nếu có lỗi khi gọi API
//       throw Exception('Failed to load categories');
//     }
//   }
//   Future<void> _selectDate(BuildContext context) async {
//     // Show date picker
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//       });
//       // Once a date is picked, show time picker
//       _selectTime(context, pickedDate);
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context, DateTime pickedDate) async {
//     // Show time picker
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//         _timeController.text = "${pickedTime.format(context)}";
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       backgroundColor: Colors.white,
//       title: Text('Create New Ticket', style: Theme.of(context).textTheme.headlineMedium),
//       centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => NavigationMenu()),
//             );
//           },
//         ),
//     ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: TSizes.defaultSpace,
//             right: TSizes.defaultSpace,
//             top: TSizes.defaultSpace * 1,
//             bottom: TSizes.defaultSpace * 0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Form
//               Form(
//                 child: Column(
//                   children: [
//                     /// Post Title
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Post Title',
//                         prefixIcon: Icon(Icons.post_add),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                     /// Description
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Description',
//                         prefixIcon: Icon(Icons.description),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                     /// Ticket Name
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Ticket Name',
//                         prefixIcon: Icon(Iconsax.ticket),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                     /// Price
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Price',
//                         prefixIcon: Icon(Iconsax.money),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                     /// Quantity
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Quantity',
//                         prefixIcon: Icon(Iconsax.password_check),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                     /// Expire Date (with Date and Time Picker)
//                     TextFormField(
//                       controller: _dateController,
//                       decoration: const InputDecoration(
//                         labelText: 'Expire Date',
//                         prefixIcon: Icon(Iconsax.calendar),
//                         suffixIcon: Icon(Icons.calendar_today),
//                       ),
//                       readOnly: true,
//                       onTap: () => _selectDate(context), // Open date picker
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     // Time (optional field to show selected time)
//                     TextFormField(
//                       controller: _timeController,
//                       decoration: const InputDecoration(
//                         labelText: 'Expire Time',
//                         prefixIcon: Icon(Icons.access_time),
//                       ),
//                       readOnly: true,
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     /// venue
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: TTexts.address,
//                         prefixIcon: Icon(Iconsax.location),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                     /// Category Dropdown
//                     DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Category',
//                         prefixIcon: Icon(Iconsax.user_tag),
//                       ),
//                       dropdownColor: Colors.white,
//                       value: selectedCategory,
//                       items: categories.isNotEmpty
//                           ? categories.map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList()
//                           : [
//                         const DropdownMenuItem<String>(
//                           value: null,
//                           child: Text('Loading...'),
//                         ),
//                       ],
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedCategory = newValue;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//
//
//                     /// Terms & Conditions Checkbox
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: Checkbox(
//                             value: true,
//                             onChanged: (value) {},
//                             checkColor: Colors.white,
//                             activeColor: Colors.blueAccent,
//                             side: const BorderSide(color: Colors.black),
//                           ),
//                         ),
//                         const SizedBox(width: TSizes.spaceBtwItems),
//                         Text.rich(
//                           TextSpan(children: [
//                             TextSpan(
//                                 text: 'By using TicketResell, you agree to ',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                             TextSpan(
//                                 text: 'Terms ',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium!
//                                     .apply(
//                                     color: Colors.black,
//                                     decorationColor: Colors.black)),
//                             TextSpan(
//                                 text: 'and ',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                             TextSpan(
//                                 text: '\nPrivacy Policy',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium!
//                                     .apply(
//                                     color: Colors.black,
//                                     decorationColor: Colors.black)),
//                           ]),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwSections),
//
//                     /// Create New Post Button
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const UploadFile()),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.blueAccent,
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Create",
//                             style: GoogleFonts.getFont(
//                               "Roboto Condensed",
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//
// class CreateTicket extends StatefulWidget {
//   const CreateTicket({super.key});
//
//   @override
//   _CreateTicketState createState() => _CreateTicketState();
// }
//
// class _CreateTicketState extends State<CreateTicket> {
//   String? selectedCategory;
//   List<String> categories = [];
//   TextEditingController _dateController = TextEditingController();
//   TimeOfDay? selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();  // Fetch categories when the widget is initialized
//   }
//
//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }
//
//   // Fetch categories from the API
//   Future<void> fetchCategories() async {
//     final response = await http.get(
//       Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketCategory/categories?page=1&limit=1000"),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<String> fetchedCategories = [];
//       for (var category in data['content']) {
//         fetchedCategories.add(category['name']);
//       }
//       setState(() {
//         categories = fetchedCategories;
//       });
//     } else {
//       // Handle the error
//       throw Exception('Failed to load categories');
//     }
//   }
//
//   // Date and time picker logic
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       _selectTime(context, pickedDate);
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context, DateTime pickedDate) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//         // Combine date and time into a single string
//         _dateController.text =
//         "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} ${pickedTime.format(context)}";
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Create New Ticket', style: Theme.of(context).textTheme.headlineMedium),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => NavigationMenu()),
//             );
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             top: 16.0,
//             bottom: 0,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Form
//               Form(
//                 child: Column(
//                   children: [
//
//                     /// Ticket Name
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Ticket Name',
//                         prefixIcon: Icon(Iconsax.ticket),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Price
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Price',
//                         prefixIcon: Icon(Iconsax.money),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Quantity
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Quantity',
//                         prefixIcon: Icon(Iconsax.password_check),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Expire Date (with Date and Time Picker)
//                     TextFormField(
//                       controller: _dateController,
//                       decoration: const InputDecoration(
//                         labelText: 'Expire Date',
//                         prefixIcon: Icon(Iconsax.calendar),
//                         suffixIcon: Icon(Icons.calendar_today),
//                       ),
//                       readOnly: true,
//                       onTap: () => _selectDate(context), // Open date picker
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Venue
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Venue',
//                         prefixIcon: Icon(Iconsax.location),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Category Dropdown
//                     DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Category',
//                         prefixIcon: Icon(Iconsax.user_tag),
//                       ),
//                       dropdownColor: Colors.white,
//                       value: selectedCategory,
//                       items: categories.isEmpty
//                           ? [DropdownMenuItem(child: Text("Loading..."))]  // Show loading indicator if categories are not fetched
//                           : categories.map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedCategory = newValue;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Terms & Conditions Checkbox
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: Checkbox(
//                             value: true,
//                             onChanged: (value) {},
//                             checkColor: Colors.white,
//                             activeColor: Colors.blueAccent,
//                             side: const BorderSide(color: Colors.black),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text.rich(
//                           TextSpan(children: [
//                             TextSpan(
//                                 text: 'By using TicketResell, you agree to ',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                             TextSpan(
//                                 text: 'Terms ',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium!
//                                     .apply(
//                                     color: Colors.black,
//                                     decorationColor: Colors.black)),
//                             TextSpan(
//                                 text: 'and ',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                             TextSpan(
//                                 text: '\nPrivacy Policy',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium!
//                                     .apply(
//                                     color: Colors.black,
//                                     decorationColor: Colors.black)),
//                           ]),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//
//                     /// Create New Post Button
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const UploadFile()),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.blueAccent,
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Create",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//
// class CreateTicket extends StatefulWidget {
//   const CreateTicket({super.key});
//
//   @override
//   _CreateTicketState createState() => _CreateTicketState();
// }
//
// class _CreateTicketState extends State<CreateTicket> {
//   final int? userId = UserManager().id;
//   String? selectedCategory;
//   List<String> categories = [];
//   TextEditingController _dateController = TextEditingController();
//   TextEditingController _ticketNameController = TextEditingController();
//   TextEditingController _priceController = TextEditingController();
//   TextEditingController _quantityController = TextEditingController();
//   TextEditingController _venueController = TextEditingController();
//   TimeOfDay? selectedTime;
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories(); // Fetch categories on initialization
//   }
//
//   @override
//   void dispose() {
//     _dateController.dispose();
//     _ticketNameController.dispose();
//     _priceController.dispose();
//     _quantityController.dispose();
//     _venueController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchCategories() async {
//     final response = await http.get(
//       Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/TicketCategory/categories?page=1&limit=1000"),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<String> fetchedCategories = [];
//       for (var category in data['content']) {
//         fetchedCategories.add(category['name']);
//       }
//       setState(() {
//         categories = fetchedCategories;
//       });
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
//
//   // Future<void> createTicket() async {
//   //   final expirationDate = _dateController.text;
//   //   final response = await http.post(
//   //     Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/new"),
//   //     headers: {"Content-Type": "application/json"},
//   //     body: jsonEncode({
//   //       "name": _ticketNameController.text,
//   //       "price": int.tryParse(_priceController.text) ?? 0,
//   //       "quantity": int.tryParse(_quantityController.text) ?? 1,
//   //       "expirationDate": expirationDate,
//   //       "venue": _venueController.text,
//   //       "categoryId": selectedCategory != null ? categories.indexOf(selectedCategory!) + 1 : null,
//   //       "userId": userId,
//   //     }),
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     final data = json.decode(response.body);
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //       content: Text(data['message'] ?? "Ticket created successfully"),
//   //     ));
//   //     // Navigate to the next page, e.g., UploadFile
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => const UploadFile()),
//   //     );
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Failed to create ticket')),
//   //     );
//   //   }
//   // }
//   Future<void> createTicket() async {
//     final expirationDate = _dateController.text;
//     final response = await http.post(
//       Uri.parse("https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Ticket/new"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "name": _ticketNameController.text,
//         "price": int.tryParse(_priceController.text) ?? 0,
//         "quantity": int.tryParse(_quantityController.text) ?? 1,
//         "expirationDate": expirationDate,
//         "venue": _venueController.text,
//         "categoryId": selectedCategory != null ? categories.indexOf(selectedCategory!) + 1 : null,
//         "userId": userId,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(data['message'] ?? "Ticket created successfully"),
//       ));
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const UploadFile()),
//       );
//     } else {
//       print("Error: ${response.statusCode}");
//       print("Response: ${response.body}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create ticket')),
//       );
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       _selectTime(context, pickedDate);
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context, DateTime pickedDate) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//         _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} ${pickedTime.format(context)}";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Create New Ticket', style: Theme.of(context).textTheme.headlineMedium),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => NavigationMenu()),
//             );
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: Form(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _ticketNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ticket Name',
//                     prefixIcon: Icon(Iconsax.ticket),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _priceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Price',
//                     prefixIcon: Icon(Iconsax.money),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _quantityController,
//                   decoration: const InputDecoration(
//                     labelText: 'Quantity',
//                     prefixIcon: Icon(Iconsax.password_check),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _dateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Expire Date',
//                     prefixIcon: Icon(Iconsax.calendar),
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () => _selectDate(context),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _venueController,
//                   decoration: const InputDecoration(
//                     labelText: 'Venue',
//                     prefixIcon: Icon(Iconsax.location),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: 'Category',
//                     prefixIcon: Icon(Iconsax.user_tag),
//                   ),
//                   dropdownColor: Colors.white,
//                   value: selectedCategory,
//                   items: categories.isEmpty
//                       ? [DropdownMenuItem(child: Text("Loading..."))]
//                       : categories.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedCategory = newValue;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: createTicket,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.blueAccent,
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Create",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
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
    try {
      if (_ticketNameController.text.isEmpty ||
          _priceController.text.isEmpty ||
          _quantityController.text.isEmpty ||
          selectedCategory == null ||
          _venueController.text.isEmpty ||
          pickedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
        return;
      }

      final expirationDate = _dateController.text.isNotEmpty ? _dateController.text : null;

      print('Ticket Name: ${_ticketNameController.text}');
      print('Price: ${_priceController.text}');
      print('Quantity: ${_quantityController.text}');
      print('Expiration Date: $expirationDate');
      print('Venue: ${_venueController.text}');
      print('Selected Category: $selectedCategory');
      print('Category ID: ${categoryMap[selectedCategory]}');
      print('User ID: $userId');

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message'] ?? "Ticket created successfully"),
        ));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadFile()),
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
            child: Column(
              children: [
                TextFormField(
                  controller: _ticketNameController,
                  decoration: const InputDecoration(
                    labelText: 'Ticket Name',
                    prefixIcon: Icon(Iconsax.ticket),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Iconsax.money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Iconsax.password_check),
                  ),
                  keyboardType: TextInputType.number,
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
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _venueController,
                  decoration: const InputDecoration(
                    labelText: 'Venue',
                    prefixIcon: Icon(Iconsax.location),
                  ),
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
