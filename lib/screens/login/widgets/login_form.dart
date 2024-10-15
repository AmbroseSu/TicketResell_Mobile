import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';

import '../../../navigation_menu.dart';
import '../../../styles&text&sizes/sizes.dart';
import '../../../styles&text&sizes/text_strings.dart';
import '../../signup/verify_email.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;

  //late AlertService _alertService;

  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    //_alertService = _getIt.get<AlertService>();
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
              decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.email),
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            ///Password
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forger Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      checkColor: Colors.white,
                      // Color of the checkmark
                      activeColor: Colors.blueAccent,
                      // Background color when checked
                      side: BorderSide(
                          color: Colors.black), // Border color of the checkbox
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                /// Forget Password
                TextButton(
                    onPressed: () {},
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
                print("99999999999999999999999999999999999999999");
                if (_loginFormKey.currentState?.validate() ?? false) {
                  _loginFormKey.currentState?.save();
                  bool result = await _authService.login(email!, password!);
                  print("00000000000000000000000000000000000000000000");
                  print(result);
                  print(result);
                  if (result) {
                    print("1111111111111111111111111111111111111111111111111111111");
                    _navigationService.pushReplacementNamed("/navigation_menu");
                  } else {
                    print("6666666666666666666666666666666666666666666666666666666666666666");
                    // _alertService.showToast(
                    //   text: "Failed to login, Please try again!",
                    //   icon: Icons.error,
                    // );
                  }
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
                      color: Color(0xFFC7C5CC), width: 2), // Add border here
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
