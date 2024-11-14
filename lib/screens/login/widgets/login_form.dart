import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/api/auth_helper.dart';
import 'package:ticket_resell/api/global_variables/fcm_token_manage.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/api/request/sign_in_request.dart';
import 'package:ticket_resell/screens/password/create_newpass.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:http/http.dart' as http;
import '../../../navigation_menu.dart';
import '../../../styles&text&sizes/sizes.dart';
import '../../../styles&text&sizes/text_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../signup/verify_email.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserManager userManager = UserManager();
  bool _showPassword = false;
  late AuthService _authService;
  late NavigationService _navigationService;

  String? email, password;

  Future<void> _signIn(BuildContext context) async {
    try {
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      // Tạo SignInRequest từ dữ liệu người dùng nhập vào
      SignInRequest request = SignInRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fcmToken: TokenManager().fcmToken!,
      );

      print('00000000000000000000000000000' + request.email + request.password);

      var response = await http.post(
        Uri.parse(
            'https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Authentication/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print(response.statusCode);

      // Xử lý phản hồi từ API
      if (response.statusCode == 200) {
        // Phản hồi thành công, xử lý dữ liệu từ server ở đây
        var responseData = jsonDecode(response.body);
        var userDTO = responseData['content']['userDTO'];
        var token = responseData['content']['token'];
        print(userDTO);
        userManager.id = userDTO['id'];
        userManager.email = userDTO['email'];
        userManager.role = userDTO['role'];
        userManager.token = token;

        await saveLoginInfo(token);
        print(
            "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
        print(userManager.id);
        String? fcmToken = TokenManager().fcmToken;



        print("00000000000000000000000000000000000000000000000000000000000");

        Get.to(() => const NavigationMenu());

      } else {
        // Phản hồi lỗi từ API, hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to sign in. Please try again later.'),
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

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must start with an uppercase letter';
    }
    if (!RegExp(r'[!@$%&]').hasMatch(value)) {
      return 'Password must contain at least one special character (@!%&)';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            ///Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.email),
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: _emailValidator,  // Add email validator
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            ///Password
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              validator: _passwordValidator,  // Add password validator
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forger Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      checkColor: Colors.white,
                      activeColor: Colors.blueAccent,
                      side: BorderSide(color: Colors.black),
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateNewpass()),
                      );
                    },
                    child: const Text(
                      TTexts.forgotPassword,
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            GestureDetector(
              onTap: () async {
                if (_loginFormKey.currentState?.validate() ?? false) {
                  _loginFormKey.currentState?.save();
                  _signIn(context);
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
                    TTexts.signIn,
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

            /// Create Account Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyEmailScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                      color: Color(0xFFC7C5CC), width: 2),
                ),
                child: Center(
                  child: Text(
                    TTexts.createAccount,
                    style: GoogleFonts.getFont(
                      "Roboto Condensed",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}