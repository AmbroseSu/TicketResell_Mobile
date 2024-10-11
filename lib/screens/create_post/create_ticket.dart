import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/create_post/upload_file.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../login/login.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  _CreateTicketState createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  String? selectedCategory;
  TextEditingController _dateController = TextEditingController(); // Controller for the Date field

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                'Create New Post',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              Form(
                child: Column(
                  children: [
                    /// Ticket Name
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ticket Name',
                        prefixIcon: Icon(Iconsax.ticket),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Price
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Iconsax.money),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Quantity
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Iconsax.password_check),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Expire Date (with Date Picker)
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Expire Date',
                        prefixIcon: Icon(Iconsax.calendar),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context), // Open date picker
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Address
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: TTexts.address,
                        prefixIcon: Icon(Iconsax.location),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Category Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Iconsax.user_tag),
                      ),
                      dropdownColor: Colors.white,
                      value: selectedCategory,
                      items: <String>['Events', 'Live Concert', 'Movies', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
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
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Post Title
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Post Title',
                        prefixIcon: Icon(Icons.post_add),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Description
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    /// Create Date (with Date Picker)
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Create Date',
                        prefixIcon: Icon(Iconsax.calendar),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context), // Open date picker
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

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
                        const SizedBox(width: TSizes.spaceBtwItems),
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
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Create New Post Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UploadFile()),
                        );
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
                            style: GoogleFonts.getFont(
                              "Roboto Condensed",
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
