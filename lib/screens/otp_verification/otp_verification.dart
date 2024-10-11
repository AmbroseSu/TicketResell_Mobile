//
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../api/global_variables/user_manage.dart';
// import '../../styles&text&sizes/image_strings.dart';
// import '../../styles&text&sizes/sizes.dart';
// import '../../styles&text&sizes/text_strings.dart';
// import '../signup/signup.dart';
// import '../success_screen/success_screen.dart';
//
// class OtpVerificationScreen extends StatefulWidget {
//
//   const OtpVerificationScreen({super.key});
//
//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   late Timer _timer;
//   int _start = 60;
//   final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _timer.cancel();
//         });
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _otpControllers.forEach((controller) => controller.dispose());
//     _focusNodes.forEach((focusNode) => focusNode.dispose());
//     super.dispose();
//   }
//
//   UserManager userManager = UserManager();
//
//   Future<void> verifyOtp(String otp) async {
//     final url = 'https://trip-by-day-backend.onrender.com/api/v1/auth/verify-email?token=$otp&id=${userManager.id}';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//
//     print('Sending POST request to $url');
//     print('Headers: $headers');
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//       );
//
//       print('Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       if (response.statusCode == 201) {
//         final responseData = json.decode(response.body);
//         print('Success: $responseData');
//         Get.to(() => SuccessScreen(
//           image: TImages.verifyEmailSuccess,
//           title: TTexts.yourAccountCreatedTitle,
//           subTitle: TTexts.yourAccountCreatedSubTitle,
//           onPressed: () => Get.to(() => const SignupScreen()),
//         ));
//       } else {
//         print('Failed to verify OTP');
//         Get.snackbar('Error', 'Failed to verify OTP: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//       Get.snackbar('Error', 'An error occurred: $error');
//     }
//   }
//
//   // void _nextField(int index, String value) {
//   //   if (value.isNotEmpty && index < _otpControllers.length - 1) {
//   //     FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//   //   } else if (value.isEmpty && index > 0) {
//   //     FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//   //   }
//   // }
//
//   void _nextField(int index, String value) {
//     if (value.isNotEmpty) {
//       if (index < _otpControllers.length - 1) {
//         FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//       } else {
//         FocusScope.of(context).unfocus(); // Để bỏ tiêu điểm nếu đã điền đầy đủ
//       }
//     } else if (index > 0) {
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue, // Set background color to blue
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               TImages.signupImage,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // White Form Container
//           Positioned.fill(
//             top: 200,
//             child: Container(
//               padding: const EdgeInsets.all(TSizes.md),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
//                       child: Text(
//                         TTexts.otpVerificationTitle,
//                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//
//                     // Subtitle
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
//                       child: Text(
//                         TTexts.otpVerificationSubTitle,
//                         style: Theme.of(context).textTheme.labelMedium,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//
//                     // OTP input fields
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(6, (index) {
//                         return SizedBox(
//                           width: 50,
//                           height: 50,
//                           child: TextField(
//                             controller: _otpControllers[index],
//                             focusNode: _focusNodes[index],
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               counterText: "",
//                             ),
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             textInputAction: TextInputAction.next,
//                             onChanged: (value) {
//                               _nextField(index, value);
//                             },
//                             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                           ),
//                         );
//                       }),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//
//                     // Timer and Resend OTP
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: TSizes.md),
//                           child: Text(
//                             'Time Remaining 00:${_start.toString().padLeft(2, '0')}',
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // Resend OTP logic here
//                           },
//                           child: const Text(
//                             TTexts.resendOTP,
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//
//                     // Verification button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           final otp = _otpControllers.map((controller) => controller.text).join();
//                           if (otp.length == 6) {
//                             verifyOtp(otp);
//                           } else {
//                             Get.snackbar('Error', 'Please enter the complete OTP');
//                           }
//                         },
//                         child: const Text(TTexts.verificationButton),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../styles&text&sizes/text_strings.dart';
import '../signup/signup.dart';
import '../success_screen/success_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _start = 60;
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _nextField(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _otpControllers.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus(); // Remove focus if all fields are filled
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to blue
      body: Stack(
        children: [
          // // Background Image
          // Positioned.fill(
          //   child: Image.asset(
          //     TImages.signupImage,
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // White Form Container
          Positioned.fill(
            // top: 200,
            top: 50,
            child: Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                      child: Text(
                        // TTexts.otpVerificationTitle,
                        'Verify your email 2/3',

                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                      child: Text(
                        TTexts.otpVerificationSubTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              _nextField(index, value);
                            },
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Timer and Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.md),
                          child: Text(
                            'Time Remaining 00:${_start.toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Resend OTP logic here
                          },
                          child: const Text(
                            TTexts.resendOTP,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Verification button
                    GestureDetector(
                      onTap: () {
                        final otp = _otpControllers.map((controller) => controller.text).join();
                        if (otp.length == 6) {
                          // Directly navigate to SuccessScreen for UI testing
                          Get.to(() => SuccessScreen(
                            image: TImages.verifyEmailSuccess,
                            title: TTexts.yourAccountCreatedTitle,
                            subTitle: TTexts.yourAccountCreatedSubTitle,
                            onPressed: () => Get.to(() => const SignupScreen()),
                          ));
                        } else {
                          Get.snackbar('Error', 'Please enter the complete OTP');
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
                            TTexts.verificationButton,
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
        ],
      ),
    );
  }
}
