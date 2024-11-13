import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/response/change_password.dart';
import 'package:ticket_resell/screens/password/reset_password.dart';
import '../../styles&text&sizes/sizes.dart';
import 'package:http/http.dart' as http;
import '../../styles&text&sizes/text_strings.dart';

class CreateNewpass extends StatefulWidget {
  const CreateNewpass({super.key});

  @override
  State<CreateNewpass> createState() => _CreateNewpassState();
}

class _CreateNewpassState extends State<CreateNewpass> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  UserManager userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Headings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Text(
                'Create your password',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Text fields
            TextFormField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                  labelText: TTexts.currentPassword,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                  labelText: TTexts.newPassword,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            TextFormField(
              controller: _passwordConfirmController,
              decoration: const InputDecoration(
                  labelText: TTexts.conPassword,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Submit Button
            GestureDetector(
              onTap: () {
                _changePassword(context);
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
            const SizedBox(height: TSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    try {
      print('Email: ${_currentPasswordController.text}');
      print('Password: ${_newPasswordController.text}');
      print('Password: ${_passwordConfirmController.text}');

      if(_newPasswordController.text != _passwordConfirmController.text){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('New Password not match with Confirm Password. Please Check again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }else{
        ChangePasswordRequest request = ChangePasswordRequest(
          email: userManager.email!,
          password: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        print('00000000000000000000000000000' + request.email + request.password);

        // Gửi yêu cầu POST đến API
        var response = await http.post(
          Uri.parse(
              'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Authentication/change-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson()),
        );

        print(response.statusCode);
        var responseData = jsonDecode(response.body);

        // Xử lý phản hồi từ API
        if (responseData['statusCode'] == 200) {
          print("00000000000000000000000000000000000000000000000000000000000");

          Get.to(() => const ResetPassword());

        } else {
          // Phản hồi lỗi từ API, hiển thị thông báo lỗi
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Current Password Not Match'),
                content: Text('Failed to Change Password. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
      // Tạo SignInRequest từ dữ liệu người dùng nhập vào

    } catch (e) {
      // Xử lý lỗi trong quá trình gửi yêu cầu
      print('Error occurred during sign-in: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
