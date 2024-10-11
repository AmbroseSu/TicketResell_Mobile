//
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:http/http.dart' as http;
// import '../../api/global_variables/user_manage.dart';
// import '../../styles&text&sizes/image_strings.dart';
// import '../../styles&text&sizes/sizes.dart';
// import '../../styles&text&sizes/text_strings.dart';
// import '../../widgets/helper_functions.dart';
// import '../login/login.dart';
// import '../otp_verification/otp_verification.dart';
//
// class VerifyEmailScreen extends StatefulWidget {
//   const VerifyEmailScreen({super.key});
//
//   @override
//   _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
// }
//
// class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
//   final TextEditingController _emailController = TextEditingController();
//
//   Future<void> checkEmail(String email) async {
//     final url = 'https://trip-by-day-backend.onrender.com/api/v1/auth/check-email?email=$email';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     final body = jsonEncode({'email': email});
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );
//
//       print('Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       if (response.statusCode == 201) {
//         final responseData = json.decode(response.body);
//         //final userId = responseData['content']['id'];
//         //final userRole = responseData['content']['role'];
//         //final userEmail = responseData['content']['email'];
//
//         UserManager userManager = UserManager();
//         userManager.id = responseData['content']['id'];
//         userManager.email = responseData['content']['email'];
//         userManager.role = responseData['content']['role'];
//
//         // Chuyển đến OtpVerificationScreen với id và role
//         Get.to(() => OtpVerificationScreen());
//       } else {
//         print('Failed to check email');
//         Get.snackbar('Error', 'Failed to check email: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//       Get.snackbar('Error', 'An error occurred: $error');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             children: [
//               Image(image: const AssetImage(TImages.verifyEmailImage), width: THelperFunctions.screenWidth() * 0.6),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               Text(TTexts.confirmEmailTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               Text('support@gmail.com', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               Text(TTexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                     labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
//               ),
//               const SizedBox(height: TSizes.spaceBtwInputFields),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final email = _emailController.text.trim();
//                     if (email.isNotEmpty) {
//                       checkEmail(email);
//                     } else {
//                       Get.snackbar('Error', 'Please enter your email');
//                     }
//                   },
//                   child: const Text(TTexts.tContinue),
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               SizedBox(width: double.infinity, child: TextButton(onPressed: (){}, child: const Text(TTexts.resendEmail))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../../widgets/helper_functions.dart';
import '../login/login.dart';
import '../otp_verification/otp_verification.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _emailController = TextEditingController();

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
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              GestureDetector(
                onTap: () {
                  final email = _emailController.text.trim();
                  if (email.isNotEmpty) {
                    // Directly navigate to the OtpVerificationScreen
                    Get.to(() => OtpVerificationScreen());
                  } else {
                    Get.snackbar('Error', 'Please enter your email');
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

