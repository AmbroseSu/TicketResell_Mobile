import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/screens/password/create_newpass.dart';

import '../../navigation_menu.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';




class FillInfoSignupGoogleForm extends StatefulWidget {
  const FillInfoSignupGoogleForm({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<FillInfoSignupGoogleForm> {
  final _formKey = GlobalKey<FormState>();  // GlobalKey to validate the form
  String? selectedGender;
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,  // Attach the form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fill Your Information',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Fullname
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Phone number
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: TTexts.phoneNo,
                    prefixIcon: Icon(Iconsax.call),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number is required';
                    }
                    if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                      return 'Phone Number must start with 0 and have 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: TTexts.address,
                    prefixIcon: Icon(Iconsax.location),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }
                    if (!value.contains(',')) {
                      return 'Please enter a valid address with street and city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Iconsax.user_tag),
                  ),
                  dropdownColor: Colors.white,
                  value: selectedGender,
                  items: <String>['Female', 'Male', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Iconsax.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[!@#\$&*~])').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter and one special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Terms&Conditions Checkbox
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
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'By using TripWonder, you agree to ',
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
                            text: 'Privacy Policy',
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

                // Sign Up Button
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNewpass()),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                      child: Text(
                        TTexts.createAccount,
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
        ),
      ),
    );
  }
}
