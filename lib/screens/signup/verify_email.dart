import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/androidenterprise/v1.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/global_variables/fcm_token_manage.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/screens/signup/signup.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../../widgets/helper_functions.dart';
import '../login/login.dart';
import 'package:http/http.dart' as http;
import '../otp_verification/otp_verification.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> checkEmail(String email) async {
    final url = 'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Authentication/check-email?email=$email';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({'email': email});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if(responseData['message'] == "Please Sign Up"){
          Get.to(() => SignupScreen());
        }else{
          UserManager userManager = UserManager();
          userManager.id = responseData['content']['id'];
          userManager.email = responseData['content']['email'];
          userManager.role = responseData['content']['role'];

          // Chuyển đến OtpVerificationScreen với id và role
          Get.to(() => OtpVerificationScreen());
        }
        //final userId = responseData['content']['id'];
        //final userRole = responseData['content']['role'];
        //final userEmail = responseData['content']['email'];


      } else {
        print('Failed to check email');
        Get.snackbar('Error', 'Failed to check email: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar('Error', 'An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Image(
              //   image: const AssetImage(TImages.verifyEmailImage),
              //   width: THelperFunctions.screenWidth() * 0.6,
              // ),
              // const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                // TTexts.confirmEmailTitle,
                'Add your Email 1/3',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'support@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: TTexts.email,
                    prefixIcon: Icon(Iconsax.direct),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Kiểm tra định dạng email
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              GestureDetector(
                onTap: () {
                  final email = _emailController.text.trim();
                  if (_formKey.currentState?.validate() ?? false) {
                    // Kiểm tra email hợp lệ và gọi hàm checkEmail
                    checkEmail(email);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:  Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      TTexts.tContinue,
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
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(TTexts.resendEmail,style: TextStyle(color: Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
